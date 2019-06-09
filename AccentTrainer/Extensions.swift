//
//  Extensions.swift
//  AccentTrainer
//
//  Created by Bhavesh Agrawal on 09/06/2019.
//  Copyright © 2019 Dexter. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
	
	static func mainFontOfSize(fontSize: CGFloat) -> UIFont {
		var mainFont = UIFont(name: "MuseoSans-500", size: fontSize)
		if mainFont == nil {
            mainFont = UIFont.systemFont(ofSize: fontSize)
		}
		return mainFont!
	}
	
	static func boldMainFontOfSize(fontSize: CGFloat) -> UIFont {
		var mainFont = UIFont(name: "MuseoSans-700", size: fontSize)
		if mainFont == nil {
            mainFont = UIFont.boldSystemFont(ofSize: fontSize)
		}
		return mainFont!
	}
}
