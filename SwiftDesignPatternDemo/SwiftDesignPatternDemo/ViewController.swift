//
//  ViewController.swift
//  SwiftDesignPatternDemo
//
//  Created by yuhua Tang on 2023/6/13.
//

import UIKit
import TYHTestUtils
class ViewController: BaseTestActionTableVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Behavioral
        addCell("Chain Of Responsibility") {
            ChainOfResponsibility()
        }
    }


}

