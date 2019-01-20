//
//  ResultVC.swift
//  Personal Quiz
//
//  Created by Valentin Kiselev on 08/12/2018.
//  Copyright © 2018 Valentin Kiselev. All rights reserved.
//

import UIKit

class ResultVC: UIViewController {
	
	var resultLabel: UILabel!
	var definitionLabel: UILabel!
	
	var results: [AnimalType: Int] = [.dog: 0, .cat: 0, .rabbit: 0, .turtle: 0]
	var answers = [WhatAnimalYouAreAnswer]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		whatAnimalYouAre()
	}
	
	
	func whatAnimalYouAre() {
		for answer in answers {
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
		var font = resultLabel.font.withSize(49)
		resultLabel.attributedText = "You are \(userAnimal.key.rawValue)".makeAttributed(font: font)
		font = definitionLabel.font.withSize(26)
		definitionLabel.attributedText = userAnimal.key.definition.makeAttributed(font: font)
	}
	
	func setupUI() {
		view.backgroundColor = .white
		setupNavigationBar()
		resultLabel = UILabel()
		resultLabel.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(resultLabel)
		resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		resultLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 140).isActive = true
		
		definitionLabel = UILabel()
		definitionLabel.lineBreakMode = .byWordWrapping
		definitionLabel.textAlignment = .center
		definitionLabel.numberOfLines = 0
		definitionLabel.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(definitionLabel)
		definitionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
		definitionLabel.centered()
	}
	
	func setupNavigationBar() {
		self.navigationItem.title = "Quiz result"
		self.navigationItem.setHidesBackButton(true, animated: false);
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Try again", style: .done, target: self, action: #selector(donePressed))
	}
	
	@objc func donePressed(_ sender: UIBarButtonItem) {
		self.dismiss(animated: true, completion: nil)
	}
}
