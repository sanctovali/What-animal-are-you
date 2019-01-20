//
//  QuestionVC.swift
//  Personal Quiz
//
//  Created by Valentin Kiselev on 08/12/2018.
//  Copyright © 2018 Valentin Kiselev. All rights reserved.
//

import UIKit

import UIKit

class QuestionsVC: UIViewController {
	
	let questionFontSize: CGFloat = 26
	let answersFontSize: CGFloat = 17
	
	var answersStackView: UIStackView!
	var questionLabel: UILabel!
	var progressBar: UIProgressView!
	var answerButton: UIButton!
	
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
	var questionIndex = 0 {
		didSet {
			if questionIndex == questions.count {
				let resultVC = ResultVC()
				navigationController?.pushViewController(resultVC, animated: true)
				resultVC.answers = answers
				questionIndex = 0
			}
			updateUI()
		}
	}
	var outerIndex = 0
	
	var answers = [WhatAnimalYouAreAnswer]()
	lazy var step: Float = 1.0 / Float(questions.count)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		self.title = "Questions"
		updateUI()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		//view.removeFromSuperview()
	}
	
	func updateUI() {
		progressBar = UIProgressView(progressViewStyle: .default)
		view.addSubview(progressBar)
		progressBar.tintColor = .blue
		progressBar.translatesAutoresizingMaskIntoConstraints = false
		progressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		progressBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
		progressBar.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
		progressBar.setProgress(step * Float(questionIndex + 1), animated: true)
		
		navigationItem.title = "Question #\(questionIndex + 1)"
		if questionLabel == nil {
			questionLabel = UILabel()
			view.addSubview(questionLabel)
			questionLabel.numberOfLines = 0
			questionLabel.textAlignment = .center
			questionLabel.lineBreakMode = .byWordWrapping
			questionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95).isActive = true
			questionLabel.translatesAutoresizingMaskIntoConstraints = false
			questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
			questionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 110).isActive = true
			questionLabel.textAlignment = .center
		}
		
		
		if answersStackView != nil {
			//®answersStackView.clear()
			answersStackView.removeFromSuperview()
		}
		
		let font  = questionLabel.font.withSize(questionFontSize)
		questionLabel.attributedText = questions[questionIndex].text.makeAttributed(font: font)
		
		let question = questions[questionIndex]
		
		switch question.type{
		case .single:
			answersStackView = UIStackView(arrangedSubviews: fillStackWithButtons())
			view.addSubview(answersStackView)
			answersStackView.setup()
			
		case .multiple:
			outerIndex = 0
			answersStackView = UIStackView(arrangedSubviews: fillStackWithLabels())
			view.addSubview(answersStackView)
			
			for subview in answersStackView.subviews {
				subview.widthAnchor.constraint(equalTo: answersStackView.widthAnchor, multiplier: 1).isActive = true
			}
			
			answerButton = makeButton(with: "Answer")
			answersStackView.addArrangedSubview(answerButton)
			answersStackView.setup()
			
		case .ranged:
			answersStackView = showRangedAnswerQuestion()
			view.addSubview(answersStackView)
			answersStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
			answerButton = makeButton(with: "Answer")
			answersStackView.addArrangedSubview(answerButton)
			answersStackView.setup()
		}
	}
	
	func makeButton(with title: String) -> UIButton {
		let button = UIButton()
		button.setup()
		button.setTitle(title, for: .normal)
		button.addTarget(self, action: #selector(questionAnswered(_:)), for: .touchUpInside)
		return button
	}
	
	func fillStackWithButtons() -> [UIButton] {
		return questions[questionIndex].answers.map { answer in
			let button = makeButton(with: answer.text)
			return button
		}
	}
	
	func fillStackWithLabels() -> [UIStackView] {
		return questions[questionIndex].answers.map { answer in
			let label = UILabel()
			let font = label.font.withSize(answersFontSize)
			label.attributedText = answer.text.makeAttributed(font: font)
			label.translatesAutoresizingMaskIntoConstraints = false
			label.heightAnchor.constraint(equalToConstant: 21).isActive = true
			let switcher = UISwitch()
			switcher.isOn = false
			let stackView = UIStackView(arrangedSubviews: [label, switcher])
			stackView.axis = .horizontal
			stackView.distribution = .fill
			return stackView
		}
	}
	
	func showRangedAnswerQuestion() -> UIStackView {
		let minLabel = UILabel()
		let font = minLabel.font.withSize(answersFontSize)
		minLabel.attributedText = questions[questionIndex].answers.first!.text.makeAttributed(font: font)
		let maxLabel = UILabel()
		maxLabel.attributedText = questions[questionIndex].answers.last!.text.makeAttributed(font: font)
		let stackView = UIStackView(arrangedSubviews: [minLabel, maxLabel])
		let slider = UISlider()
		slider.translatesAutoresizingMaskIntoConstraints = false
		slider.tintColor = .blue
		slider.minimumValue = 0; slider.maximumValue = 1
		slider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
		return UIStackView(arrangedSubviews: [stackView, slider])
	}
	
	func readAnswer(from button: UIButton) {
		for answer in questions[questionIndex].answers {
			if button.currentTitle == answer.text {
				answers.append(answer)
				print(answer.text)
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
				let slider = view as! UISlider
				let answerIndex = Int((Float(questions[questionIndex].answers.count - 1) * slider.value))
				answers.append(questions[questionIndex].answers[answerIndex])
				print(questions[questionIndex].answers[answerIndex].text)
				//case is UILabel:
			//	print("label")
			case is UIStackView:
				getAnswer(for: question, from: view as! UIStackView, outerIndex: &outerIndex)
				outerIndex += 1
			default:
				break
			}
		}
	}
	
	@objc func sliderChanged(_ sender: UISlider) {
		let roundedValue = round(sender.value / step) * step
		sender.setValue(roundedValue, animated: true)
	}
	
	@objc func questionAnswered(_ sender: UIButton) {
		
		defer {
			questionIndex += 1
		}
		
		let question = questions[questionIndex]
		switch question.type{
		case .single:
			readAnswer(from: sender)
		case .multiple:
			outerIndex = 0
			getAnswer(for: question, from: answersStackView, outerIndex: &outerIndex)
		case .ranged:
			outerIndex = 0
			getAnswer(for: question, from: answersStackView, outerIndex: &outerIndex)
		}
	}
}

extension UIStackView {
	
	func setup() {
		self.translatesAutoresizingMaskIntoConstraints = false
		self.axis = .vertical
		self.spacing = 20
		self.distribution = .fill
		guard let view = superview else { return }
		self.centered()
		self.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
	}
}

extension UIButton {
	func setup() {
		self.translatesAutoresizingMaskIntoConstraints = false
		self.setTitleColor(.white, for: .normal)
		self.backgroundColor = .blue
		self.layer.cornerRadius = 7
		self.layer.masksToBounds = true
		self.heightAnchor.constraint(equalToConstant: 30).isActive = true
	}
}
