//
//  Persister.swift
//  AccentTrainer
//
//  Created by Bhavesh Agrawal on 09/06/2019.
//  Copyright © 2019 Dexter. All rights reserved.
//

import Foundation

class Persister {
	
	static func saveQuizOptions(options: QuizChoice) {
		let keyName = "\(options.getQuizType())_recent"
        let userDefaults = UserDefaults.standard
		let quizOptions = [
			options.getQuizType(),
			options.getQuizLength(),
			options.getQuizAccent(),
			options.getQuizSpeaker()
		]
		userDefaults.setValue(quizOptions, forKey: keyName)
		userDefaults.synchronize()
	}
	
	static func lastQuizSelection(quizType: String) -> QuizChoice {
		let keyName = "\(quizType)_recent"
        let userDefaults = UserDefaults.standard
		
		let previousOptions = QuizChoice()
		
        if (userDefaults.object(forKey: keyName) != nil) {
            var quizOptions = userDefaults.object(forKey: keyName) as! [String]
            previousOptions.setType(type: quizOptions[0])
            previousOptions.setLength(length: quizOptions[1])
            previousOptions.setAccent(accent: quizOptions[2])
            previousOptions.setSpeaker(name: quizOptions[3])
		} else {
            previousOptions.setType(type: quizType)
            previousOptions.setAccent(accent: "London")
            previousOptions.setLength(length: "Short (15)")
            previousOptions.setSpeaker(name: "Anna")
			if quizType == "practice" {
                previousOptions.setType(type: quizType)
			} else {
                previousOptions.setType(type: "timetrial")
			}
		}
		return previousOptions
	}
}
