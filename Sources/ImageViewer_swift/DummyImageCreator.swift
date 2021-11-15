//
//  DummyImageCreator.swift
//  
//
//  Created by Karo Sahafi on 11/15/21.
//

import Foundation
import UIKit
import AVFoundation

protocol DummyImageCreator {
    func createDummyImageView(basedOn imageView: UIImageView?) -> DummyImageView
}

extension DummyImageCreator {
    func createDummyImageView(basedOn imageView: UIImageView?) -> DummyImageView {
        let frame = imageView?.frameRelativeToWindow() ?? UIScreen.main.bounds
        let dummyImageView: DummyImageView = DummyImageView(image: imageView?.image)
        dummyImageView.frame = frame
        dummyImageView.clipsToBounds = true
        dummyImageView.contentMode = imageView?.contentMode ?? .scaleToFill
        dummyImageView.alpha = 1.0
        dummyImageView.image = imageView?.image
        return dummyImageView
    }
}
