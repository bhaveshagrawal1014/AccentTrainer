//
//  QuestionViewController.swift
//  AccentTrainer
//
//  Created by Bhavesh Agrawal on 09/06/2019.
//  Copyright © 2019 Dexter. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class QuestionViewController: CustomViewController {
	
	//TODO: Change feedback audio files
    
    var questionChoice: QuizChoice?
    var audioPlayer: AVAudioPlayer?
    var questionGenerator: QuestionGenerator?
	var replayButton = UIButton()
	var questionNumber = 1
    var testModeColor = UIColor.clear
	var quizLength = 0
    var counter = 0
    var stopCount = 0
    var userScore = 0
	@IBOutlet weak var quitQuizButton: UIButton!
	@IBOutlet weak var restartQuizButton: UIButton!
	
	
    override func viewDidLoad(){
        super.viewDidLoad()
		if viewHeight > 700 {
            quitQuizButton.titleLabel?.font = UIFont.mainFontOfSize(fontSize: 24)
			quitQuizButton.frame = CGRect(
				x: quitQuizButton.frame.origin.x,
				y: quitQuizButton.frame.origin.y,
				width: quitQuizButton.frame.width + 50,
				height: quitQuizButton.frame.height
			)
            restartQuizButton.titleLabel?.font = UIFont.mainFontOfSize(fontSize: 24)
			restartQuizButton.frame = CGRect(
				x: restartQuizButton.frame.origin.x - 50,
				y: restartQuizButton.frame.origin.y,
				width: restartQuizButton.frame.width + 50,
				height: restartQuizButton.frame.height
			)
		}
    }
	
	func setUpReplayButton(){
		let image = UIImage(named: "speaker")
		
		replayButton.frame = CGRect(
			x: self.view.frame.width * 0.2,
			y: self.view.frame.height * 0.16,
			width: self.view.frame.width * 0.6,
			height: CGFloat(viewWidth * 0.4)
		)
		
        replayButton.setImage(image, for: .normal)
        replayButton.titleLabel?.isHidden = true
        replayButton.imageView?.contentMode = .scaleAspectFit
        replayButton.addTarget(self, action: #selector(QuestionViewController.replaySound(sender:)), for: .touchUpInside)
		self.view.addSubview(replayButton)
	}
	
    @objc func replaySound(sender: CustomButton){
        playSound(fileName: (questionGenerator?.getQuestionFileName())!)
	}
	
    func playSound(fileName:String){
        
        let url = URL.init(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: "mp3")!)
        
        audioPlayer = try! AVAudioPlayer(contentsOf: url)
        audioPlayer?.volume = 1.0;
        audioPlayer!.play()
    }
	
	//disable all buttons
	func changeButtonStates(){
		var viewsToChangeState = [CustomButton]()
		self.view.subviews.forEach({ if $0.tag == 1 { viewsToChangeState.append(($0 as? CustomButton)!)}})
		for button in viewsToChangeState {
            if button.isEnabled {
                button.isEnabled = false
			}
		}
	}
    
    func fileExists(fileName: String)-> Bool{
		
        let path = Bundle.main.path(forResource: fileName, ofType: "mp3")
        if path != nil{
            return true
        }
        return false
    }
	
	//return a highlighted button back to greys
    func returnToDefaultState(button: CustomButton){
        button.backgroundColor = appColors["lightGrey"]
        button.setTitleColor(appColors["darkGrey"], for: .normal)
    }
    
    func feedbackForWrong(wrongButton: CustomButton, correctButton: CustomButton, wrongFile: String, correctFile: String){
        if stopCount != 1 {
            wrongButton.setTitleColor(self.appColors["white"], for: .normal)
			wrongButton.backgroundColor = appColors["incorrectRed"]
            playSound(fileName: wrongFile)
            delay(time: 1.2){
                self.returnToDefaultState(button: wrongButton)
				
				if(self.stopCount != 1){
                    correctButton.setTitleColor(self.appColors["white"], for: .normal)
					correctButton.backgroundColor = self.appColors["correctGreen"]
                    self.playSound(fileName: correctFile)
                    self.delay(time: 1){
                        self.returnToDefaultState(button: correctButton)
					}
				}
			}
		}
	}
	
	@IBAction func unwindToMVC(segue: UIStoryboardSegue){}
}
