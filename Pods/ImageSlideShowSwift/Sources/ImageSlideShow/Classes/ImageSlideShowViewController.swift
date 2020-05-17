//
//  ImageSlideShowViewController.swift
//
//  Created by Dimitri Giani on 02/11/15.
//  Copyright © 2015 Dimitri Giani. All rights reserved.
//

import UIKit

public protocol ImageSlideShowProtocol
{
    var title: String? { get }
    
    func slideIdentifier() -> String
    func image(completion: @escaping (_ image:String?, _ error:Error?) -> Void)
}

class ImageSlideShowCache: NSCache<AnyObject, AnyObject>
{
    override init()
    {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector:#selector(NSMutableArray.removeAllObjects), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self);
    }
}

open class ImageSlideShowViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate
{
    
    static var imageSlideShowStoryboard:UIStoryboard = UIStoryboard(name: "ImageSlideShow", bundle: Bundle(for: ImageSlideShowViewController.self))
    open var slides: [ImageSlideShowProtocol]?
    open var initialIndex: Int = 0
    open var pageSpacing: CGFloat = 10.0
    open var panDismissTolerance: CGFloat = 30.0
    open var dismissOnPanGesture: Bool = false
    open var enableZoom: Bool = false
    open var statusBarStyle: UIStatusBarStyle = .lightContent
    open var navigationBarTintColor: UIColor = .white
    open var hideNavigationBarOnAction: Bool = true
    var v = UIView()
    var canScroll = true
    //    Current index and slide
    public var currentIndex: Int {
        return _currentIndex
    }
    public var currentSlide: ImageSlideShowProtocol? {
        return slides?[currentIndex]
    }
    
  //  public var slideShowViewDidLoad: (()->())?
    public var slideShowViewWillAppear: ((_ animated: Bool)-> ())?
    public var slideShowViewDidAppear: ((_ animated: Bool)-> ())?
    //tt
    public var ShowThepreviousPage:() -> Void = {}
       
    open var controllerDidDismiss:() -> Void = {}
    // i make this :)
    open var controllerDidupdate:() -> Void = {}
   // i make this :)
    open var controllerDetails:() -> Void = {}
   // i make this
    open var UpdateAllPages:() -> Void = {}
    // i make this
    open var UpdateTheEndNumber:() -> Void = {}
    
    open var stepAnimate:((_ offset:CGFloat, _ viewController:UIViewController) -> Void) = { _,_ in }
    open var restoreAnimation:((_ viewController:UIViewController) -> Void) = { _ in }
    open var dismissAnimation:((_ viewController:UIViewController, _ panDirection:CGPoint, _ completion: @escaping ()->()) -> Void) = { _,_,_ in }
    
    fileprivate var originPanViewCenter:CGPoint = .zero
    fileprivate var panViewCenter:CGPoint = .zero
    fileprivate var navigationBarHidden = false
    fileprivate var toggleBarButtonItem:UIBarButtonItem?
    fileprivate var _currentIndex: Int = 0
    fileprivate let slidesViewControllerCache = ImageSlideShowCache()
    
    override open var preferredStatusBarStyle:UIStatusBarStyle
    {
        return statusBarStyle
    }
    
    override open var prefersStatusBarHidden:Bool
    {
        return navigationBarHidden
    }
    
    override open var shouldAutorotate:Bool
    {
        return true
    }
    
    override open var supportedInterfaceOrientations:UIInterfaceOrientationMask
    {
        return .all
    }
    
    //    MARK: - Class methods
    
    class func imageSlideShowNavigationController() -> ImageSlideShowNavigationController
    {
        let controller = ImageSlideShowViewController.imageSlideShowStoryboard.instantiateViewController(withIdentifier: "ImageSlideShowNavigationController") as! ImageSlideShowNavigationController
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalPresentationCapturesStatusBarAppearance = true
        
        return controller
    }
    
    class func imageSlideShowViewController() -> ImageSlideShowViewController
    {
        let controller = ImageSlideShowViewController.imageSlideShowStoryboard.instantiateViewController(withIdentifier: "ImageSlideShowViewController") as! ImageSlideShowViewController
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalPresentationCapturesStatusBarAppearance = true
        
        return controller
    }
    
    class open func presentFrom(_ viewController:UIViewController, configure:((_ controller: ImageSlideShowViewController) -> ())?)
    {
        let navController = self.imageSlideShowNavigationController()
        if let issViewController = navController.visibleViewController as? ImageSlideShowViewController
        {
            configure?(issViewController)
            
            viewController.present(navController, animated: true, completion: nil)
        }
    }
    
