import UIKit

class Controller: UIViewController {
    
    var presentControllerButton = UIButton.init(type: UIButton.ButtonType.system)
    var presentTableControllerButton = UIButton.init(type: UIButton.ButtonType.system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.presentControllerButton.setTitle("Show ViewController", for: .normal)
        self.presentControllerButton.addTarget(self, action: #selector(self.presentModalViewController), for: .touchUpInside)
        self.presentControllerButton.sizeToFit()
        self.presentControllerButton.center.x = self.view.frame.width  / 2
        self.presentControllerButton.center.y = self.view.frame.height / 4 * 3
        self.view.addSubview(self.presentControllerButton)
        
        self.presentTableControllerButton.setTitle("Show TableController", for: .normal)
        self.presentTableControllerButton.addTarget(self, action: #selector(self.presentModalTableViewController), for: .touchUpInside)
        self.presentTableControllerButton.sizeToFit()
        self.presentTableControllerButton.center.x = self.view.frame.width  / 2
        self.presentTableControllerButton.frame.origin.y = self.presentControllerButton.frame.bottomY + 10
        self.view.addSubview(self.presentTableControllerButton)
    }
    
    @objc func presentModalViewController() {
        let modal = ModalViewController()
        let transitionDelegate = SPStorkTransitioningDelegate()
        transitionDelegate.storkDelegate = self
        transitionDelegate.confirmDelegate = modal
        modal.transitioningDelegate = transitionDelegate
        modal.modalPresentationStyle = .custom
        self.present(modal, animated: true, completion: nil)
    }
    
    @objc func presentModalTableViewController() {
        let modal = ModalTableViewController()
        let transitionDelegate = SPStorkTransitioningDelegate()
        transitionDelegate.storkDelegate = self
        transitionDelegate.confirmDelegate = modal
        modal.transitioningDelegate = transitionDelegate
        modal.modalPresentationStyle = .custom
        self.present(modal, animated: true, completion: nil)
    }
}

extension Controller: SPStorkControllerDelegate {
    
    func didDismissStorkByTap() {
        print("SPStorkControllerDelegate - didDismissStorkByTap")
    }
    
    func didDismissStorkBySwipe() {
        print("SPStorkControllerDelegate - didDismissStorkBySwipe")
    }
}
