//
//  ViewController.swift
//  LearningSiriKit
//
//  Created by Rommel Rico on 11/1/17.
//  Copyright © 2017 Rommel Rico. All rights reserved.
//

import UIKit
import Intents

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        INPreferences.requestSiriAuthorization {
            status in
            if status == .authorized {
                print("Wonderful!")
            }
            else {
                print("Hmmm... This demo app is going to pretty useless if you don't enable Siri. Fancy changing your mind?")
            }
        }
    }

}

