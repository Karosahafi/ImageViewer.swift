import UIKit

public class ImageCarouselViewController:UIPageViewController, ImageViewerTransitionViewControllerConvertible {

    var sourceView: UIImageView? {
        guard let vc = viewControllers?.first as? ImageViewerController else {
            return nil
        }
        return imageDatasource?.imageView(at: vc.index)
    }

    var targetView: UIImageView? {
        guard let vc = viewControllers?.first as? ImageViewerController else {
            return nil
        }
        return vc.imageView
    }
    
    weak var imageDatasource: ImageViewerDataSource?
    weak var imageDelegate: ImageViewerDelegate?
    let imageLoader: ImageLoader

    private var displayedIndex: Int
    private let initialIndex: Int
    
    private var options: [ImageViewerOption] = []
    
    private var onRightNavBarTapped:((Int) -> Void)?
    
    private(set) lazy var navBar: UINavigationBar = {
        let _navBar = UINavigationBar(frame: .zero)
        if #available(iOS 13.0, *) {
            _navBar.overrideUserInterfaceStyle = .dark
        }
        _navBar.isTranslucent = true
        _navBar.setBackgroundImage(UIImage(), for: .default)
        _navBar.shadowImage = UIImage()
        return _navBar
    }()
    
    private(set) lazy var backgroundView:UIView? = {
        let _v = UIView()
        _v.backgroundColor = .black
        _v.alpha = 1.0
        return _v
    }()
    
    private(set) lazy var navItem = UINavigationItem()
    
    private let imageViewerPresentationDelegate = ImageViewerTransitionPresentationManager()
    
    public init(
        sourceView:UIImageView,
        imageDataSource: ImageViewerDataSource?,
        imageDelegate: ImageViewerDelegate?,
        imageLoader: ImageLoader,
        options:[ImageViewerOption] = [],
        initialIndex:Int = 0) {
            self.initialIndex = initialIndex
            self.displayedIndex = initialIndex
            self.options = options
            self.imageDatasource = imageDataSource
            self.imageDelegate = imageDelegate
            self.imageLoader = imageLoader
            let pageOptions = [UIPageViewController.OptionsKey.interPageSpacing: 20]
            super.init(
                transitionStyle: .scroll,
                navigationOrientation: .horizontal,
                options: pageOptions)

            transitioningDelegate = imageViewerPresentationDelegate
            modalPresentationStyle = .custom
            modalPresentationCapturesStatusBarAppearance = true
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addNavBar() {
        // Add Navigation Bar
        let closeBarButton = UIBarButtonItem(
            title: NSLocalizedString("Close", comment: "Close button title"),
            style: .plain,
            target: self,
            action: #selector(dismiss(_:)))
        
        navItem.leftBarButtonItem = closeBarButton
        navItem.leftBarButtonItem?.tintColor = .white
        navBar.alpha = 0.0
        navBar.items = [navItem]
        navBar.insert(to: view)
    }
    
    private func addBackgroundView() {
        guard let backgroundView = backgroundView else { return }
        view.addSubview(backgroundView)
        backgroundView.bindFrameToSuperview()
        view.sendSubviewToBack(backgroundView)
    }
    
    private func applyOptions() {
        
        options.forEach {
            switch $0 {
            case .closeIcon(let icon):
                navItem.leftBarButtonItem?.image = icon
            case .rightNavItemTitle(let title, let onTap):
                navItem.rightBarButtonItem = UIBarButtonItem(
                    title: title,
                    style: .plain,
                    target: self,
                    action: #selector(diTapRightNavBarItem(_:)))
                onRightNavBarTapped = onTap
            case .rightNavItemIcon(let icon, let onTap):
                navItem.rightBarButtonItem = UIBarButtonItem(
                    image: icon,
                    style: .plain,
                    target: self,
                    action: #selector(diTapRightNavBarItem(_:)))
                onRightNavBarTapped = onTap
            }
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addBackgroundView()
        addNavBar()
        applyOptions()
        
        dataSource = self
        delegate = self

        if let imageDatasource = imageDatasource {
            let initialVC = ImageViewerController(
                index: initialIndex,
                imageURL: imageDatasource.imageURL(at: initialIndex),
                imagePlaceholder: imageDatasource.imagePlaceholder(at: initialIndex),
                imageLoader: imageLoader
            )
            setViewControllers([initialVC], direction: .forward, animated: true)
        }
    }

    @objc
    private func dismiss(_ sender:UIBarButtonItem) {
        dismissMe(completion: nil)
    }
    
    public func dismissMe(completion: (() -> Void)? = nil) {
        sourceView?.alpha = 1.0
        UIView.animate(withDuration: 0.235, animations: {
            self.view.alpha = 0.0
        }) { _ in
            self.dismiss(animated: false, completion: completion)
        }
    }
    
    deinit {
        sourceView?.alpha = 1.0
    }
    
    @objc
    func diTapRightNavBarItem(_ sender:UIBarButtonItem) {
        guard let onTap = onRightNavBarTapped,
              let _firstVC = viewControllers?.first as? ImageViewerController
        else { return }
        onTap(_firstVC.index)
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: UIPageViewControllerDataSource
extension ImageCarouselViewController: UIPageViewControllerDataSource {
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let vc = viewController as? ImageViewerController else { return nil }
        guard let imageDatasource = imageDatasource else { return nil }
        guard vc.index > 0 else { return nil }

        let newIndex = vc.index - 1

        return ImageViewerController(
            index: newIndex,
            imageURL: imageDatasource.imageURL(at: newIndex),
            imagePlaceholder: imageDatasource.imagePlaceholder(at: newIndex),
            imageLoader: vc.imageLoader
        )
    }
    
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {

        guard let vc = viewController as? ImageViewerController else { return nil }
        guard let imageDatasource = imageDatasource else { return nil }
        guard vc.index <= (imageDatasource.numberOfImages() - 2) else { return nil }

        let newIndex = vc.index + 1

        return ImageViewerController(
            index: newIndex,
            imageURL: imageDatasource.imageURL(at: newIndex),
            imagePlaceholder: imageDatasource.imagePlaceholder(at: newIndex),
            imageLoader: vc.imageLoader
        )
    }
}

// MARK: UIPageViewControllerDataSource
extension ImageCarouselViewController: UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let delegate = imageDelegate else { return }
        if completed {
            guard let presentedViewController = viewControllers?.first as? ImageViewerController else {
                return
            }
            sourceView?.alpha = 1.0
            displayedIndex = presentedViewController.index
            delegate.imageViewer(didSlideToIndex: displayedIndex)
        }
    }
}

