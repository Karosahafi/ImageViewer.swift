//
//  ImageViewerTransitionPresenting.swift
//  
//
//  Created by Karo Sahafi on 11/14/21.
//

import Foundation
import UIKit
import AVFoundation

final class ImageViewerTransitionPresenting: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let key: UITransitionContextViewControllerKey =  .to
        guard let controller = transitionContext.viewController(forKey: key)
            else { return }

        guard
            let transitionVC = controller as? ImageViewerTransitionViewControllerConvertible,
            let sourceView = transitionVC.sourceView
        else { return }

        let transitionView = transitionContext.containerView
        let animationDuration = transitionDuration(using: transitionContext)

        sourceView.alpha = 0.0
        controller.view.alpha = 0.0

        transitionView.addSubview(controller.view)
        transitionVC.targetView?.alpha = 0.0

        let dummyImageView = createDummyImageView(basedOn: sourceView)
        dummyImageView.contentMode = sourceView.contentMode

        transitionView.addSubview(dummyImageView)

        UIView.animate(withDuration: animationDuration, animations: {
            dummyImageView.frame = UIScreen.main.bounds
            dummyImageView.contentMode = .scaleAspectFit
            controller.view.alpha = 1.0
        }) { finished in
            transitionVC.targetView?.alpha = 1.0
            dummyImageView.removeFromSuperview()
            transitionContext.completeTransition(finished)
        }
    }

    private func createDummyImageView(basedOn imageView: UIImageView)
        -> UIImageView {
            let frame = imageFrame(of: imageView)
            let dummyImageView: UIImageView = UIImageView(frame: frame)
            dummyImageView.clipsToBounds = true
            dummyImageView.contentMode = imageView.contentMode
            dummyImageView.alpha = 1.0
            dummyImageView.image = imageView.image
            return dummyImageView
    }

    private func imageFrame(of imageView: UIImageView) -> CGRect {
        switch imageView.contentMode {
        case .scaleToFill:
            return imageView.frameRelativeToWindow()
        case .scaleAspectFit:
            guard let image = imageView.image else {
                return imageView.frameRelativeToWindow()
            }
            let zeroOriginRect = AVMakeRect(aspectRatio: image.size, insideRect: imageView.frameRelativeToWindow())
            return rectCenterInOtherRect(outerRect: imageView.frameRelativeToWindow(), innerRect: zeroOriginRect)
        case .scaleAspectFill:
            guard let image = imageView.image else {
                return imageView.frameRelativeToWindow()
            }
            return scaledSize(outerRect: imageView.frameRelativeToWindow(), innerRect: image.size)
        case .redraw:
            return imageView.frameRelativeToWindow()
        case .center:
            return .zero
        case .top:
            return .zero
        case .bottom:
            return .zero
        case .left:
            return .zero
        case .right:
            return .zero
        case .topLeft:
            return .zero
        case .topRight:
            return .zero
        case .bottomLeft:
            return .zero
        case .bottomRight:
            return .zero
        @unknown default:
            return .zero
        }
    }

    private func rectCenterInOtherRect(outerRect: CGRect, innerRect: CGRect) -> CGRect {
        return CGRect(
            x: outerRect.midX - (innerRect.size.width / 2),
            y: outerRect.midY - (innerRect.size.height / 2),
            width: innerRect.size.width,
            height: innerRect.size.height
        )
    }

    private func scaledSize(outerRect: CGRect, innerRect: CGSize) -> CGRect {
        if outerRect.height / outerRect.width > innerRect.height / innerRect.width {
            let scale = outerRect.height / innerRect.height
            let scaledWidth = innerRect.width * scale

            let originX = outerRect.origin.x - ((scaledWidth - outerRect.width) / 2)
            return CGRect(
                origin: CGPoint(x: originX, y: outerRect.origin.y),
                size: .init(width: scaledWidth, height: outerRect.height)
            )
        } else {
            let scale = outerRect.width / innerRect.width
            print(scale)
            let scaledHeight = innerRect.height * scale

            let originY = outerRect.origin.y - ((scaledHeight - outerRect.height) / 2)
            return CGRect(
                origin: CGPoint(x: outerRect.origin.x, y: originY),
                size: .init(width: outerRect.width, height: scaledHeight)
            )
        }
    }
}
