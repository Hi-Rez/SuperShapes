//
//  ViewController.swift
//  YouiTwo
//
//  Created by Reza Ali on 2/2/21.
//

import Forge
import Satin
import UIKit

class ViewController: Forge.ViewController {
    override var prefersHomeIndicatorAutoHidden: Bool {
        true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.renderer = Renderer()
    }
}
