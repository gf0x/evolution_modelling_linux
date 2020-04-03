//
//  AnalysisStats.swift
//  Evolution
//
//  Created by Alex Frankiv on 29.03.2020.
//  Copyright © 2020 g_f0x. All rights reserved.
//

import Foundation

struct AnalysisStats: Codable {
	let hammingDistancePairs: HammingDistancePairs
	let hammingDistanceTarget: HammingDistanceTarget
	let hammingDistanceWild: HammingDistanceWild
	let singlePolymorphicGenesPercentageAccornigToTarget: Double
	let multiplePolymorphicGenesPercentageAccornigToTarget: Double
	let polymorphicGenesPercentageAccornigToWildType: Double
	let wildTypeInfo: WildTypeInfo
	let averageHealthDeviation: Double
	let maxHealthDeviation: Double
}

/// Used to represent analysis data for paired distances for each individual
struct HammingDistancePairs: Codable {
	/// First Int means Ham. distance, second – the amount of such distances
	let pairedDistancesEnumerated: [Int: Int]
	let stats: Stats
}

/// Used to represent analysis data for paired distances to target individual
struct HammingDistanceTarget: Codable {
	/// First Int means Ham. distance, second – the amount of such distances
	let distancesEnumerated: [Int: Int]
	let stats: Stats
}

/// Used to represent analysis data for paired distances to wild type individual
struct HammingDistanceWild: Codable {
	let wildType: Individual
	/// First Int means Ham. distance, second – the amount of such distances
	let distancesEnumerated: [Int: Int]
	let stats: Stats
}
