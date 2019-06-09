//
//  QuizOptionsController.swift
//  AccentTrainer
//
//  Created by Bhavesh Agrawal on 09/06/2019.
//  Copyright © 2019 Dexter. All rights reserved.
//

import Foundation
import UIKit


class QuizOptionsController: CustomViewController{
    
    let quizOptions = QuizChoice()
    let lengthOptions = ["Short (15)","Medium (25)","Long (40)"]
    let accentOptions = ["London","US","Manchester","NewZealand","Australia","Glasgow"]
    let speakerOptions = [
        "London" : ["Anna","Chloe","John","Matthew"],
        "US" : ["Katie","Vinny","Sharon","Clare"],
        "Manchester":["Alex","Olivia","Sam"],
        "NewZealand": ["Richard","Ruby","Jack"],
        "Australia": ["Shane","Marlee"],
        "Glasgow":["Steward","Laura","Robert","Anna"]
    ]
	
    var testModeColor = UIColor.clear
	
	@IBOutlet weak var testModeTitle: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		//depending on quiztype default color is set
		if quizOptions.getQuizType() == "practice" {
			testModeColor = appColors["practice"]!
		} else {
			testModeColor = appColors["timetrial"]!
			testModeTitle.text = "Time Trial"
		}
		self.view.backgroundColor = testModeColor
		getLengthOptions()
    }
	
    func getLengthOptions(){
        displayLabel(title: "Choose quiz length", textColor: testModeColor)
        displaySingleColumnButtons(buttonLabelSet: lengthOptions, textColor: testModeColor, nextFunction: #selector(QuizOptionsController.getAccentOptions(sender:)))
    }
	
    @objc func getAccentOptions(sender: CustomButton){
        self.quizOptions.setLength(length: sender.currentTitle!)
        removeViews(tag: 1)
        delay(time: 0.25){
            self.displayLabel(title: "Choose an accent", textColor: self.testModeColor)
            self.displayTwoColumnButtons(buttonLabelSet: self.accentOptions, textColor: self.testModeColor, nextFunction:#selector(QuizOptionsController.getSpeakerOptions(sender:)))
		}
    }
    
    @objc func getSpeakerOptions(sender: CustomButton){
        self.quizOptions.setAccent(accent: sender.currentTitle!)
        removeViews(tag: 1)
        delay(time: 0.25){
            self.displayLabel(title: "Choose a speaker", textColor: self.testModeColor)
            self.displayTwoColumnButtons(buttonLabelSet: self.speakerOptions[self.quizOptions.getQuizAccent()]!, textColor: self.testModeColor, nextFunction: #selector(QuizOptionsController.moveToQuestionView(sender:)))
		}
    }
    
    @objc func moveToQuestionView(sender:CustomButton){
        quizOptions.setSpeaker(name: sender.currentTitle!)
		
		if quizOptions.getQuizType() == "practice" {
            if let resultController = storyboard!.instantiateViewController(withIdentifier: "PracticeQuizModeController") as? PracticeQuizModeController {
				resultController.questionChoice = self.quizOptions
                present(resultController, animated: true, completion: nil)
			}
		} else {
			if let resultController =
                storyboard!.instantiateViewController(withIdentifier: "TimetrialQuizModeController") as? TimetrialQuizModeController {
				resultController.questionChoice = self.quizOptions
                present(resultController, animated: true, completion: nil)
			}
		}
    }
	
	//used for quiz length selection
	func displaySingleColumnButtons(buttonLabelSet: [String], textColor: UIColor, nextFunction: Selector){
		var posX: Int
		var posY: Int
		var counter = 1
		
		let viewHeight = Float(self.viewHeight)
		let viewWidth = Float(self.viewWidth)
		let gutterSize = Int(viewWidth / 18.75)
		let buttonWidth = Int(viewWidth) - (2 * gutterSize)
		posX = gutterSize;
		
		let buttonHeight = Int(((Int(viewHeight * 0.5) / (buttonLabelSet.count)) - gutterSize))
		
		for label in buttonLabelSet {
			
			posY = Int(80 + (counter * (buttonHeight + gutterSize)))
			
			let customButton = CustomButton(
				frame: CGRect(x: posX, y: posY, width: buttonWidth, height: buttonHeight)
			)
            customButton.setTitleColor(textColor, for: .normal)
            customButton.setTitle(label, for: .normal)
            customButton.titleLabel!.font = UIFont.boldMainFontOfSize(fontSize: CGFloat(viewWidth / 14.4))
            customButton.addTarget(self, action: nextFunction, for: .touchUpInside)
			customButton.backgroundColor = appColors["white"]
			self.view.addSubview(customButton)
			customButton.tag = 1
			counter = counter + 1
		}
	}
	
	func displayTwoColumnButtons(buttonLabelSet: [String], textColor: UIColor, nextFunction: Selector){
		
		var posX: Int
		var posY: Int
		var counter = 0
		
		//select (x, y, width, height) based on actual view dimensions
		let viewHeight = Float(self.viewHeight)
		let viewWidth = Float(self.viewWidth)
		
		let gutterWidth = viewWidth / 18.75
		let buttonWidth = (viewWidth - (3 * gutterWidth)) / 2
		
		//get 75% of height, remove gutter space and divide remaining area by 3
		let buttonHeight = (((viewHeight) * 0.75) - (4 * gutterWidth)) / 3
		
		let spacing: CGFloat = viewHeight >= 568 ? 6 : 4
        let edgeInsets = UIEdgeInsets(top: 0.0, left: -80.0, bottom: -(80.0 + spacing), right: 0.0);
		
		var labelString: NSString
		var titleSize: CGSize
		
		let screenAdjustmentFactor: CGFloat = viewHeight > 700 ? 11 : viewHeight > 568 ? 6 : (viewHeight == 568 ? -2 : -9.5)
		
		for label in buttonLabelSet {
			
			posX = Int(gutterWidth + (gutterWidth + buttonWidth) * Float(counter % 2))
			posY = Int((gutterWidth + buttonHeight + (viewHeight > 568 ? 0 : 10)) * Float( 1 + counter / 2))
			
			let image = UIImage(named: label)
			
			let customButton = CustomButton(
				frame: CGRect(x: posX, y: posY, width: Int(buttonWidth), height: Int(buttonHeight))
			)
            customButton.setImage(image, for: .normal)
            customButton.setTitleColor(appColors["white"], for: .normal)
            customButton.setTitle(label, for: .normal)
            customButton.titleLabel!.font = UIFont.boldMainFontOfSize(fontSize: CGFloat(viewWidth / 14.4))
            customButton.addTarget(self, action: nextFunction, for: .touchUpInside)
			customButton.tag = 1
			
			customButton.titleEdgeInsets = edgeInsets
			labelString = NSString(string: customButton.titleLabel!.text!)
            titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: customButton.titleLabel!.font])
            customButton.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width);
			
			let buttonImageBorder = UIView(frame: CGRect(
				x: customButton.frame.origin.x + ((customButton.frame.width - 80) / 2) - (viewHeight >= 568 ? 5 : 2.5),
				y: customButton.frame.origin.y + screenAdjustmentFactor,
				width: 80 + (viewHeight >= 568 ? 10 : 5),
				height: 80 + (viewHeight >= 568 ? 10 : 5)
				))
			buttonImageBorder.layer.cornerRadius = (80 + (viewHeight >= 568 ? 10 : 5)) / 2
			buttonImageBorder.backgroundColor = appColors["white"]
			buttonImageBorder.tag = 1
				
            fadeUpInToSubview(target: buttonImageBorder, delay: 0.25 + (0.05 * Double(( counter == 0 || counter == 1 ? 0 : counter == 2 || counter == 3 ? 1 : 2))), completionAction: nil)
			
            fadeUpInToSubview(target: customButton, delay: 0.25 + (0.05 * Double(( counter == 0 || counter == 1 ? 0 : counter == 2 || counter == 3 ? 1 : 2))), completionAction: nil)
			counter = counter + 1
		}
	}
	
}