    required public init?(coder: NSCoder)
    {
        super.init(coder: coder)
        
      //  prepareAnimations()
    }
    
    //    MARK: - Instance methods
    
    override open func viewDidLoad()
    {
        super.viewDidLoad()
        
        delegate = self
        dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(Go), name: NSNotification.Name(rawValue: "Go"), object: nil)

        hidesBottomBarWhenPushed = true
       
        
        navigationController?.navigationBar.tintColor = navigationBarTintColor
        navigationController?.view.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name:"Droid Arabic Kufi", size:16)!]
     

          let bbi = UIBarButtonItem(image: #imageLiteral(resourceName: "toggle"), style: .plain, target: self, action: #selector(check(sender:)))
          bbi.tintColor = .black
        //          let bbi_plus = UIBarButtonItem(image: #imageLiteral(resourceName: "crescent (1)"), style: .plain, target: self, action:          #selector(change(sender:)))
        //          bbi_plus.tintColor = .black
          self.navigationItem.leftBarButtonItem = bbi
        
        let bb = UIBarButtonItem(image:#imageLiteral(resourceName: "return-on-investment"), style: .plain, target: self, action: #selector(previousPage(sender:)))
          bb.tintColor = .black
          self.navigationItem.rightBarButtonItem = bb
                 
        //    Manage Gestures
        
        var gestures = gestureRecognizers
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(gesture:)))
        gestures.append(tapGesture)
        
      

        if (dismissOnPanGesture)
        {
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(gesture:)))
            gestures.append(panGesture)

            //    If dismiss on pan lock horizontal direction and disable vertical pan to avoid strange behaviours

          scrollView()?.isDirectionalLockEnabled = true
          scrollView()?.alwaysBounceVertical = false
        }
       
       
        
        view.gestureRecognizers = gestures
  
       
        

    }
    
    override open func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)

        setPage(withIndex: initialIndex)

        slideShowViewWillAppear?(animated)
    }

    override open func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)

        slideShowViewDidAppear?(animated)
    }
  
    //    MARK: Actions
       @objc func Go(notification: NSNotification) {
             if let info = notification.userInfo as NSDictionary? {
                 if let id = info["index"] as? Int{
                     UpdateTheEndNumber()
                     goToPage(withIndex: id - 1)
                    // UpdateAllPages()
                 }
             }
              
            }
//    @objc open func dismiss(sender:AnyObject?)
//    {
//        dismiss(animated: true, completion: nil)
//
//        controllerDidDismiss()
//    }
    // i make this :)
