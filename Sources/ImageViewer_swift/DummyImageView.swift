//
//  DummyImageView.swift
//  
//
//  Created by Karo Sahafi on 11/15/21.
//

import Foundation
import UIKit

class DummyImageView: UIView {

    var image: UIImage? {
        get { return imageView.image }
        set { imageView.image = newValue }
    }

    var highlightedImage: UIImage? {
        get { return imageView.highlightedImage }
        set { imageView.highlightedImage = newValue }
    }

    var isHighlighted: Bool {
        get { return imageView.isHighlighted }
        set { imageView.isHighlighted = newValue }
    }

    var animationImages: [UIImage]? {
        get { return imageView.animationImages }
        set { imageView.animationImages = newValue }
    }

    var highlightedAnimationImages: [UIImage]? {
        get { return imageView.highlightedAnimationImages }
        set { imageView.highlightedAnimationImages = newValue }
    }

    var animationDuration: TimeInterval {
        get { return imageView.animationDuration }
        set { imageView.animationDuration = newValue }
    }

    var animationRepeatCount: Int {
        get { return imageView.animationRepeatCount }
        set { imageView.animationRepeatCount = newValue }
    }

    override var tintColor: UIColor! {
        get { return imageView.tintColor }
        set { imageView.tintColor = newValue }
    }

    func startAnimating() {
        imageView.startAnimating()
    }

    func stopAnimating() {
        imageView.stopAnimating()
    }

    var isAnimating: Bool {
        return imageView.isAnimating
    }

    private let imageView: UIImageView

    init(image: UIImage?) {
        imageView = UIImageView(image: image)
        super.init(frame: .zero)
        addSubview(imageView)
    }

    init(image: UIImage?, highlightedImage: UIImage?) {
        imageView = UIImageView(image: image, highlightedImage: highlightedImage)
        super.init(frame: .zero)
        addSubview(imageView)
    }

    required public init?(coder aDecoder: NSCoder) {
        imageView = UIImageView(image: nil)
        super.init(coder: aDecoder)
        addSubview(imageView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutImageView()
    }

    override var contentMode: UIView.ContentMode {
        didSet { layoutImageView() }
    }

    private func layoutImageView() {

        guard let image = imageView.image else { return }

        // MARK: - Layout Helpers
        func imageToBoundsWidthRatio(image: UIImage) -> CGFloat  { return image.size.width / bounds.size.width }
        func imageToBoundsHeightRatio(image: UIImage) -> CGFloat { return image.size.height / bounds.size.height }
        func centerImageViewToPoint(point: CGPoint)              { imageView.center = point }
        func imageViewBoundsToImageSize()                        { imageViewBoundsToSize(size: image.size) }
        func imageViewBoundsToSize(size: CGSize)                 { imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height) }
        func centerImageView()                                   { imageView.center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2) }

        // MARK: - Layouts
        func layoutAspectFit() {
            let widthRatio = imageToBoundsWidthRatio(image: image)
            let heightRatio = imageToBoundsHeightRatio(image: image)
            imageViewBoundsToSize(size: CGSize(width: image.size.width / max(widthRatio, heightRatio), height: image.size.height / max(widthRatio, heightRatio)))
            centerImageView()
        }

        func layoutAspectFill() {
            let widthRatio = imageToBoundsWidthRatio(image: image)
            let heightRatio = imageToBoundsHeightRatio(image: image)
            imageViewBoundsToSize(size: CGSize(width: image.size.width /  min(widthRatio, heightRatio), height: image.size.height / min(widthRatio, heightRatio)))
            centerImageView()
        }

        func layoutFill() {
            imageViewBoundsToSize(size: CGSize(width: bounds.size.width, height: bounds.size.height))
        }

        func layoutCenter() {
            imageViewBoundsToImageSize()
            centerImageView()
        }

        func layoutTop() {
            imageViewBoundsToImageSize()
            centerImageViewToPoint(point: CGPoint(x: bounds.size.width / 2, y: image.size.height / 2))
        }

        func layoutBottom() {
            imageViewBoundsToImageSize()
            centerImageViewToPoint(point: CGPoint(x: bounds.size.width / 2, y: bounds.size.height - image.size.height / 2))
        }

        func layoutLeft() {
            imageViewBoundsToImageSize()
            centerImageViewToPoint(point: CGPoint(x: image.size.width / 2, y: bounds.size.height / 2))
        }

        func layoutRight() {
            imageViewBoundsToImageSize()
            centerImageViewToPoint(point: CGPoint(x: bounds.size.width - image.size.width / 2, y: bounds.size.height / 2))
        }

        func layoutTopLeft() {
            imageViewBoundsToImageSize()
            centerImageViewToPoint(point: CGPoint(x: image.size.width / 2, y: image.size.height / 2))
        }

        func layoutTopRight() {
            imageViewBoundsToImageSize()
            centerImageViewToPoint(point: CGPoint(x: bounds.size.width - image.size.width / 2, y: image.size.height / 2))
        }

        func layoutBottomLeft() {
            imageViewBoundsToImageSize()
            centerImageViewToPoint(point: CGPoint(x: image.size.width / 2, y: bounds.size.height - image.size.height / 2))
        }

        func layoutBottomRight() {
            imageViewBoundsToImageSize()
            centerImageViewToPoint(point: CGPoint(x: bounds.size.width - image.size.width / 2, y: bounds.size.height - image.size.height / 2))
        }

        switch contentMode {
        case .scaleAspectFit:  layoutAspectFit()
        case .scaleAspectFill: layoutAspectFill()
        case .scaleToFill:     layoutFill()
        case .redraw:          break;
        case .center:          layoutCenter()
        case .top:             layoutTop()
        case .bottom:          layoutBottom()
        case .left:            layoutLeft()
        case .right:           layoutRight()
        case .topLeft:         layoutTopLeft()
        case .topRight:        layoutTopRight()
        case .bottomLeft:      layoutBottomLeft()
        case .bottomRight:     layoutBottomRight()
        @unknown default:
            layoutAspectFit()
        }
    }
}
