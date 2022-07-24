//
//  FittingData.swift
//  AR.PutterFitter
//
//  Created by Andrew Rotert on 7/23/22.
//

import Foundation

class FittingData {
    
    private static var EyeDominanceCharacteristic: FittingCharacteristic = {
        return FittingCharacteristic(options: [FittingOption(name: "Left Handed, Left Eye Dominant", icon: "Left"), FittingOption(name: "Right Handed, Right Eye Dominant", icon: "Right"), FittingOption(name: "Left Handed, Right Eye Dominant", icon: "Left"), FittingOption(name: "Right Handed, Left Eye Dominant", icon: "Right")], title: "Please select your dominant eye: ")
    }()
    
    private static var PathCharacteristic: FittingCharacteristic = {
        return FittingCharacteristic(options: [FittingOption(name: "Arcing Path", icon: "Arcing"), FittingOption(name: "Straight Path", icon: "Straight")], title: "Please select your putting path: ")
    }()
    
    private static var AccuracyCharacteristic: FittingCharacteristic = {
        return FittingCharacteristic(options: [FittingOption(name: "Misses Left", icon: "Left-Miss"), FittingOption(name: "Right", icon: "Right-Miss"), FittingOption(name: "Inconsistent", icon: "Incosistent"), FittingOption(name: "Accurate", icon: "Accurate")], title: "Please select your putting accuracy: ")
    }()
    
    private static var DistanceCharacteristic: FittingCharacteristic = {
        return FittingCharacteristic(options: [FittingOption(name: "Misses Long", icon: "Long"), FittingOption(name: "Misses Short", icon: "Short"), FittingOption(name: "Inconsistent", icon: "Incosistent"), FittingOption(name: "Accurate", icon: "Accurate")], title: "Please select your putting distance control: ")
    }()
    
    private static var AlignmentCharacteristic: FittingCharacteristic = {
        return FittingCharacteristic(options: [FittingOption(name: "Struggles with Alignment", icon: "Struggles"), FittingOption(name: "Good with Alignment", icon: "Good")], title: "Please select your putting alignment: ")
    }()
    
    static func GetCharacteristicOptions() -> [FittingCharacteristic] {
        return [
            FittingData.EyeDominanceCharacteristic,
            FittingData.PathCharacteristic,
            FittingData.AccuracyCharacteristic,
            FittingData.DistanceCharacteristic,
            FittingData.AlignmentCharacteristic
        ]
    }
}
struct FittingCharacteristic {
    internal init(options: [FittingOption], title: String) {
        self.options = options
        self.title = title
    }
    
    public var options: [FittingOption]
    public var title: String
}
struct FittingOption {
    internal init(name: String, icon: String) {
        self.name = name
        self.icon = icon
    }
    
    public var name: String
    public var icon: String
}
