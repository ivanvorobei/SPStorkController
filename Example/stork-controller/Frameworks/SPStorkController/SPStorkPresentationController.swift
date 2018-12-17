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

class SPStorkPresentationController: UIPresentationController, UIGestureRecognizerDelegate {
    
    var isSwipeToDismissEnabled: Bool = true
    var isTapAroundToDismissEnabled: Bool = true
    var showIndicator: Bool = true
    var customHeight: CGFloat? = nil
    var transitioningDelegate: SPStorkTransitioningDelegate?
    
    var pan: UIPanGestureRecognizer?
    var tap: UITapGestureRecognizer?
    
    private var indicatorView = SPStorkIndicatorView()
    private var gradeView: UIView = UIView()
    private let snapshotViewContainer = UIView()
    private var snapshotView: UIView?
    private let backgroundView = UIView()
    
    private var snapshotViewTopConstraint: NSLayoutConstraint?
    private var snapshotViewWidthConstraint: NSLayoutConstraint?
    private var snapshotViewAspectRatioConstraint: NSLayoutConstraint?
    private var workGester: Bool = false
    private var startDismissing: Bool = false
    
    private var topSpace: CGFloat {
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        return (statusBarHeight < 25) ? 30 : statusBarHeight
    }
    
    private var alpha: CGFloat {
        return 0.51
    }
    
    private var cornerRadius: CGFloat {
        return 10
    }
    
