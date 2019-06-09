//
//  ViewController.swift
//  AccentTrainer
//
//  Created by Bhavesh Agrawal on 09/06/2019.
//  Copyright © 2019 Dexter. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
	
	
	@IBOutlet weak var mainLogo: UIImageView!
	@IBOutlet weak var practiceButton: CustomButton!
	@IBOutlet weak var timetrialButton: CustomButton!
	@IBOutlet weak var highscoresButton: CustomButton!
	@IBOutlet weak var aboutButton: UIButton!	
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
		
		// Adapt for iPhone 4s
		
		if self.view.frame.height > 700 {
			
			mainLogo.frame = CGRect(
				x: self.view.frame.width * 0.1,
				y: self.view.frame.height * 0.05,
				width: self.view.frame.width * 0.7,
				height: self.view.frame.height * 0.4
			)
			
			mainLogo.autoresizesSubviews = false
			
            aboutButton.titleLabel?.font = UIFont.mainFontOfSize(fontSize: 20)
			aboutButton.frame = CGRect(
				x: aboutButton.frame.origin.x,
				y: aboutButton.frame.origin.y - 15,
				width: aboutButton.frame.width,
				height: aboutButton.frame.height
			)
			
			var counter: CGFloat = 0
			
			for button in [practiceButton, timetrialButton, highscoresButton]{
                button!.titleLabel?.font = UIFont.mainFontOfSize(fontSize: 28)
				button!.frame = CGRect(
					x: self.view.frame.width * 0.1,
					y: self.view.frame.height * 0.5 + (counter * (self.view.frame.height * 0.12 + 10)),
					width: self.view.frame.width * 0.8,
					height: self.view.frame.height * 0.12
				)
				counter = counter + 1
			}
		} else if self.view.frame.height < 568 {
		
			mainLogo.frame = CGRect(
				x: self.view.frame.width * 0.1,
				y: self.view.frame.height * 0.05,
				width: self.view.frame.width * 0.8,
				height: self.view.frame.height * 0.4
			)
			
			var counter: CGFloat = 0
			
			for button in [practiceButton, timetrialButton, highscoresButton]{
				button!.frame = CGRect(
					x: self.view.frame.width * 0.1,
					y: self.view.frame.height * 0.5 + (counter * (self.view.frame.height * 0.12 + 10)),
					width: self.view.frame.width * 0.8,
					height: self.view.frame.height * 0.12
					)
				counter = counter + 1
			}
			
		} else if self.view.frame.height > 568 {
			
			// Adapt for iPhone 6 and larger
			mainLogo.frame = CGRect(
				x: self.view.frame.width * 0.1,
				y: self.view.frame.height * 0.08,
				width: self.view.frame.width * 0.8,
				height: self.view.frame.height * 0.4
			)
			
            aboutButton.titleLabel?.font = UIFont.mainFontOfSize(fontSize: 18)
			aboutButton.frame = CGRect(
				x: aboutButton.frame.origin.x,
				y: aboutButton.frame.origin.y - 10,
				width: aboutButton.frame.width,
				height: aboutButton.frame.height
			)
			
			var counter: CGFloat = 0
			let extraHeight: CGFloat = 10
			
			for button in [practiceButton, timetrialButton, highscoresButton]{
                button!.frame = CGRect(
					x: button!.frame.origin.x,
					y: button!.frame.origin.y + 50 + (counter * extraHeight),
					width: button!.frame.width,
					height: button!.frame.height + extraHeight
				)
                button!.titleLabel!.font = UIFont.mainFontOfSize(fontSize: 30)
				counter = counter + 1
			}
		}

    }
	
	@IBAction func goToPractice(sender: CustomButton) {
        if let resultController = storyboard!.instantiateViewController(withIdentifier: "QuizOptionsController") as? QuizOptionsController {
            resultController.quizOptions.setType(type: "practice")
            present(resultController, animated: true, completion: nil)
		}
	}
	
	@IBAction func goToTimetrial(sender: AnyObject) {
        if let resultController = storyboard!.instantiateViewController(withIdentifier: "QuizOptionsController") as? QuizOptionsController {
            resultController.quizOptions.setType(type: "timetrial")
            present(resultController, animated: true, completion: nil)
		}
	}
	
	//allows moving back to MainVC
	@IBAction func unwindToMVC(segue: UIStoryboardSegue){}
	
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

