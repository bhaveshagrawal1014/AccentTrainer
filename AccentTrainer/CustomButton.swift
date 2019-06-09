//
//  CustomButton.swift
//  AccentTrainer
//
//  Created by Bhavesh Agrawal on 09/06/2019.
//  Copyright © 2019 Dexter. All rights reserved.
//

import Foundation
import UIKit

class CustomButton: UIButton{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 10
    }
	
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
    }
}