    private var scaleForPresentingView: CGFloat {
        guard let containerView = containerView else { return 0 }
        let factor = 1 - (self.topSpace * 2 / containerView.frame.height)
        return factor
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        let additionTranslate = containerView.bounds.height - (self.customHeight ?? containerView.bounds.height)
        let yOffset: CGFloat = self.topSpace + 13 + additionTranslate
        return CGRect(x: 0, y: yOffset, width: containerView.bounds.width, height: containerView.bounds.height - yOffset)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        guard let containerView = self.containerView, let presentedView = self.presentedView, let window = containerView.window  else { return }
        
        if self.showIndicator {
            presentedView.addSubview(self.indicatorView)
        }
        self.updateLayoutIndicator()
        self.indicatorView.style = .arrow
        self.gradeView.alpha = 0
        
        let initialFrame: CGRect = presentingViewController.isPresentedAsStork ? presentingViewController.view.frame : containerView.bounds
        
        containerView.insertSubview(self.snapshotViewContainer, belowSubview: presentedViewController.view)
        self.snapshotViewContainer.frame = initialFrame
        self.updateSnapshot()
        self.snapshotView?.layer.cornerRadius = 0
        self.backgroundView.backgroundColor = UIColor.black
        self.backgroundView.translatesAutoresizingMaskIntoConstraints = false
        containerView.insertSubview(self.backgroundView, belowSubview: self.snapshotViewContainer)
        NSLayoutConstraint.activate([
            self.backgroundView.topAnchor.constraint(equalTo: window.topAnchor),
            self.backgroundView.leftAnchor.constraint(equalTo: window.leftAnchor),
            self.backgroundView.rightAnchor.constraint(equalTo: window.rightAnchor),
            self.backgroundView.bottomAnchor.constraint(equalTo: window.bottomAnchor)
        ])
        
        let transformForSnapshotView = CGAffineTransform.identity
            .translatedBy(x: 0, y: -snapshotViewContainer.frame.origin.y)
            .translatedBy(x: 0, y: self.topSpace)
            .translatedBy(x: 0, y: -snapshotViewContainer.frame.height / 2)
            .scaledBy(x: scaleForPresentingView, y: scaleForPresentingView)
            .translatedBy(x: 0, y: snapshotViewContainer.frame.height / 2)
        
        self.addCornerRadiusAnimation(for: self.snapshotView, cornerRadius: self.cornerRadius, duration: 0.6)
        self.snapshotView?.layer.masksToBounds = true
        if #available(iOS 11.0, *) {
            presentedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        presentedView.layer.cornerRadius = self.cornerRadius
        presentedView.layer.masksToBounds = true
        
        var rootSnapshotView: UIView?
        var rootSnapshotRoundedView: UIView?
        
        if presentingViewController.isPresentedAsStork {
            guard let rootController = presentingViewController.presentingViewController, let snapshotView = rootController.view.snapshotView(afterScreenUpdates: false) else { return }
            
            containerView.insertSubview(snapshotView, aboveSubview: self.backgroundView)
            snapshotView.frame = initialFrame
            snapshotView.transform = transformForSnapshotView
            snapshotView.alpha = self.alpha
            snapshotView.layer.cornerRadius = self.cornerRadius
            snapshotView.layer.masksToBounds = true
            rootSnapshotView = snapshotView
            
            let snapshotRoundedView = UIView()
            snapshotRoundedView.layer.cornerRadius = self.cornerRadius
            snapshotRoundedView.layer.masksToBounds = true
            containerView.insertSubview(snapshotRoundedView, aboveSubview: snapshotView)
            snapshotRoundedView.frame = initialFrame
            snapshotRoundedView.transform = transformForSnapshotView
            rootSnapshotRoundedView = snapshotRoundedView
        }
        
        presentedViewController.transitionCoordinator?.animate(
            alongsideTransition: { [weak self] context in
                guard let `self` = self else { return }
                self.snapshotView?.transform = transformForSnapshotView
                self.gradeView.alpha = self.alpha
            }, completion: { _ in
                self.snapshotView?.transform = .identity
                rootSnapshotView?.removeFromSuperview()
                rootSnapshotRoundedView?.removeFromSuperview()
        })
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        guard let containerView = containerView else { return }
        self.updateSnapshot()
        self.presentedViewController.view.frame = self.frameOfPresentedViewInContainerView
        self.snapshotViewContainer.transform = .identity
        self.snapshotViewContainer.translatesAutoresizingMaskIntoConstraints = false
        self.snapshotViewContainer.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        self.updateSnapshotAspectRatio()
        
        if self.isTapAroundToDismissEnabled {
            self.tap = UITapGestureRecognizer.init(target: self, action: #selector(self.handleTap))
            self.tap?.cancelsTouchesInView = false
            self.snapshotViewContainer.addGestureRecognizer(self.tap!)
        }
        
        if self.isSwipeToDismissEnabled {
            self.pan = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan))
            self.pan!.delegate = self
            self.pan!.maximumNumberOfTouches = 1
            self.pan!.cancelsTouchesInView = false
            self.presentedViewController.view.addGestureRecognizer(self.pan!)
        }
    }
    
    @objc func handleTap() {
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        guard let containerView = containerView else { return }
        self.startDismissing = true
        
        let initialFrame: CGRect = presentingViewController.isPresentedAsStork ? presentingViewController.view.frame : containerView.bounds

        let initialTransform = CGAffineTransform.identity
            .translatedBy(x: 0, y: -initialFrame.origin.y)
            .translatedBy(x: 0, y: self.topSpace)
            .translatedBy(x: 0, y: -initialFrame.height / 2)
            .scaledBy(x: scaleForPresentingView, y: scaleForPresentingView)
            .translatedBy(x: 0, y: initialFrame.height / 2)
        
        self.snapshotViewTopConstraint?.isActive = false
        self.snapshotViewWidthConstraint?.isActive = false
        self.snapshotViewAspectRatioConstraint?.isActive = false
        self.snapshotViewContainer.translatesAutoresizingMaskIntoConstraints = true
        self.snapshotViewContainer.frame = initialFrame
        self.snapshotViewContainer.transform = initialTransform
        
        let finalCornerRadius = presentingViewController.isPresentedAsStork ? self.cornerRadius : 0
        let finalTransform: CGAffineTransform = .identity
        
        self.addCornerRadiusAnimation(for: self.snapshotView, cornerRadius: finalCornerRadius, duration: 0.6)
        
        var rootSnapshotView: UIView?
        var rootSnapshotRoundedView: UIView?
        
        if presentingViewController.isPresentedAsStork {
            guard let rootController = presentingViewController.presentingViewController, let snapshotView = rootController.view.snapshotView(afterScreenUpdates: false) else { return }
            
            containerView.insertSubview(snapshotView, aboveSubview: backgroundView)
            snapshotView.frame = initialFrame
            snapshotView.transform = initialTransform
            rootSnapshotView = snapshotView
            snapshotView.layer.cornerRadius = self.cornerRadius
            snapshotView.layer.masksToBounds = true
            
            let snapshotRoundedView = UIView()
            snapshotRoundedView.layer.cornerRadius = self.cornerRadius
            snapshotRoundedView.layer.masksToBounds = true
            snapshotRoundedView.backgroundColor = UIColor.black.withAlphaComponent(1 - self.alpha)
            containerView.insertSubview(snapshotRoundedView, aboveSubview: snapshotView)
            snapshotRoundedView.frame = initialFrame
            snapshotRoundedView.transform = initialTransform
            rootSnapshotRoundedView = snapshotRoundedView
        }
        
        presentedViewController.transitionCoordinator?.animate(
            alongsideTransition: { [weak self] context in
                guard let `self` = self else { return }
                self.snapshotView?.transform = .identity
                self.snapshotViewContainer.transform = finalTransform
                self.gradeView.alpha = 0
            }, completion: { _ in
                rootSnapshotView?.removeFromSuperview()
                rootSnapshotRoundedView?.removeFromSuperview()
        })
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        guard let containerView = containerView else { return }
        
        self.backgroundView.removeFromSuperview()
        self.snapshotView?.removeFromSuperview()
        self.snapshotViewContainer.removeFromSuperview()
        
        let offscreenFrame = CGRect(x: 0, y: containerView.bounds.height, width: containerView.bounds.width, height: containerView.bounds.height)
        presentedViewController.view.frame = offscreenFrame
        presentedViewController.view.transform = .identity
    }
}

