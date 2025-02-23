//
//  ResultsViewController.swift
//  AccentTrainer
//
//  Created by Bhavesh Agrawal on 09/06/2019.
//  Copyright © 2019 Dexter. All rights reserved.
//

import UIKit

class ResultsViewController: CustomViewController {
	
	var result: Int = 0
	var trophyImage = UIImage()
	var trophyImageView = UIImageView()
	var quizOptions = QuizChoice()
	var maxScore = 150
	
	//to make button-label-text the correct color
	@IBOutlet weak var homeButton: CustomButton!
	
	@IBAction func replayButton(sender: AnyObject) {
		if quizOptions.getQuizType() == "practice" {
            if let resultController = self.storyboard!.instantiateViewController(withIdentifier: "PracticeQuizModeController") as? PracticeQuizModeController {
				resultController.questionChoice = quizOptions
                self.present(resultController, animated: true, completion: nil)
			}
		} else {
            if let resultController = self.storyboard!.instantiateViewController(withIdentifier: "TimetrialQuizModeController") as? TimetrialQuizModeController {
				resultController.questionChoice = quizOptions
                self.present(resultController, animated: true, completion: nil)
			}
		}
	}
	
	@IBAction func goHome(sender: AnyObject) {
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		setupInitialView()
		
        delay(time: 3){
			
            let getHighscoreName = UIAlertController(title: "Congratulations, you've made it into the highscores!", message: "Enter your name", preferredStyle: .alert)
            getHighscoreName.addTextField(configurationHandler: nil)
			getHighscoreName.textFields![0].placeholder = "Your name"
            getHighscoreName.addAction(UIAlertAction(title: "Add", style: .default, handler: { (UIAlertAction) in
				var highscoreName = getHighscoreName.textFields![0].text!
				if highscoreName == "" {
					highscoreName = "Anonymous"
				}
				
                Highscores.updateHighscores(quizType: self.quizOptions.getQuizType(), name: highscoreName, score: self.result)
				
				self.setupHighscoresView()
				
			}))
			
            self.present(getHighscoreName, animated: true, completion: nil)
		}
    }
	
	//shows single score on screen with trophy
	func setupInitialView(){
		
		if quizOptions.getQuizType() == "practice" {
			self.view.backgroundColor = appColors["practice"]
            homeButton.setTitleColor(appColors["practice"], for: .normal)
		} else {
			self.view.backgroundColor = appColors["timetrial"]
            homeButton.setTitleColor(appColors["timetrial"], for: .normal)
		}
		
		trophyImage = UIImage(named: "bronze_trophy")!
		
		let correctRate = Float(result / maxScore)
		
		if  correctRate > 0.85 {
			trophyImage = UIImage(named: "gold_trophy")!
		} else if correctRate > 60 {
			trophyImage = UIImage(named: "silver_trophy")!
		}
				
		print("result: \(result), maxScore \(maxScore)")
		print("\(correctRate)")
		
		trophyImageView = UIImageView(image: trophyImage)
		trophyImageView.frame = CGRect.init(
            x: (CGFloat(viewWidth) - trophyImage.size.width) / 2,
            y: self.view.frame.height - (self.view.frame.height * 0.4),
            width: trophyImage.size.width,
            height: trophyImage.size.height
		)
        fadeUpInToSubview(target: trophyImageView, delay: 0.25, completionAction: nil)
		
		let scoresLabel = UILabel(frame: CGRect(
			x: self.view.frame.width * 0.1,
			y: self.view.frame.height * 0.38,
			width: self.view.frame.width * 0.8,
			height: self.view.frame.height * 0.2
		))
		
		scoresLabel.text = "\(result)"
        scoresLabel.textAlignment = .center
		scoresLabel.textColor = appColors["white"]
        scoresLabel.font = UIFont.mainFontOfSize(fontSize: CGFloat(viewWidth / 4.5))
		scoresLabel.tag = 1
        fadeUpInToSubview(target: scoresLabel, delay: 0.25, completionAction: nil)
		
		let scoresInfoLabel = UILabel(frame: CGRect(
			x: self.view.frame.width * 0.1,
			y: self.view.frame.height * 0.2,
			width: self.view.frame.width * 0.8,
			height: self.view.frame.height * 0.15
			))
		
		scoresInfoLabel.text = "Short Quiz \nRandom Accent"
		scoresInfoLabel.numberOfLines = 2
        scoresInfoLabel.textAlignment = .center
		scoresInfoLabel.textColor = appColors["white"]
        scoresInfoLabel.font = UIFont.mainFontOfSize(fontSize: CGFloat(viewWidth / 10))
		scoresInfoLabel.tag = 1
        fadeUpInToSubview(target: scoresInfoLabel, delay: 0.25, completionAction: nil)
		
	}
	
	//shows leaderboard for quiz type
	func setupHighscoresView() -> Void {
        removeViews(tag: 1)
		
		let trophyReductionFactor: CGFloat = 0.6
        let allHighscores = Highscores.returnAllHighScores(quizType: quizOptions.getQuizType())
		print(allHighscores.count)
		
        UIView.animate(
            withDuration: 0.25,
			animations: {
				self.trophyImageView.frame = CGRect.init(
                    x: (CGFloat(self.viewWidth) - (self.trophyImage.size.width * trophyReductionFactor)) / 2,
                    y: self.view.frame.height - (self.view.frame.height * 0.2),
                    width: self.trophyImage.size.width * trophyReductionFactor,
                    height: self.trophyImage.size.height * trophyReductionFactor
				)
			},
			completion: nil
		)
		
		let highscoresLabel = UILabel(frame: CGRect(
			x: self.view.frame.width * 0.1,
			y: self.view.frame.height * 0.175,
			width: self.view.frame.width * 0.75,
			height: self.view.frame.height * 0.15
			))
		
		highscoresLabel.text = "Highscores"
        highscoresLabel.textAlignment = .center
		highscoresLabel.textColor = appColors["white"]
        highscoresLabel.font = UIFont.mainFontOfSize(fontSize: CGFloat(viewWidth / 10))
        fadeUpInToSubview(target: highscoresLabel, delay: 0.25, completionAction: nil)
		
		var counter = 0
		
        removeViews(tag: 6)
		for person in allHighscores {
			for (name, score) in person {
				let label = UILabel(frame: CGRect(
					x: 40,
					y: Int(viewHeight * 0.325) + (counter * 30),
					width: Int(viewWidth * 0.5),
					height: 22
					))
				label.text = "\(name)"
                label.font = UIFont.mainFontOfSize(fontSize: CGFloat(viewWidth / 16))
                label.textColor = UIColor.white
				label.tag = 1
                fadeUpInToSubview(target: label, delay: 0.25 + (0.05 * Double(counter)), completionAction: nil)
								
				let number = UILabel(frame: CGRect(
					x: Int(viewWidth - 40 - (viewWidth * 0.2)),
					y: Int(viewHeight * 0.325) + (counter * 30),
					width: Int(viewWidth * 0.2),
					height: 22
					))
				number.text = "\(score)"
                number.font = UIFont.mainFontOfSize(fontSize: CGFloat(viewWidth / 16))
                number.textColor = UIColor.white
                number.textAlignment = .right
				number.tag = 6
                fadeUpInToSubview(target: number, delay: 0.25 + (0.05 * Double(counter)), completionAction: nil)
				counter += 1
			}
		}
		
	}
	
	@IBAction func unwindToMVC(segue: UIStoryboardSegue){}

}
