//
//  main.swift
//  Evolution
//
//  Created by Alex Frankiv on 08.02.2020.
//  Copyright © 2020 g_f0x. All rights reserved.
//

import Foundation

print("Запуск")
var pX = 0.0
var healthComputing = HealthComputing.const
//let dispatchGroup = DispatchGroup()
var numberOfExperiment = 0
// MARK: - Run all the experiments
for length in lengthAndPopulationSizeSettings.keys {
    let healthStandard = HealthStandardFactory.single.healthStandard(for: length)
    //	for computing in (length >= 100) ? HealthComputing.allCases : [.const] {
    healthComputing = HealthComputing.const //computing
    for populationSize in lengthAndPopulationSizeSettings[length]! {
        let factory = IndividualFactory(length: length, populationSize: populationSize)
        for parentChoosing in parentChoosingSettings {
            // not needed in this case
//            pX = getPx(forSelectionType: parentChoosing, length: length, populationSize: populationSize)
            for generatingRule in populationGeneratingRulesSettings {
                for pM in pmSettings {
                    for repetition in 1...repetitionSettings {
                        numberOfExperiment += 1
                        let expNum = numberOfExperiment
                        //                            DispatchQueue.global().async(group: dispatchGroup, qos: .userInteractive) {
                        performExperiment(numberOfExperiment: expNum,
                                          length: length,
                                          populationSize: populationSize,
                                          parentChoosing: parentChoosing,
                                          generatingRule: generatingRule,
                                          pM: pM,
                                          repetition: repetition,
                                          healthStandard: healthStandard,
                                          factory: factory)
                        //                            }
                    }
                }
            }
        }
    }
    //	}
}
//dispatchGroup.wait()

func performExperiment(
    numberOfExperiment: Int,
	length: Int,
	populationSize: Int,
	parentChoosing: ParentChoosing,
	generatingRule: IndividualFactory.GenerationRule,
	pM: MutationProbability,
	repetition: Int,
	healthStandard: HealthStandard,
	factory: IndividualFactory
) {
	let experimentIdentifier =
	"init_\(generatingRule)__l_\(length)__n_\(populationSize)__f_\(healthComputing.rawValue)__\(parentChoosing.stringRepresentation)__pm_\(pM.rawValue)__run_\(repetition)"
	print(experimentIdentifier)
	var analysisStats = [AnalysisStats]()

	var population = factory.newPopulation(generatingRule)

	// MARK: - Main loop (2.0)
	print("\r\nЗапуск експеримента №\(numberOfExperiment)\r\n")
	let formatter = DateFormatter()
	formatter.dateFormat = "HH:mm:ss"
	for iteration in (1...numberOfIterationsSetting) {

        print("Експеримент \(numberOfExperiment) Ітерація: \(iteration) "
            + "\(formatter.string(from: Date())) (\(Double(iteration) / Double(numberOfIterationsSetting) * 100)%)")

		// MARK: - Evaluation (2.1)
		var evaluatedPopulation = population.map { ($0, healthStandard.testFitness(individual: $0)) }

		// MARK: - Kill unhealthy (2.2)
		evaluatedPopulation = evaluatedPopulation.filter { (_, health) in
			// assume that according to the task health of 0.1 is only possible if individual has lethal mutations
			health > 0.1
		}
		// stop if all the individuals are dead
		if evaluatedPopulation.isEmpty { break }

		// MARK: - Analyze + export data
		let analysisData = AnalysisEngine.single.analyze(evaluatedPopulation, individualFactory: factory)
		analysisStats.append(analysisData)

		// MARK: - Choose parents' pool (2.3)
		population = parentChoosing.parents(from: evaluatedPopulation, populationSize: Int(populationSize))

		// MARK: - Commit mutations (2.4)
		population.mutateAll(withProbability: pM.value)
	}

	let experimentStats = ExperimentStats(identifier: experimentIdentifier,
										  stats: analysisStats)
	let data = try! JSONEncoder().encode(experimentStats)
	let filename = URL(string: "file://\(CommandLine.arguments[1])\(experimentIdentifier).json")!
	try! data.write(to: filename)
}
