//
//  ImageViewerTransitionDismiss.swift
//  
//
//  Created by Karo Sahafi on 11/14/21.
//

import Foundation
import UIKit

final class ImageViewerTransitionDismiss: NSObject, UIViewControllerAnimatedTransitioning, DummyImageCreator {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.320
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let key: UITransitionContextViewControllerKey =  .from
        guard let controller = transitionContext.viewController(forKey: key)
            else { return }

        guard
            let transitionVC = controller as? ImageViewerTransitionViewControllerConvertible
        else { return }

        let transitionView = transitionContext.containerView
        let animationDuration = transitionDuration(using: transitionContext)

        let sourceView = transitionVC.sourceView
        let targetView = transitionVC.targetView
        
        let dummyImageView = createDummyImageView(basedOn: targetView)
        dummyImageView.frame = targetView?.frameRelativeToWindow() ?? UIScreen.main.bounds
        transitionView.addSubview(dummyImageView)
        targetView?.isHidden = true

        controller.view.alpha = 1.0
        UIView.animate(withDuration: animationDuration, animations: {
            if let sourceView = sourceView {
                dummyImageView.frame = sourceView.frameRelativeToWindow()
                dummyImageView.contentMode = sourceView.contentMode
            } else {
                dummyImageView.alpha = 0.0
            }
            controller.view.alpha = 0.0
        }) { finished in
            sourceView?.alpha = 1.0
            controller.view.removeFromSuperview()
            transitionContext.completeTransition(finished)
        }
    }
}
