//
//  ResultVC.swift
//  Personal Quiz
//
//  Created by Valentin Kiselev on 08/12/2018.
//  Copyright © 2018 Valentin Kiselev. All rights reserved.
//

import UIKit

class ResultVC: UIViewController {
	
	@IBOutlet weak var resultLabel: UILabel!
	@IBOutlet weak var definitionLabel: UILabel!
	
	var results: [AnimalType: Int] = [.dog: 0, .cat: 0, .rabbit: 0, .turtle: 0]
	var answers = [WhatAnimalYouAreAnswer]()

    override func viewDidLoad() {
        super.viewDidLoad()
		for answer in answers {
		print(answer.type)
			switch answer.type {
			case .dog:
				results[.dog] = results[.dog]! + 1
			case .cat:
				results[.cat] = results[.cat]! + 1
			case .rabbit:
				results[.rabbit] = results[.rabbit]! + 1
			case .turtle:
				results[.turtle] = results[.turtle]! + 1
			}
		}
		var userAnimal = results.popFirst()!
		for result in results {
			if result.value > userAnimal.value {
				userAnimal = result
			}
		}
		resultLabel.text = "You are \(userAnimal.key.rawValue)"
		definitionLabel.text = userAnimal.key.definition
		
		navigationItem.setHidesBackButton(true, animated: false)
    }
	
}
