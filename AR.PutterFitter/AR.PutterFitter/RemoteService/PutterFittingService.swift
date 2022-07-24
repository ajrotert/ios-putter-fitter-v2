//
//  PutterFittingService.swift
//  AR.PutterFitter
//
//  Created by Andrew Rotert on 7/24/22.
//

import Foundation
protocol PutterFittingService {
    func getMatches(userWeights: [String], success: (([PutterData], String) -> ())?, failure: ((Error?) -> ())?)
}

class RemotePutterFittingService {
    private var service: PutterDataService = RemotePutterDataService()
    init(service: PutterDataService) {
        self.service = service
    }
}

extension RemotePutterFittingService : PutterFittingService {
    func getMatches(userWeights: [String], success: (([PutterData], String) -> ())?, failure: ((Error?) -> ())?) {
        service.getPutterData { putterData in
            //TODO: Find Matches
            success?(putterData, "\(putterData.count) Result\(putterData.count > 1 ? "s" : "") - (83.33% Match)")
        } failure: { error in
            failure?(error)
        }

    }
}