extension SPStorkPresentationController {
    
    @objc func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        guard gestureRecognizer.isEqual(pan), self.isSwipeToDismissEnabled else { return }
        
        switch gestureRecognizer.state {
        case .began:
            self.workGester = true
            self.indicatorView.style = .line
            self.presentingViewController.view.layer.removeAllAnimations()
            gestureRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: containerView)
        case .changed:
            self.workGester = true
            if self.isSwipeToDismissEnabled {
                let translation = gestureRecognizer.translation(in: presentedView)
                self.updatePresentedViewForTranslation(inVerticalDirection: translation.y)
            } else {
                gestureRecognizer.setTranslation(.zero, in: presentedView)
            }
        case .ended:
            self.workGester = false
            let translation = gestureRecognizer.translation(in: presentedView).y
            if translation >= 240 {
                presentedViewController.dismiss(animated: true, completion: nil)
            } else {
                self.indicatorView.style = .arrow
                UIView.animate(
                    withDuration: 0.6,
                    delay: 0,
                    usingSpringWithDamping: 1,
                    initialSpringVelocity: 1,
                    options: [.curveEaseOut, .allowUserInteraction],
                    animations: {
                        self.snapshotView?.transform = .identity
                        self.presentedView?.transform = .identity
                        self.gradeView.alpha = self.alpha
                })
            }
        default:
            break
        }
    }
    
    func scrollViewDidScroll(_ translation: CGFloat) {
        if !self.workGester {
            self.updatePresentedViewForTranslation(inVerticalDirection: translation)
        }
    }
    
    func updatePresentingController() {
        if self.startDismissing { return }
        self.updateSnapshot()
    }
    
    private func updatePresentedViewForTranslation(inVerticalDirection translation: CGFloat) {
        if self.startDismissing { return }
        
        let elasticThreshold: CGFloat = 120
        let translationFactor: CGFloat = 1 / 2

        if translation >= 0 {
            let translationForModal: CGFloat = {
                if translation >= elasticThreshold {
                    let frictionLength = translation - elasticThreshold
                    let frictionTranslation = 30 * atan(frictionLength / 120) + frictionLength / 10
                    return frictionTranslation + (elasticThreshold * translationFactor)
                } else {
                    return translation * translationFactor
                }
            }()
            
            self.presentedView?.transform = CGAffineTransform(translationX: 0, y: translationForModal)
            
            let factor = 1 + (translationForModal / 6000)
            self.snapshotView?.transform = CGAffineTransform.init(scaleX: factor, y: factor)
            self.gradeView.alpha = self.alpha - ((factor - 1) * 15)
        }
    }
}

