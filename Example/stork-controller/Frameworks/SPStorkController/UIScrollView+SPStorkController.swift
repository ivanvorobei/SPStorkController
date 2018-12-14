//
//  UIScrollView+SPStorkController.swift
//  stork-controller
//
//  Created by Garrett Xu on 2018/12/14.
//  Copyright © 2018 Ivan Vorobei. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC

public protocol SPStorkGestureRecognizerDelegate {
    func shouldRecognizeSimultaneouslyWithSPStorkPan() -> Bool
}

private var SP_STORK_GESTURE_RECOGNIZER_DELEGATE_ASSOCIATION_KEY = "SP_STORK_GESTURE_RECOGNIZER_DELEGATE"

extension UIScrollView {
    open var spStorkGestureRecognizerDelegate: SPStorkGestureRecognizerDelegate? {
        get {
            return objc_getAssociatedObject(self, &SP_STORK_GESTURE_RECOGNIZER_DELEGATE_ASSOCIATION_KEY) as? SPStorkGestureRecognizerDelegate
        }
        set {
            objc_setAssociatedObject(self, &SP_STORK_GESTURE_RECOGNIZER_DELEGATE_ASSOCIATION_KEY, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

extension SPStorkPresentationController {
    // TODO To be optimized
    private func isSPStorkPanGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else { return false }
        guard let gestureRecognizers = self.presentedView?.gestureRecognizers else { return false }
        return gestureRecognizers.contains(panGestureRecognizer)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let spStorkGestureRecognizerDelegate = (otherGestureRecognizer.view as? UIScrollView)?.spStorkGestureRecognizerDelegate else { return false }
        return isSPStorkPanGestureRecognizer(gestureRecognizer) && spStorkGestureRecognizerDelegate.shouldRecognizeSimultaneouslyWithSPStorkPan()

    }
}