//       @objc open func change(sender:AnyObject?)
//       {
//         self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
//               NSAttributedString.Key.font: UIFont(name:"Droid Arabic Kufi", size:16)!]
//
//           navigationController?.navigationBar.barTintColor = .white
//           navigationController?.view.backgroundColor = .black
//           NotificationCenter.default.post(name: NSNotification.Name(rawValue: "change_color"), object: nil)
//
//       }
    // i make this :)
     @objc open func check(sender:AnyObject?)
     {
        controllerDetails()
     }
     @objc open func previousPage(sender:AnyObject?)
         {
            ShowThepreviousPage()
         }
    open func goToPage(withIndex index:Int)
    {
        // i make this
        guard canScroll == true else { return } //check condition
        canScroll = false
        if index != _currentIndex
        {
            setPage(withIndex: index)
        }
        canScroll = true
    }
    
    open func goToNextPage()
    {
        let index = _currentIndex + 1
        if index < (slides?.count)!
        {
            setPage(withIndex: index)
        }
    }
    
    open func goToPreviousPage()
    {
        
        let index = _currentIndex - 1
        if index >= 0
        {
            setPage(withIndex: index)
        }
    }
    
    func setPage(withIndex index:Int)
    {
        if    let viewController = slideViewController(forPageIndex: index)
        {
            setViewControllers([viewController], direction: (index > _currentIndex ? .forward : .reverse), animated: true, completion: nil)
            
            _currentIndex = index
            
            updateSlideBasedUI()
        }
    }
    
    func setNavigationBar(visible:Bool)
    {
        guard hideNavigationBarOnAction else { return }
        
        navigationBarHidden = !visible
        
        UIView.animate(withDuration: 0.23,
                                   delay: 0.0,
                                   options: .beginFromCurrentState,
                                   animations: { () -> Void in
                                    
                                    self.navigationController?.navigationBar.alpha = (visible ? 1.0 : 0.0)
                                    
            }, completion: nil)
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: UIPageViewControllerDataSource
    
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController])
    {
        self.setNavigationBar(visible: false)
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        if completed
        {
            _currentIndex = indexOfSlideForViewController(viewController: (pageViewController.viewControllers?.last)!)
            
            updateSlideBasedUI()
        }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        let index = indexOfSlideForViewController(viewController: viewController)
        
        if index > 0
        {
            return slideViewController(forPageIndex: index - 1)
        }
        else
        {
            return nil
        }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        let index = indexOfSlideForViewController(viewController: viewController)
        
        if let slides = slides, index < slides.count - 1
        {
            return slideViewController(forPageIndex: index + 1)
        }
        else
        {
            return nil
        }
    }
    
    // MARK: Accessories
    
    private func indexOfProtocolObject(inSlideViewController controller: ImageSlideViewController) -> Int?
    {
        var index = 0
        
        if    let object = controller.slide,
            let slides = slides
        {
            for slide in slides
            {
                if slide.slideIdentifier() == object.slideIdentifier()
                {
                    return index
                }
                
                index += 1
            }
        }
        
        return nil
    }
    
    private func indexOfSlideForViewController(viewController: UIViewController) -> Int
    {
        guard let viewController = viewController as? ImageSlideViewController else { fatalError("Unexpected view controller type in page view controller.") }
        guard let viewControllerIndex = indexOfProtocolObject(inSlideViewController: viewController) else { fatalError("View controller's data item not found.") }
        
        return viewControllerIndex
    }
    
    private func slideViewController(forPageIndex pageIndex: Int) -> ImageSlideViewController?
    {
        if let slides = slides, slides.count > 0
        {
            let slide = slides[pageIndex]
            
            if let cachedController = slidesViewControllerCache.object(forKey: slide.slideIdentifier() as AnyObject) as? ImageSlideViewController
            {
                return cachedController
            }
            else
            {
                guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "ImageSlideViewController") as? ImageSlideViewController else { fatalError("Unable to instantiate a ImageSlideViewController.") }
                controller.slide = slide
                controller.enableZoom = enableZoom
                controller.willBeginZoom = {
                    self.setNavigationBar(visible: false)
                }
                
                slidesViewControllerCache.setObject(controller, forKey: slide.slideIdentifier() as AnyObject)
                
                return controller
            }
        }
        
        return nil
    }
    
    private func prepareAnimations()
    {
        stepAnimate = { step, viewController in

            if let viewController = viewController as? ImageSlideViewController
            {
                if step == 0
                {
                    viewController.imageView?.layer.shadowRadius = 10
                    viewController.imageView?.layer.shadowOpacity = 0.3
                }
                else
                {
                    let alpha = CGFloat(1.0 - step)

                    self.navigationController?.navigationBar.alpha = 0.0
                    self.navigationController?.view.backgroundColor = UIColor.black.withAlphaComponent(max(0.2, alpha * 0.9))

                    let scale = max(0.8, alpha)

                    viewController.imageView?.center = self.panViewCenter
                    viewController.imageView?.transform = CGAffineTransform(scaleX: scale, y: scale)
                }
            }
        }
        restoreAnimation = { viewController in

            if let viewController = viewController as? ImageSlideViewController
            {
                UIView.animate(withDuration: 0.2,
                                           delay: 0.0,
                                           options: .beginFromCurrentState,
                                           animations: { () -> Void in

                                            self.presentingViewController?.view.transform = CGAffineTransform.identity

                                            viewController.imageView?.center = self.originPanViewCenter
                                            viewController.imageView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                                            viewController.imageView?.layer.shadowRadius = 0
                                            viewController.imageView?.layer.shadowOpacity = 0

                    }, completion: nil)
            }
        }
        dismissAnimation = {  viewController, panDirection, completion in

            if let viewController = viewController as? ImageSlideViewController
            {
                let velocity = panDirection.y

                UIView.animate(withDuration: 0.3,
                                           delay: 0.0,
                                           options: .beginFromCurrentState,
                                           animations: { () -> Void in

                                            self.presentingViewController?.view.transform = CGAffineTransform.identity

                                            if var frame = viewController.imageView?.frame
                                            {
                                                frame.origin.y = (velocity > 0 ? self.view.frame.size.height : -frame.size.height)
                                                viewController.imageView?.frame = frame
                                            }

                                            viewController.imageView?.alpha = 0.0

                    }, completion: { (completed:Bool) -> Void in

                        completion()

                })
            }
        }
    }
    private func updateSlideBasedUI()
        
    {
        controllerDidupdate()
    
        if let title = currentSlide?.title
        {
            navigationItem.title = title
//            let fullNameArr = title.components(separatedBy: " ")
//            print("\(fullNameArr[1])")
//            
//            navigationItem.title = "الجزء \(getThePartNumber(pageNumber: Int(fullNameArr[1])!))"
        }
    }
    func getThePartNumber(pageNumber :Int) -> Int{
        
        if pageNumber < 22{
             return 1
        }else if pageNumber < 42{
             return 2
        }else if pageNumber < 62{
             return 3
        }else if pageNumber < 82{
             return 4
        }else if pageNumber < 102{
             return 5
        }else if pageNumber < 122{
             return 6
        }else if pageNumber < 142{
             return 7
        }else if pageNumber < 162{
             return 8
        }else if pageNumber < 182{
             return 9
        }else if pageNumber < 202{
             return 10
        }else if pageNumber < 222{
             return 11
        }else if pageNumber < 242{
             return 12
        }else if pageNumber < 262{
             return 13
        }else if pageNumber < 282{
             return 14
        }else if pageNumber < 302{
             return 15
        }else if pageNumber < 322{
             return 16
        }else if pageNumber < 342{
             return 17
        }else if pageNumber < 362{
             return 18
        }else if pageNumber < 382{
             return 19
        }else if pageNumber < 402{
             return 20
        }else if pageNumber < 422{
             return 21
        }else if pageNumber < 442{
             return 22
        }else if pageNumber < 462{
             return 23
        }else if pageNumber < 482{
             return 24
        }else if pageNumber < 502{
             return 25
        }else if pageNumber < 522{
             return 26
        }else if pageNumber < 542{
             return 27
        }else if pageNumber < 562{
             return 28
        }else if pageNumber < 582{
             return 29
        }else {
             return 30
        }
        
    }
    
    // MARK: Gestures
    
    @objc private func tapGesture(gesture:UITapGestureRecognizer)
    {
        setNavigationBar(visible: navigationBarHidden == true);
    }
    
    @objc private func panGesture(gesture:UIPanGestureRecognizer)
    {
        let viewController = slideViewController(forPageIndex: currentIndex)

        switch gesture.state
        {
        case .began:
            presentingViewController?.view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)

            originPanViewCenter = view.center
            panViewCenter = view.center

            stepAnimate(0, viewController!)

        case .changed:

            let translation = gesture.translation(in: view)
            panViewCenter = CGPoint(x: panViewCenter.x + translation.x, y: panViewCenter.y + translation.y)

            gesture.setTranslation(.zero, in: view)

            let distanceX = abs(originPanViewCenter.x - panViewCenter.x)
            let distanceY = abs(originPanViewCenter.y - panViewCenter.y)
            let distance = max(distanceX, distanceY)
            let center = max(originPanViewCenter.x, originPanViewCenter.y)

            let distanceNormalized = max(0, min((distance / center), 1.0))

            stepAnimate(distanceNormalized, viewController!)

        case .ended, .cancelled, .failed:
//            let distanceY = abs(originPanViewCenter.y - panViewCenter.y)
//
//            if (distanceY >= panDismissTolerance)
//            {
//                UIView.animate(withDuration: 0.3,
//                                           delay: 0.0,
//                                           options: .beginFromCurrentState,
//                                           animations: { () -> Void in
//
//                                            self.navigationController?.view.alpha = 0.0
//                    }, completion:nil)
//
//                dismissAnimation(viewController!, gesture.velocity(in: gesture.view), {
//
//                  //  self.dismiss(sender: nil)
//
//                })
//            }
//            else
//            {
//                UIView.animate(withDuration: 0.2,
//                                           delay: 0.0,
//                                           options: .beginFromCurrentState,
//                                           animations: { () -> Void in
//
//                                            self.navigationBarHidden = true
//                                            self.navigationController?.navigationBar.alpha = 0.0
//                                            self.navigationController?.view.backgroundColor = .black
//
//                    }, completion: nil)
//
//               // restoreAnimation(viewController!)
//          }
            break;
        default:
            break;
        }
    }
}

