//
//  QuestionVC.swift
//  Personal Quiz
//
//  Created by Valentin Kiselev on 08/12/2018.
//  Copyright © 2018 Valentin Kiselev. All rights reserved.
//

import UIKit

class QuestionVC: UIViewController {
	
	// MARK: - IBOutlet properties
	@IBOutlet weak var singleStackView: UIStackView!
	@IBOutlet weak var multipleStackView: UIStackView!
	@IBOutlet weak var rangerStackView: UIStackView!
	@IBOutlet weak var questionLabel: UILabel!
	@IBOutlet weak var progressBar: UIProgressView!
	@IBOutlet weak var slider: UISlider!
	
	var questions: [Question] = [
		Question(text: "What do you prefer to eat?", type: .single, answers: [
			WhatAnimalYouAreAnswer(text: "Meat", type: .dog),
			WhatAnimalYouAreAnswer(text: "Fish", type: .cat),
			WhatAnimalYouAreAnswer(text: "Carrot", type: .rabbit),
			WhatAnimalYouAreAnswer(text: "Corn", type: .turtle)]),
		Question(text: "What do you prefer to do?", type: .multiple, answers: [
			WhatAnimalYouAreAnswer(text: "To gnaw slippers", type: .dog),
			WhatAnimalYouAreAnswer(text: "To sleep", type: .cat),
			WhatAnimalYouAreAnswer(text: "To jump", type: .rabbit),
			WhatAnimalYouAreAnswer(text: "To swim", type: .turtle)]),
		Question(text: "How do you feel about traveling?", type: .ranged, answers: [
			WhatAnimalYouAreAnswer(text: "I hate It!", type: .cat),
			WhatAnimalYouAreAnswer(text: "I'm afraid", type: .rabbit),
			WhatAnimalYouAreAnswer(text: "I don't notice it", type: .turtle),
			WhatAnimalYouAreAnswer(text: "I love it!", type: .dog)]),
		]
	var outerIndex = 0
	
	var answers = [WhatAnimalYouAreAnswer]()
	
	lazy var step: Float = 1.0 / Float(questions.count)
	
	var questionIndex = 0 {
		didSet {
			if questionIndex == questions.count {
				performSegue(withIdentifier: "ShowResult", sender: nil)
				questionIndex = 0
			}
			updateUI()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		updateUI()
		
	}
	
	// MARK: - Methods
	
	func updateUI() {
		singleStackView.isHidden = true
		multipleStackView.isHidden = true
		rangerStackView.isHidden = true
		
		navigationItem.title = "Question #\(questionIndex + 1)"
		questionLabel.text = questions[questionIndex].text
		
		progressBar.progress = step * Float(questionIndex)
		
		let question = questions[questionIndex]
		
		switch question.type{
		case .single:
			singleStackView.isHidden = false
			showSingleAnswerQuestion(on: singleStackView)
		case .multiple:
			outerIndex = 0
			multipleStackView.isHidden = false
			showMultipleAnswerQuestion(on: multipleStackView, outerIndex: &outerIndex)
			
		case .ranged:
			rangerStackView.isHidden = false
			showRangedAnswerQuestion(on: rangerStackView)
		}
	}
	
	func showSingleAnswerQuestion(on view: UIStackView) {
		let maxIndex = questions[questionIndex].answers.count
		for (index, view) in view.subviews.enumerated(){
			guard index < maxIndex else { break }
			if let button = view as? UIButton {
				button.setTitle(questions[questionIndex].answers[index].text, for: [])
			}
		}
	}
	
	func showMultipleAnswerQuestion(on view: UIStackView, outerIndex: inout Int) {
		let maxIndex = questions[questionIndex].answers.count
		for (index, view) in view.subviews.enumerated(){
			guard index < maxIndex else { break }
			if let label = view as? UILabel {
				label.text = questions[questionIndex].answers[outerIndex].text
			} else if let stack = view as? UIStackView {
				showMultipleAnswerQuestion(on: stack, outerIndex: &outerIndex)
				outerIndex += 1
			}
		}
	}
	
	func showRangedAnswerQuestion(on view: UIStackView) {
		let maxIndex = questions[questionIndex].answers.count
		for (index, view) in view.subviews.enumerated(){
			guard index < maxIndex else { break }
			if let label = view as? UILabel {
				switch index {
				case 0:
					label.text = questions[questionIndex].answers[index].text
				case 1:
					label.text = questions[questionIndex].answers.last!.text
				default:
				break
				}
			} else if let stack = view as? UIStackView {
				showRangedAnswerQuestion(on: stack)
				outerIndex += 1
			}
		}
	}
	
	func readAnswer(from button: UIButton) {
		for answer in questions[questionIndex].answers {
			if button.currentTitle == answer.text {
				answers.append(answer)
			}
		}
	}
	
	func getAnswer(for question: Question, from stack: UIStackView, outerIndex: inout Int) {
		
		let maxIndex = questions[questionIndex].answers.count
		
		for (index, view) in stack.subviews.enumerated() {
			guard index < maxIndex else { break }
			let answer = question.answers[outerIndex]
			switch view {
			case is UISwitch:

				let switcher = view as! UISwitch
				if switcher.isOn {
					answers.append(answer)
				}
			case is UISlider:
				print("slider")
			case is UILabel:
				print("label")
			case is UIStackView:
				getAnswer(for: question, from: view as! UIStackView, outerIndex: &outerIndex)
				outerIndex += 1
			default:
				print("none")
				break
			}
		}
		
	}
	
	func readAnswer(from slider: UISlider) {
		let answerIndex = Int((Float(questions[questionIndex].answers.count - 1) * slider.value))
		answers.append(questions[questionIndex].answers[answerIndex])
	}

	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ShowResult" {
			if let DVC = segue.destination as? ResultVC {
				DVC.answers = answers
			}
		}
		answers.removeAll()
	}

	// MARK: - IBAction methods
	@IBAction func sliderChanged(_ sender: UISlider) {
		let roundedValue = round(sender.value / step) * step
		sender.setValue(roundedValue, animated: true)
	}
	
	@IBAction func questionAnswered(_ sender: UIButton) {
		defer {
			questionIndex += 1
		}
		
		let question = questions[questionIndex]
		switch question.type{
		case .single:
			readAnswer(from: sender)
		case .multiple:
			outerIndex = 0
			getAnswer(for: question, from: multipleStackView, outerIndex: &outerIndex)
		case .ranged:
			readAnswer(from: slider)
		}
	}
	
}
