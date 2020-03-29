//
//  IndividualFactory.swift
//  Evolution
//
//  Created by Alex Frankiv on 08.02.2020.
//  Copyright © 2020 g_f0x. All rights reserved.
//

import Foundation

final class IndividualFactory {

	// MARK: - Constants
	static let perfectSymbol = Symbol.A

	// MARK: - Generation rule
	enum GenerationRule {
		case uber
//		case uniform, // deprecated
		case normal(Double)

		var stringRepresentation: String {
			switch self {
			case .uber: return "perfect"
			case .normal(let v): return "normal\(Int(v))"
			}
		}
	}

	// MARK: - Parameters
	let length: Int
	let populationSize: Int

	lazy var uberIndividual: Individual = { newUberIndividual() }()

	// MARK: - Initialisation
	init(length: Int, populationSize: Int) {
		self.length = length
		self.populationSize = populationSize
	}

	// MARK: - Generating über population
	// perfect individual according to the task
	private func newUberIndividual() -> Individual {
		return Array<Symbol>(repeating: Self.perfectSymbol, count: self.length)
	}

	private func newUberPopulation() -> Population {
		return Array<Individual>(repeating: newUberIndividual(), count: self.populationSize)
	}

	// MARK: - Generating uniform population (deprecated)
//	private func newUniformPopulation() -> Population {
//		return self.population(accordingTo: Distributions.Uniform(a: 0, b: Double(length)))
//	}

	// MARK: - Generating normal population
	private func newNormalPopulation(sigma: Double) -> Population {
		return self.population(accordingTo: Distributions.Normal(m: 0, v: sigma))
	}

	// MARK: - Public API
	func newPopulation(_ rule: GenerationRule) -> Population {
		switch rule {
		case .uber: return newUberPopulation()
//		case .uniform: return newUniformPopulation() // deprecated
		case .normal(let sigma): return newNormalPopulation(sigma: sigma)
		}
	}

	// MARK: - Generating population according to distribution
	private func population(accordingTo distribution: ContinuousDistribution) -> Population {
		let hammingDistances = distribution.random(populationSize).map { Int(abs($0).rounded()) }
		print(hammingDistances)
		let uniDistribution = Distributions.Uniform(a: 0, b: Double(length) - 1)
		var initialPopulation = newUberPopulation()
		for (hammingDistance, individualIndex) in zip(hammingDistances, initialPopulation.indices) {
			let indicesToMutate = uniDistribution.random(hammingDistance).map { Int($0.rounded()) }
			for index in indicesToMutate {
				initialPopulation[individualIndex][index].mutate()
			}
		}
		return initialPopulation
	}
}
