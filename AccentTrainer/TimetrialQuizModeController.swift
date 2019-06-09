//
//  TimetrialQuizModeController.swift
//  AccentTrainer
//
//  Created by Bhavesh Agrawal on 09/06/2019.
//  Copyright © 2019 Dexter. All rights reserved.
//

import UIKit
import AVFoundation

class TimetrialQuizModeController: QuestionViewController {
	
	var answerSelected = false
	var answerStartTime: NSDate? = nil
    var selectionTimer: Timer? = Timer()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		audioPlayer = AVAudioPlayer()
		questionGenerator = QuestionGenerator(completQuizChoice: questionChoice!)
		quizLength = questionChoice!.getQuizLengthInt()
		testModeColor = appColors["timetrial"]!
        quitQuizButton.setTitleColor(testModeColor, for: .normal)
        restartQuizButton.setTitleColor(testModeColor, for: .normal)
		
		setUpReplayButton()
		setupTimer()
		
		generateQuestion()
		
		//Create the background label for the question number area
		let gutterWidth = viewWidth / 16;
		let buttonHeight = (((viewHeight) * 0.75) - (4 * gutterWidth)) / 3
		let quizTotalLabelBackground = UIView(frame: CGRect(
			x: Int(gutterWidth),
			y: Int((gutterWidth + buttonHeight) * 2 + (viewHeight * 0.45)),
			width: Int(viewWidth - 2 * gutterWidth),
			height: Int(viewHeight * 0.2)
			))
		quizTotalLabelBackground.layer.cornerRadius = 10
		quizTotalLabelBackground.backgroundColor = testModeColor
		self.view.addSubview(quizTotalLabelBackground)
    }
	
	@IBAction func restartQuiz(sender: AnyObject) {
        let restartPrompt = UIAlertController(title: "Are you sure you want to restart?", message: "", preferredStyle: .alert)
        restartPrompt.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        restartPrompt.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
			self.stopCount = 1
			self.audioPlayer!.stop()
			self.selectionTimer!.invalidate()
			self.selectionTimer = nil
            if let resultController = self.storyboard!.instantiateViewController(withIdentifier: "TimetrialQuizModeController") as? TimetrialQuizModeController {
				resultController.questionChoice = self.questionChoice
                self.present(resultController, animated: true, completion: nil)
			}
		}))
        present(restartPrompt, animated: true, completion: nil)
	}
	
	@IBAction func quitPressed(sender: UIButton) {
        let quitPrompt = UIAlertController(title: "Are you sure you want to quit?", message: "", preferredStyle: .alert)
        quitPrompt.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        quitPrompt.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
			self.stopCount = 1
			self.audioPlayer!.stop()
			self.selectionTimer!.invalidate()
			self.selectionTimer = nil
            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
		}))
        present(quitPrompt, animated: true, completion: nil)
	}
	
	override func setUpReplayButton(){
		let image = UIImage(named: "speaker")
		
		replayButton.frame = CGRect(
			x: self.view.frame.width * 0.2,
			y: self.view.frame.height * 0.18,
			width: self.view.frame.width * 0.6,
			height: CGFloat(viewWidth * 0.4)
		)
		
        replayButton.setImage(image, for: .normal)
        replayButton.titleLabel?.isHidden = true
        replayButton.imageView?.contentMode = .scaleAspectFit
        replayButton.addTarget(self, action: #selector(QuestionViewController.replaySound(sender:)), for: .touchUpInside)
		self.view.addSubview(replayButton)
	}
	
	func generateQuestion(){
		
        removeViews(tag: 1)
        removeViews(tag: 2)
        repeat{
            questionGenerator?.generateQuestion() //makes sure audio file exists
			
			//NSDataAsset(name: (questionGenerator?.getQuestionFileName())!) == nil //for ios 9 onwards
        } while(fileExists(fileName: (questionGenerator?.getQuestionFileName())!) == false )
		
        let fileName = questionGenerator?.getQuestionFileName()
        playSound(fileName: fileName!)
		
        delay(time: 1.0){
			//display the buttons after the audio has been played
            self.displayButtons(buttonLabelSet: self.questionGenerator!.getQuestionSet(), nextFunction: #selector(TimetrialQuizModeController.questionButtonPressed(sender:)))
            self.answerSelected = false
            self.generateTimer()
        }
	}
	
	//display background timer bar
	func setupTimer(){
		
		let timerBackground = UIView(frame: CGRect(
			x: viewWidth * 0.07,
			y: viewHeight * 0.11,
			width: viewWidth * 0.86,
			height: 10
			))
		timerBackground.layer.cornerRadius = timerBackground.frame.height / 2
		timerBackground.backgroundColor = appColors["timetrialLight"]
		timerBackground.tag = 5
		self.view.addSubview(timerBackground)
	}
	
	//display foreground (decreasing) timer bar
	func generateTimer(){
		
		answerStartTime = NSDate()
		
		let timerSeeker = UIView(frame: CGRect(
			x: viewWidth * 0.07,
			y: viewHeight * 0.11,
			width: viewWidth * 0.86,
			height: 10
			))
		timerSeeker.layer.cornerRadius = 5
		timerSeeker.backgroundColor = testModeColor
		timerSeeker.tag = 3
		
		self.view.addSubview(timerSeeker)
		
        UIView.animate(
            withDuration: 5,
			animations: { () -> Void in
				timerSeeker.frame = CGRect(
					x: self.viewWidth * 0.07,
					y: self.viewHeight * 0.11,
					width: 10,
					height: 10
				)
			})
		
        delay(time: 4){
            UIView.animate(
                withDuration: 0.5,
				animations: { () -> Void in
					timerSeeker.alpha = 0
			})
		}
		
        selectionTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(TimetrialQuizModeController.noOptionSelected), userInfo: nil, repeats: false)
	}
	
    @objc func noOptionSelected(){
		if self.answerSelected == false {
            self.questionButtonPressed(sender: nil)
		}
	}
	
    @objc func questionButtonPressed(sender: CustomButton?){
		
		//disable all buttons
		changeButtonStates()
		
		answerSelected = true
        removeViews(tag: 3)
		
		if sender != nil {
			
            sender!.setTitleColor(appColors["white"], for: .normal)
			
			if sender!.currentTitle! == questionGenerator?.getAnswer(){
				
                playSound(fileName: "feedback-correct")
				sender!.backgroundColor = appColors["correctGreen"]
				
				userScore += Int(10 * scoreTimeFactor())
				
			} else {
				
                self.playSound(fileName: "feedback-wrong")
				sender!.backgroundColor = appColors["incorrectRed"]
                
				// increase the probability of incorrectly selected vowel sound
                questionGenerator?.changeVowelProbability(rhymeIndex: (questionGenerator?.rhymeSetIndex!)!, value: 1.2)
			}
		} else {
            playSound(fileName: "feedback-wrong")
            delay(time: 0.3){
				for view in self.view.subviews{
					if let correctOption = view as? CustomButton {
						if correctOption.currentTitle! == self.questionGenerator?.getAnswer(){
                            correctOption.setTitleColor(self.appColors["white"], for: .normal)
							correctOption.backgroundColor = self.appColors["correctGreen"]
						}
					}
				}
			}
		}
		
        delay(time: 1.5) {
			
			if(self.stopCount != 1){
				
				//Stop NSTimer to prevent spillover into next question
				self.selectionTimer!.invalidate()
				self.selectionTimer = nil
				
				if (self.questionNumber == self.quizLength){
					
					// When all questions have been answered
					self.audioPlayer!.stop()
                    if let resultController = self.storyboard!.instantiateViewController(withIdentifier: "ResultsViewController") as? ResultsViewController {
						resultController.result = self.userScore
						resultController.quizOptions = self.questionChoice!
						resultController.maxScore = self.quizLength * 10
                        self.present(resultController, animated: true, completion: nil)
					}
				} else {
					self.questionNumber += 1
					self.generateQuestion()
				}
			}
		}
	}
	
	func scoreTimeFactor() -> Float {
        let elapsedTime = NSDate().timeIntervalSince(answerStartTime! as Date)
		if elapsedTime < 1 {
			return 2.0
		} else if elapsedTime < 2 {
			return 1.6
		} else if elapsedTime < 3 {
			return 1.2
		} else {
			return 0.8
		}
	}
	
	//Complex function that creates several view items
	//The majority of the complexity is fine tuning values for differant screen sizes
	func displayButtons(buttonLabelSet: [String], nextFunction: Selector){
		
		var counter = 0
		
		//select (x, y, width, height) based on actual view dimensions
		let viewHeight = Float(self.view.frame.height);
		let viewWidth = Float(self.view.frame.width);
		let gutterWidth: Float = viewWidth / 16;
		let buttonWidth: Float = (viewWidth - (3 * gutterWidth))/2
		
		//get 75% of height, remove gutter space and divide remaining area by 3
		let buttonHeight = (((viewHeight) * 0.75) - (4 * gutterWidth)) / 3
		
		for label in buttonLabelSet {
			
			let customButton = CustomButton(
				frame: CGRect(
					x: Int(gutterWidth + (gutterWidth + buttonWidth) * Float(counter % 2)),
					y: Int((gutterWidth + buttonHeight) * Float( counter / 2) + (viewHeight * 0.46)),
					width: Int(buttonWidth),
					height: Int(buttonHeight))
			)
            customButton.setTitleColor(appColors["darkGrey"], for: .normal)
            customButton.setTitle(label, for: .normal)
            customButton.titleLabel?.font = UIFont.mainFontOfSize(fontSize: viewHeight > 700 ? 30 : 24)
            customButton.addTarget(self, action: nextFunction, for: .touchUpInside)
			customButton.backgroundColor = appColors["lightGrey"]
            fadeCentreInToSubview(target: customButton, delay: 0.25, completionAction: nil)
			customButton.tag = 1
			counter = counter + 1
		}
		
        removeViews(tag: 6)
		let quizTotalLabel = UILabel(frame: CGRect(
			x: Int(gutterWidth),
			y: Int(viewHeight - viewHeight * 0.075),
			width: Int(viewWidth - 2 * gutterWidth),
			height: Int(viewHeight * 0.075)
			))
		quizTotalLabel.textColor = appColors["white"]
		quizTotalLabel.text = "\(questionNumber) of \(quizLength)"
        quizTotalLabel.font = UIFont.mainFontOfSize(fontSize: viewHeight > 700 ? 26 : 20)
        quizTotalLabel.textAlignment = .center
		
		quizTotalLabel.tag = 6
		self.view.addSubview(quizTotalLabel)
		
	}


}
