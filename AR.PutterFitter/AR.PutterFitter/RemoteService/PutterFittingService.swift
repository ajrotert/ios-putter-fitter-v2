//
//  PutterFittingService.swift
//  AR.PutterFitter
//
//  Created by Andrew Rotert on 7/24/22.
//

import Foundation
protocol PutterFittingService {
    func getMatches(userWeights: UserWeights, success: (([PutterData], String) -> ())?, failure: ((Error?) -> ())?)
}

class RemotePutterFittingService {
    private let dominanteImportance = 1
    private let pathImportance = 5
    private let accuracyImportance = 3
    private let distanceImportance = 2
    private let alignmentImportance = 3
    
    private var service: PutterDataService = RemotePutterDataService()
    
    private var shape: PutterCharacteristics?
    private var balance: PutterCharacteristics?
    private var hosel: PutterCharacteristics?
    private var weight: PutterCharacteristics?

    private var heap = FittingHeap()
    
    init(service: PutterDataService) {
        self.service = service
    }
    
    private func setPutterCharacteristics(userWeights: UserWeights) {
        if userWeights.selectedAlignmentOption == FittingData.AlignmentStruggles {
            self.shape = PutterCharacteristics(importance: self.alignmentImportance, trait: "Wide Putter Head")
            self.heap.insert(data: self.shape!)
        } else if userWeights.selectedAlignmentOption == FittingData.AlignmentGood {
            self.shape = PutterCharacteristics(importance: self.alignmentImportance, trait: "Normal Putter Head")
            self.heap.insert(data: self.shape!)
        }
        
        if userWeights.selectedPathOption == FittingData.PathArcing {
            self.balance = PutterCharacteristics(importance: self.pathImportance, trait: "Toe Weighted")
            self.heap.insert(data: self.balance!)
        } else if userWeights.selectedPathOption == FittingData.PathStraight && userWeights.selectedAccuracyOption != FittingData.AccuracyMissLeft {
            self.balance = PutterCharacteristics(importance: self.pathImportance, trait: "Face Balanced")
            self.heap.insert(data: self.balance!)
        } else if userWeights.selectedPathOption == FittingData.PathStraight && userWeights.selectedAccuracyOption == FittingData.AccuracyMissLeft {
            self.balance = PutterCharacteristics(importance: self.pathImportance, trait: "Face Balanced*")
            self.heap.insert(data: self.balance!)
        }
        
        if userWeights.selectedDominantOption == FittingData.EyeDominanceRightHandedRightDominant || userWeights.selectedDominantOption == FittingData.EyeDominanceLeftHandedLeftDominant {
            self.hosel = PutterCharacteristics(importance: self.dominanteImportance, trait: "Offset Shaft")
            self.heap.insert(data: self.hosel!)
        } else if userWeights.selectedDominantOption == FittingData.EyeDominanceRightHandedLeftDominant || userWeights.selectedDominantOption == FittingData.EyeDominanceLeftHandedRightDominant {
            self.hosel = PutterCharacteristics(importance: self.dominanteImportance, trait: "Straight Shaft")
            self.heap.insert(data: self.hosel!)
        }
        
        if userWeights.selectedDistanceOption == FittingData.DistanceMissLong {
            self.weight = PutterCharacteristics(importance: self.distanceImportance, trait: "Lighter Weight")
            self.heap.insert(data: self.weight!)
        } else if userWeights.selectedDistanceOption == FittingData.DistanceMissShort {
            self.weight = PutterCharacteristics(importance: self.distanceImportance, trait: "Heavier Weight")
            self.heap.insert(data: self.weight!)
        } else if userWeights.selectedDistanceOption == FittingData.DistanceAccurate || userWeights.selectedDistanceOption == FittingData.DistanceIncosistent {
            self.weight = PutterCharacteristics(importance: self.distanceImportance, trait: "Standard Weight")
            self.heap.insert(data: self.weight!)
        }
    }
    
    private func calculatePutterMatches(putterData: [PutterData], userWeights: [String]) -> [PutterData] {
        var dataList = [PutterData]()
        for data in putterData {
            if data.weights?.contains("»\(userWeights[0])»") ?? false {
                dataList.append(data)
            }
        }
        
        if dataList.count == 0 {
            if putterData.count > 0 {
                dataList.append(putterData.first!)
            }
        }
        
        var tracking = Array.init(repeating: 0, count: dataList.count)
        var trackingCount: Int = 0
        
        for a in 1..<userWeights.count {
            for b in 0..<dataList.count {
                if dataList.count == 0 {
                    break;
                }
                
                if !(dataList[b].weights?.contains("»\(userWeights[a])»") ?? false) {
                    tracking[trackingCount] = b
                    trackingCount += 1
                }
            }
            
            if trackingCount <= dataList.count - 1 {
                var eliminated: Int = 0
                for b in 0..<trackingCount {
                    dataList.remove(at: tracking[b] - eliminated)
                    eliminated += 1
                }
                trackingCount = 0
            }
            trackingCount = 0
        }
        return dataList
    }
    
    private func calculateMatching(data: PutterData?) -> Float {
        
        guard let data = data else {
            return 0.0
        }
        
        let total:Float = Float(shape?.importance ?? 0) + Float(balance?.importance ?? 0) + Float(hosel?.importance ?? 0) + Float(weight?.importance ?? 0)
        var matchingC:Float = 0
        if data.weights?.contains(shape?.trait ?? "") ?? false {
            matchingC += Float(shape?.importance ?? 0)
        }
        if data.weights?.contains(balance?.trait ?? "") ?? false {
            matchingC += Float(balance?.importance ?? 0)
        }
        if data.weights?.contains(hosel?.trait ?? "") ?? false {
            matchingC += Float(hosel?.importance ?? 0)
        }
        if data.weights?.contains(weight?.trait ?? "") ?? false {
            matchingC += Float(weight?.importance ?? 0)
        }
        return ((matchingC - 0.05) / total) * 100
    }
}

extension RemotePutterFittingService : PutterFittingService {
    func getMatches(userWeights: UserWeights, success: (([PutterData], String) -> ())?, failure: ((Error?) -> ())?) {
        service.getPutterData { [weak self] putterData in
            guard let self = self else {
                return
            }
            
            self.setPutterCharacteristics(userWeights: userWeights)
            
            var weights = [String]()
            while self.heap.count() > 0 {
                if let weight = self.heap.delete() {
                    weights.append(weight.trait)
                }
            }
            
            let res = self.calculatePutterMatches(putterData: putterData, userWeights: weights)
            let match = self.calculateMatching(data: res.first)
            
            success?(res, "\(res.count) Result\(putterData.count > 1 ? "s" : "") - (\(String(format: "%.2f", match))% Match)")
        } failure: { error in
            failure?(error)
        }

    }
}
