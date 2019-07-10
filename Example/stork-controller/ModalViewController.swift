import UIKit

class ModalViewController: UIViewController {
    
    let navBar = SPFakeBarView(style: .stork)
    var lightStatusBar: Bool = false
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.lightStatusBar ? .lightContent : .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.modalPresentationCapturesStatusBarAppearance = true
        
        self.navBar.titleLabel.text = "View"
        self.navBar.leftButton.setTitle("Cancel", for: .normal)
        self.navBar.leftButton.addTarget(self, action: #selector(self.dismissAction), for: .touchUpInside)
        self.view.addSubview(self.navBar)
    }
    
    @objc func dismissAction() {
        if let storkPresentationController = self.presentationController as? SPStorkPresentationController {
            storkPresentationController.dismissWithConfirmation(prepare: nil, completion: {
                print("Custom completion for confirmation. Confirmation is optional.")
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lightStatusBar = true
        UIView.animate(withDuration: 0.3) { () -> Void in
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
}

extension ModalViewController: SPStorkControllerConfirmDelegate {
    
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
