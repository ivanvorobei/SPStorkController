import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewWasTapped))
//        view.addGestureRecognizer(tap)
//
//        print("Tap anymore for present modal controller")
    }
    
    @IBAction func presentModalViewController(_ sender: Any) {
        let modal = ModalViewController()
        let transitionDelegate = SPStorkTransitioningDelegate()
        modal.transitioningDelegate = transitionDelegate
        modal.modalPresentationStyle = .custom
        present(modal, animated: true, completion: nil)
    }

    @IBAction func presentModalTableViewController(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModalTableViewController") as! ModalTableViewController
        let transitionDelegate = SPStorkTransitioningDelegate()
        vc.transitioningDelegate = transitionDelegate
        vc.modalPresentationStyle = .custom
        present(vc, animated: true, completion: nil)
    }
    //    @objc func viewWasTapped() {
//        let modal = ModalViewController()
//        let transitionDelegate = SPStorkTransitioningDelegate()
//        modal.transitioningDelegate = transitionDelegate
//        modal.modalPresentationStyle = .custom
//        present(modal, animated: true, completion: nil)
//    }
}

class ModalViewController: UIViewController {
    
    let navBar = SPFakeBarView(style: .stork)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.modalPresentationCapturesStatusBarAppearance = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissAction))
        view.addGestureRecognizer(tap)
        
        self.navBar.titleLabel.text = "Title"
        self.navBar.leftButton.setTitle("Cancel", for: .normal)
        self.navBar.leftButton.addTarget(self, action: #selector(self.dismissAction), for: .touchUpInside)
        self.view.addSubview(self.navBar)
    }
    
    @objc func dismissAction() {
        self.dismiss()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
