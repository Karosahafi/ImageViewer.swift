import Foundation
import UIKit

public protocol ImageLoader {
    func loadImage(_ url: URL, placeholder: UIImage?, imageView: UIImageView, completion: @escaping (_ image: UIImage?) -> Void)
}
