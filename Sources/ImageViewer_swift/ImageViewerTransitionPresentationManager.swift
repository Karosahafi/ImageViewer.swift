//
//  ImageViewerTransitionPresentationManager.swift
//  ImageViewer.swift
//
//  Created by Michael Henry Pantaleon on 2020/08/19.
//

import Foundation
import UIKit

protocol ImageViewerTransitionViewControllerConvertible {
    // The source view
    var sourceView: UIImageView? { get }
    
    // The final view
    var targetView: UIImageView? { get }
}

final class ImageViewerTransitionPresentationController: UIPresentationController {
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController,
                          withParentContainerSize: containerView!.bounds.size)
        return frame
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
}

final class ImageViewerTransitionPresentationManager: NSObject {
    
}

// MARK: - UIViewControllerTransitioningDelegate
extension ImageViewerTransitionPresentationManager: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        let presentationController = ImageViewerTransitionPresentationController(
            presentedViewController: presented,
            presenting: presenting)
        return presentationController
    }
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return ImageViewerTransitionPresenting()
    }
    
    func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return ImageViewerTransitionDismiss()
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate
extension ImageViewerTransitionPresentationManager: UIAdaptivePresentationControllerDelegate {
    
    func adaptivePresentationStyle(
        for controller: UIPresentationController,
        traitCollection: UITraitCollection
    ) -> UIModalPresentationStyle {
        return .none
    }
    
    func presentationController(
        _ controller: UIPresentationController,
        viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle
    ) -> UIViewController? {
        return nil
    }
}
