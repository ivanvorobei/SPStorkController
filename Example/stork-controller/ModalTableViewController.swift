import UIKit

class ModalTableViewController: UIViewController {
    
    let navBar = SPFakeBarView(style: .stork)
    let tableView = UITableView()
    var lightStatusBar: Bool = false
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.lightStatusBar ? .lightContent : .default
    }
    
    private var data = ["Assembly", "C", "C++", "Java", "JavaScript", "Php", "Python", "Swift", "Kotlin", "Assembly", "C", "C++", "Java", "JavaScript", "Php", "Python", "Objective-C", "Swift", "Kotlin", "Assembly", "C", "C++", "Java", "JavaScript", "Php", "Python", "Objective-C"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.modalPresentationCapturesStatusBarAppearance = true

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.contentInset.top = self.navBar.height
        self.tableView.scrollIndicatorInsets.top = self.navBar.height
        self.view.addSubview(self.tableView)
        
        self.navBar.titleLabel.text = "Table"
        self.navBar.leftButton.setTitle("Cancel", for: .normal)
        self.navBar.leftButton.addTarget(self, action: #selector(self.dismissAction), for: .touchUpInside)
        self.view.addSubview(self.navBar)
        
        self.updateLayout(with: self.view.frame.size)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lightStatusBar = true
        UIView.animate(withDuration: 0.3) { () -> Void in
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.updateLayout(with: self.view.frame.size)
    }
    
    func updateLayout(with size: CGSize) {
        self.tableView.frame = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
    }
    
    @objc func dismissAction() {
        SPStorkController.dismissWithConfirmation(controller: self, completion: nil)
    }
}

extension ModalTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.transform = .identity
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    }
}

extension ModalTableViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.tableView {
            SPStorkController.scrollViewDidScroll(scrollView)
        }
    }
}

extension ModalTableViewController: SPStorkControllerConfirmDelegate {
    
    var needConfirm: Bool {
        return true
    }
    
    func confirm(_ completion: @escaping (Bool) -> ()) {
        let alertController = UIAlertController(title: "Need dismiss?", message: "It test confirm option for SPStorkController", preferredStyle: .actionSheet)
        alertController.addDestructiveAction(title: "Confirm", complection: {
            completion(true)
        })
        alertController.addCancelAction(title: "Cancel") {
            completion(false)
        }
        self.present(alertController)
    }
}
