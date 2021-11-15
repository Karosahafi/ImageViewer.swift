//
//  ImageViewerDelegate.swift
//  
//
//  Created by Karo Sahafi on 11/15/21.
//

import Foundation
import UIKit

public protocol ImageViewerDelegate: AnyObject {
    func imageViewer(didSlideToIndex index: Int)
}

public protocol ImageViewerDataSource: AnyObject {
    func numberOfImages() -> Int
    func imageItem(at index:Int) -> ImageItem
}
