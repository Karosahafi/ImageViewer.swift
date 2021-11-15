//
//  ImageViewerTransitionDismiss.swift
//  
//
//  Created by Karo Sahafi on 11/14/21.
//

import Foundation
import UIKit

final class ImageViewerTransitionDismiss: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        3
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

        let dummyImageView = createDummyImageView(
            frame: targetView?.frameRelativeToWindow() ?? UIScreen.main.bounds,
            image: targetView?.image)
        transitionView.addSubview(dummyImageView)
        targetView?.isHidden = true

        controller.view.alpha = 1.0
        UIView.animate(withDuration: animationDuration, animations: {
            if let sourceView = sourceView {
                // return to original position
                dummyImageView.frame = sourceView.frameRelativeToWindow()
            } else {
                // just disappear
                dummyImageView.alpha = 0.0
            }
            controller.view.alpha = 0.0
        }) { finished in
            sourceView?.alpha = 1.0
            controller.view.removeFromSuperview()
            transitionContext.completeTransition(finished)
        }
    }

    private func createDummyImageView(frame: CGRect, image:UIImage? = nil)
        -> UIImageView {
            let dummyImageView:UIImageView = UIImageView(frame: frame)
            dummyImageView.clipsToBounds = true
            dummyImageView.contentMode = .scaleAspectFill
            dummyImageView.alpha = 1.0
            dummyImageView.image = image
            return dummyImageView
    }
}
