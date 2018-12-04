//
//  ViewController.swift
//  SPStorkController
//
//  Created by finngaida on 12/04/2018.
//  Copyright (c) 2018 finngaida. All rights reserved.
//

import UIKit
import SPStorkController

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewWasTapped))
        view.addGestureRecognizer(tap)

        print("Tap anywhere to present modal controller")
    }

    @objc func viewWasTapped() {
        let modal = UIViewController()
        let transitionDelegate = SPStorkTransitioningDelegate()
        modal.transitioningDelegate = transitionDelegate
        modal.modalPresentationStyle = .custom
        present(modal, animated: true, completion: nil)
    }

}

