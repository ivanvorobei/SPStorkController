// The MIT License (MIT)
// Copyright © 2017 Ivan Vorobei (hello@ivanvorobei.by)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

public enum SPStorkController {
    
    static public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let controller = self.controller(for: scrollView) {
            if let presentationController = self.presentationController(for: controller) {
                let translation = -(scrollView.contentOffset.y + scrollView.contentInset.top)
                if translation >= 0 {
                    if controller.isBeingPresented { return }
                    scrollView.subviews.forEach {
                        $0.transform = CGAffineTransform(translationX: 0, y: -translation)
                    }
                    presentationController.setIndicator(style: scrollView.isTracking ? .line : .arrow)
                    if translation >= presentationController.translateForDismiss * 0.4 {
                        if !scrollView.isTracking && !scrollView.isDragging {
                            self.dismissWithConfirmation(controller: controller, completion: {
                                presentationController.storkDelegate?.didDismissStorkBySwipe?()
                            })
                            return
                        }
                    }
                    if presentationController.pan?.state != UIGestureRecognizer.State.changed {
                        presentationController.scrollViewDidScroll(translation * 2)
                    }
                } else {
                    presentationController.setIndicator(style: .arrow)
                    presentationController.scrollViewDidScroll(0)
                }
                
                if translation < -5 {
                    presentationController.setIndicator(visible: false, forse: (translation < -50))
                } else {
                    presentationController.setIndicator(visible: true, forse: false)
                }
            }
        }
    }
    
    static public func dismissWithConfirmation(controller: UIViewController, completion: (()->())?) {
        if let controller = self.presentationController(for: controller) {
            controller.dismissWithConfirmation(prepare: nil, completion: {
                completion?()
            })
        }
    }
    
    static public var topScrollIndicatorInset: CGFloat {
        return 6
    }
    
    static public func updatePresentingController(parent controller: UIViewController) {
        if let presentationController = controller.presentedViewController?.presentationController as? SPStorkPresentationController {
            presentationController.updatePresentingController()
        }
    }
    
    static public func updatePresentingController(modal controller: UIViewController) {
        if let presentationController = controller.presentationController as? SPStorkPresentationController {
            presentationController.updatePresentingController()
        }
    }
    
    static private func presentationController(for controller: UIViewController) -> SPStorkPresentationController? {
        guard controller.modalPresentationStyle == .custom else { return nil }
        
        if let presentationController = controller.presentationController as? SPStorkPresentationController {
            return presentationController
        }
        
        if let presentationController = controller.parent?.presentationController as? SPStorkPresentationController {
            return presentationController
        }
        return nil
    }
    
    static private func controller(for view: UIView) -> UIViewController? {
        var nextResponder = view.next
        while nextResponder != nil && !(nextResponder! is UIViewController) {
            nextResponder = nextResponder!.next
        }
        return nextResponder as? UIViewController
    }
}
