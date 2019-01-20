//
//  Question.swift
//  Personal Quiz
//
//  Created by Valentin Kiselev on 08/12/2018.
//  Copyright © 2018 Valentin Kiselev. All rights reserved.
//


struct Question {
	var text: String
	var type: ResponseType
	var answers: [WhatAnimalYouAreAnswer]
}

enum ResponseType {
	case single, multiple, ranged
}

struct WhatAnimalYouAreAnswer {
	var text: String
	var type: AnimalType
}

enum AnimalType: Character {
	
	case dog = "🐶", cat = "🐱", rabbit = "🐰", turtle = "🐢"
	
	var definition: String {
		switch self {
		case .dog:
			return "You are the life of the party. You are always surrounded by your friends"
		case .cat:
			return "You are mostly on your own. You like freedom and independence"
		case .rabbit:
			return "You like everything soft. You are healthy and full of energy"
		case .turtle:
			return "Slow and steady wins the race. You are with an old head on your shoulders"
		}
	}
}

