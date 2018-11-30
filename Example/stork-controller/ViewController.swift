import UIKit

class ViewController: SPStatusBarManagerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewWasTapped))
        view.addGestureRecognizer(tap)
        
        print("Tap anymore for present modal controller")
    }
    
    @objc func viewWasTapped() {
        let modal = ModalViewController()
        let transitionDelegate = SPStorkTransitioningDelegate()
        modal.transitioningDelegate = transitionDelegate
        modal.modalPresentationStyle = .custom
        present(modal, animated: true, completion: nil)
    }
}

class ModalViewController: UIViewController {
    
    let navBar = SPFakeBarView(style: .stork)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.modalPresentationCapturesStatusBarAppearance = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewWasTapped))
        view.addGestureRecognizer(tap)
        
        self.navBar.titleLabel.text = "Title"
        self.navBar.leftButton.setTitle("Cancel")
        self.navBar.leftButton.target {
            self.dismiss()
        }
        self.view.addSubview(self.navBar)
    }
    
    @objc func viewWasTapped() {
        self.dismiss()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

