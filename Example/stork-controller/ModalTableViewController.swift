//
//  ModalTableViewController.swift
//  stork-controller
//
//  Created by 徐珺炜 on 2018/12/14.
//  Copyright © 2018 Ivan Vorobei. All rights reserved.
//

import Foundation
import UIKit

class ModalTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var data = ["Assembly",
                        "C",
                        "C++",
                        "Java",
                        "JavaScript",
                        "Php",
                        "Python",
                        "Objective-C",
                        "Swift",
                        "Kotlin",
                        "Assembly",
                        "C",
                        "C++",
                        "Java",
                        "JavaScript",
                        "Php",
                        "Python",
                        "Objective-C",
                        "Swift",
                        "Kotlin",
                        "Assembly",
                        "C",
                        "C++",
                        "Java",
                        "JavaScript",
                        "Php",
                        "Python",
                        "Objective-C",
                        "Swift",
                        "Kotlin",
                        "Assembly",
                        "C",
                        "C++",
                        "Java",
                        "JavaScript",
                        "Php",
                        "Python",
                        "Objective-C",
                        "Swift",
                        "Kotlin",]

    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.spStorkGestureRecognizerDelegate = self
    }
}

extension ModalTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
}

extension ModalTableViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        SPStorkController.scrollViewDidScroll(scrollView)
    }
}

extension ModalTableViewController: SPStorkGestureRecognizerDelegate {
    func shouldRecognizeSimultaneouslyWithSPStorkPan() -> Bool {
        return tableView.contentOffset.y <= 0
    }
}
