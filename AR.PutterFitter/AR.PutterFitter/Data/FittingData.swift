//
//  FittingData.swift
//  AR.PutterFitter
//
//  Created by Andrew Rotert on 7/23/22.
//

import Foundation

class FittingData {
    
    public static var EyeDominanceLeftHandedLeftDominant = "Left Handed, Left Eye Dominant"
    public static var EyeDominanceRightHandedRightDominant = "Right Handed, Right Eye Dominant"
    public static var EyeDominanceLeftHandedRightDominant = "Left Handed, Right Eye Dominant"
    public static var EyeDominanceRightHandedLeftDominant = "Right Handed, Left Eye Dominant"
    private static var EyeDominanceCharacteristic: FittingCharacteristic = {
        return FittingCharacteristic(options: [FittingOption(name: FittingData.EyeDominanceLeftHandedLeftDominant, icon: "Left"), FittingOption(name: FittingData.EyeDominanceRightHandedRightDominant, icon: "Right"), FittingOption(name: FittingData.EyeDominanceLeftHandedRightDominant, icon: "Left"), FittingOption(name: FittingData.EyeDominanceRightHandedLeftDominant, icon: "Right")], title: "Please select your dominant eye: ")
    }()
    
    public static var PathArcing = "Arcing Path"
    public static var PathStraight = "Straight Path"
    private static var PathCharacteristic: FittingCharacteristic = {
        return FittingCharacteristic(options: [FittingOption(name: FittingData.PathArcing, icon: "Arcing"), FittingOption(name: FittingData.PathStraight, icon: "Straight")], title: "Please select your putting path: ")
    }()
    
    public static var AccuracyMissLeft = "Misses Left"
    public static var AccuracyMissRight = "Misses Right"
    public static var AccuracyIncosistent = "Inconsistent"
    public static var AccuracyAccurate = "Accurate"
    private static var AccuracyCharacteristic: FittingCharacteristic = {
        return FittingCharacteristic(options: [FittingOption(name: FittingData.AccuracyMissLeft, icon: "Left-Miss"), FittingOption(name: FittingData.AccuracyMissRight, icon: "Right-Miss"), FittingOption(name: FittingData.AccuracyIncosistent, icon: "Incosistent"), FittingOption(name: FittingData.AccuracyAccurate, icon: "Accurate")], title: "Please select your putting accuracy: ")
    }()
    
    public static var DistanceMissLong = "Misses Long"
    public static var DistanceMissShort = "Misses Short"
    public static var DistanceIncosistent = "Inconsistent"
    public static var DistanceAccurate = "Accurate"
    private static var DistanceCharacteristic: FittingCharacteristic = {
        return FittingCharacteristic(options: [FittingOption(name: DistanceMissLong, icon: "Long"), FittingOption(name: FittingData.DistanceMissShort, icon: "Short"), FittingOption(name: FittingData.DistanceIncosistent, icon: "Incosistent"), FittingOption(name: FittingData.DistanceAccurate, icon: "Accurate")], title: "Please select your putting distance control: ")
    }()
    
    public static var AlignmentStruggles = "Struggles with Alignment"
    public static var AlignmentGood = "Good with Alignment"
    private static var AlignmentCharacteristic: FittingCharacteristic = {
        return FittingCharacteristic(options: [FittingOption(name: AlignmentStruggles, icon: "Struggles"), FittingOption(name: AlignmentGood, icon: "Good")], title: "Please select your putting alignment: ")
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
