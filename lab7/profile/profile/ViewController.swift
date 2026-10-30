//
//  ViewController.swift
//  profile
//
//  Created by Нурали Муратов on 28.10.2026.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var followButton: UIButton!
    @IBOutlet var messageButton: UIButton!
    @IBOutlet var aboutlabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        followButton.layer.cornerRadius=16
        messageButton.layer.cornerRadius=16
    }


}