extension SPStorkPresentationController {
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        guard let containerView = containerView else { return }
        self.updateSnapshotAspectRatio()
        if presentedViewController.view.isDescendant(of: containerView) {
            UIView.animate(withDuration: 0.1) { [weak self] in
                guard let `self` = self else { return }
                self.presentedViewController.view.frame = self.frameOfPresentedViewInContainerView
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { contex in
            self.updateLayoutIndicator()
        }, completion: { [weak self] _ in
            self?.updateSnapshotAspectRatio()
            self?.updateSnapshot()
        })
    }
    
    private func updateLayoutIndicator() {
        guard let presentedView = self.presentedView else { return }
        self.indicatorView.style = .line
        self.indicatorView.sizeToFit()
        self.indicatorView.frame.origin.y = 12
        self.indicatorView.center.x = presentedView.frame.width / 2
    }
    
    private func updateSnapshot() {
        guard let currentSnapshotView = presentingViewController.view.snapshotView(afterScreenUpdates: true) else { return }
        self.snapshotView?.removeFromSuperview()
        self.snapshotViewContainer.addSubview(currentSnapshotView)
        self.constraints(view: currentSnapshotView, to: self.snapshotViewContainer)
        self.snapshotView = currentSnapshotView
        self.snapshotView?.layer.cornerRadius = self.cornerRadius
        self.snapshotView?.layer.masksToBounds = true
        if #available(iOS 11.0, *) {
            snapshotView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        self.gradeView.removeFromSuperview()
        self.gradeView.backgroundColor = UIColor.black
        self.snapshotView!.addSubview(self.gradeView)
        self.constraints(view: self.gradeView, to: self.snapshotView!)
    }
    
    private func updateSnapshotAspectRatio() {
        guard let containerView = containerView, snapshotViewContainer.translatesAutoresizingMaskIntoConstraints == false else { return }
        
        self.snapshotViewTopConstraint?.isActive = false
        self.snapshotViewWidthConstraint?.isActive = false
        self.snapshotViewAspectRatioConstraint?.isActive = false
        
        let snapshotReferenceSize = presentingViewController.view.frame.size
        let aspectRatio = snapshotReferenceSize.width / snapshotReferenceSize.height
        
        self.snapshotViewTopConstraint = snapshotViewContainer.topAnchor.constraint(equalTo: containerView.topAnchor, constant: self.topSpace)
        self.snapshotViewWidthConstraint = snapshotViewContainer.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: scaleForPresentingView)
        self.snapshotViewAspectRatioConstraint = snapshotViewContainer.widthAnchor.constraint(equalTo: snapshotViewContainer.heightAnchor, multiplier: aspectRatio)
        
        self.snapshotViewTopConstraint?.isActive = true
        self.snapshotViewWidthConstraint?.isActive = true
        self.snapshotViewAspectRatioConstraint?.isActive = true
    }
    
    private func constraints(view: UIView, to superView: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: superView.topAnchor),
            view.leftAnchor.constraint(equalTo: superView.leftAnchor),
            view.rightAnchor.constraint(equalTo: superView.rightAnchor),
            view.bottomAnchor.constraint(equalTo: superView.bottomAnchor)
        ])
    }
    
    private func addCornerRadiusAnimation(for view: UIView?, cornerRadius: CGFloat, duration: CFTimeInterval) {
        guard let view = view else { return }
        let animation = CABasicAnimation(keyPath:"cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.fromValue = view.layer.cornerRadius
        animation.toValue = cornerRadius
        animation.duration = duration
        view.layer.add(animation, forKey: "cornerRadius")
        view.layer.cornerRadius = cornerRadius
    }
}
