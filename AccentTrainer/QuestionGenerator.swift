//
//  QuestionGenerator.swift
//  AccentTrainer
//
//  Created by Bhavesh Agrawal on 09/06/2019.
//  Copyright © 2019 Dexter. All rights reserved.
//

import Foundation


class QuestionGenerator {
	
    let quizChoice: QuizChoice?
    let qs = QuestionSet()
    var askedQuestions = [(Int,Int,String)]() // (rhyme index, question set index,answer)
    var answer: String?
    var questionSetIndex: Int? //which set ie. back, bark set = 0
    var answerIndex: Int? // index of answer ie. beck = 2
    var rhymeSetIndex: Int?
    
    var rhymeProb: [Double] = [1,1,1,1]
    
    
    init(completQuizChoice: QuizChoice){
        self.quizChoice = completQuizChoice
    }
    
    func checkAnswered(index: Int) -> Bool{
        for (rhymeNum,askedIndex,askedAnswer) in askedQuestions {
            if index == askedIndex &&  rhymeNum == rhymeSetIndex && askedAnswer == answer{
                return true
            }
        }
        return false
    }
	
    func generateQuestion(){
        
        repeat{
            rhymeSetIndex = randomNumber(probabilities: rhymeProb)
            questionSetIndex = Int(arc4random_uniform(UInt32(qs.getRhymeLength(rhymeSet: rhymeSetIndex!))))} //repeat until unasked question set is found
            while(checkAnswered(index: questionSetIndex!))
        answerIndex = Int(arc4random_uniform(UInt32(qs.getQuestionSet(index: questionSetIndex!,rhymeSet: rhymeSetIndex!).count)))
        answer = qs.getAnswer(setIndex: questionSetIndex!, answerIndex: answerIndex!, rhymeSet: rhymeSetIndex!)
        askedQuestions.append((rhymeSetIndex!,questionSetIndex!,answer!))
        
    }
	
	// returns the name of the file in the format: accent_speakerName_answer
    func getQuestionFileName() -> String{
        let accent = quizChoice!.getQuizAccent()
        let speakerName = quizChoice!.getQuizSpeaker()
        return "\(accent)_\(speakerName)_\(answer!)"
    }
    
    func getQuestionSet() -> [String] {
        return qs.getQuestionSet(index: questionSetIndex!,rhymeSet: rhymeSetIndex!)
    }
    
    func getAnswer() -> String {
        return answer!
    }
	
	//generate index with a given distribution: http://stackoverflow.com/questions/30309556/generate-random-numbers-with-a-given-distribution
    func randomNumber(probabilities: [Double]) -> Int {
        
        let sum = probabilities.reduce(0, +)
        let rand = sum * Double(arc4random_uniform(UInt32.max)) / Double(UInt32.max)
        var accum = 0.0
        for (i, p) in probabilities.enumerated() {
            accum += p
            if rand < accum {
                return i
            }
        }
        return (probabilities.count - 1)
    }
    
    func changeVowelProbability(rhymeIndex: Int, value: Double){
        rhymeProb[rhymeIndex] = (rhymeProb[rhymeIndex]*value)
    }
    
}
