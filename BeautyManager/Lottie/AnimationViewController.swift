//
//  AnimationViewController.swift
//  BeautyManager
//
//  Created by SurbineHuang on 8/6/21.
//

import UIKit
import Lottie

class AnimationViewController: UIViewController {

    @IBOutlet weak var animationView: AnimationView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let animation = Animation.named("cosmetic")
        animationView.animation = animation
        animationView.animationSpeed = 0.8
        animationView.play()
        animationView.loopMode = .loop
    }
}
