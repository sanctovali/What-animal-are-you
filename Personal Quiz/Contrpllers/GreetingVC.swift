//
//  GreetingVC.swift
//  Personal Quiz
//
//  Created by Valentin Kiselev on 09/12/2018.
//  Copyright © 2018 Valentin Kiselev. All rights reserved.
//

import UIKit

class GreetingVC: UIViewController {
	
	var greetengLabel: UILabel!
	var leftTopCornerLabel: UILabel!
	var leftBottomCornerLabel: UILabel!
	var rightTopCornerLabel: UILabel!
	var rightBottomCornerLabel: UILabel!
	var startButton: UIButton!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		setupUI()
	}
	
	func getAttibutedText(_ text: String, font : UIFont) -> NSMutableAttributedString {
		return NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font : font])
	}
	
	func setupUI() {
		
		let indent: CGFloat = 20
		var font = UIFont(name: "Chalkduster", size: 25)!
		
		greetengLabel = UILabel()
		greetengLabel.attributedText = "What animal are you?".makeAttributed(font: font)
		view.addSubview(greetengLabel)
		greetengLabel.translatesAutoresizingMaskIntoConstraints = false
		greetengLabel.centered()
		
		leftTopCornerLabel = UILabel()
		font  = leftTopCornerLabel.font.withSize(40)
		leftTopCornerLabel.attributedText = "🐶".makeAttributed(font: font)
		view.addSubview(leftTopCornerLabel)
		leftTopCornerLabel.translatesAutoresizingMaskIntoConstraints = false
		leftTopCornerLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: indent).isActive = true
		leftTopCornerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: indent).isActive = true
		
		leftBottomCornerLabel = UILabel()
		leftBottomCornerLabel.attributedText = "🐱".makeAttributed(font: font)
		view.addSubview(leftBottomCornerLabel)
		leftBottomCornerLabel.translatesAutoresizingMaskIntoConstraints = false
		leftBottomCornerLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: indent).isActive = true
		leftBottomCornerLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -indent).isActive = true
		
		rightTopCornerLabel = UILabel()
		rightTopCornerLabel.attributedText = "🐢".makeAttributed(font: font)
		view.addSubview(rightTopCornerLabel)
		rightTopCornerLabel.translatesAutoresizingMaskIntoConstraints = false
		rightTopCornerLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -indent).isActive = true
		rightTopCornerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: indent).isActive = true
		
		rightBottomCornerLabel = UILabel()
		rightBottomCornerLabel.attributedText = "🐰".makeAttributed(font: font)
		view.addSubview(rightBottomCornerLabel)
		rightBottomCornerLabel.translatesAutoresizingMaskIntoConstraints = false
		rightBottomCornerLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -indent).isActive = true
		rightBottomCornerLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -indent).isActive = true
		
		startButton = UIButton()
		startButton.setup()
		view.addSubview(startButton)
		startButton.centered(0, 40)
		startButton.setTitle("lets find it out!", for: [])
		startButton.addTarget(self, action: #selector(startButtonPressed(_:)), for: .touchUpInside)
	}
	
	@objc func startButtonPressed(_ sender: UIButton) {
		let questionVC = QuestionsVC()
		let navigationController = UINavigationController(rootViewController: questionVC)
		present(navigationController, animated: true, completion: nil)
		
	}
}

extension String {
	func makeAttributed(font : UIFont) -> NSMutableAttributedString {
		return NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font : font])
	}
}

extension UIView {
	func centered(_ indentX: CGFloat = 0, _ indentY: CGFloat = 0) {
		guard let view = superview else { return }
		self.centerXAnchor.constraint(equalTo: view.centerXAnchor,  constant: indentX).isActive = true
		self.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: indentY).isActive = true
	}
}
