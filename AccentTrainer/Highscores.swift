//
//  HighscoresModel.swift
//  AccentTrainer
//
//  Created by Bhavesh Agrawal on 09/06/2019.
//  Copyright © 2019 Dexter. All rights reserved.
//

import Foundation

class Highscores {
	
	static func updateHighscores(quizType: String, name: String, score: Int) {
		let keyName = "\(quizType)_highscores"
        let userDefaults = UserDefaults.standard
		var previousHighscores: [[String: Int]]
		
        if (userDefaults.object(forKey: keyName) != nil) {
            previousHighscores = (userDefaults.object(forKey: keyName) as? [[String: Int]])!
			previousHighscores.append([name: score])
            previousHighscores = fixOrder(numberList: previousHighscores)
			while previousHighscores.count > 8 {
				previousHighscores.removeLast()
			}
			
		} else {
			previousHighscores = [[name: score]]
		}
		
		userDefaults.setValue(previousHighscores, forKey: keyName)
		userDefaults.synchronize()

	}
	
	static func returnAllHighScores(quizType: String) -> [[ String: Int]]{
		let keyName = "\(quizType)_highscores"
        let allHighscores = UserDefaults.standard.object(forKey: keyName) as? [[String: Int]] ?? nil
		
		if allHighscores == nil {
			let allHighscores = [[String: Int]]()
			return allHighscores
		}
		
		return allHighscores!
	}
	
	//bubble sort for sorting array of dictionaries with each dict containing one key-value pair
	class func fixOrder(numberList: [[String: Int]]) -> [[String: Int]] {
		//check for trivial case
		guard numberList.count > 1 else {
			return numberList
		}
		
		//make the array mutable
		var numberList = numberList
		for primaryIndex in 0..<numberList.count {
			let passes = (numberList.count - 1) - primaryIndex
			for secondaryIndex in 0..<passes {
				let testKey = (numberList[secondaryIndex]).filter { $0.0 != "" }[0]
				let comparisonKey = (numberList[secondaryIndex + 1]).filter { $0.0 != "" }[0]
				if((numberList[secondaryIndex][testKey.0])! < (numberList[secondaryIndex + 1][comparisonKey.0])!){
                    numberList.swapAt(secondaryIndex, secondaryIndex + 1)
				}
			}
		}
		return numberList
	}
}
