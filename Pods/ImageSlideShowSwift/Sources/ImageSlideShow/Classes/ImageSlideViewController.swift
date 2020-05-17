//
//  ImageSlideViewController.swift
//
//  Created by Dimitri Giani on 02/11/15.
//  Copyright © 2015 Dimitri Giani. All rights reserved.
//

import UIKit

class ImageSlideViewController: UIViewController, UIScrollViewDelegate
{
    @IBOutlet weak var scrollView:UIScrollView?
    @IBOutlet weak var imageView:UIImageView?
    @IBOutlet weak var loadingIndicatorView:UIActivityIndicatorView?
    
    var slide:ImageSlideShowProtocol?
    var enableZoom = false
    
    var willBeginZoom:() -> Void = {}
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        NotificationCenter.default.addObserver(self, selector: #selector(change_color), name: NSNotification.Name(rawValue: "change_color"), object: nil)


        if enableZoom
        {
            scrollView?.maximumZoomScale = 2.0
            scrollView?.minimumZoomScale = 1.0
            scrollView?.zoomScale = 1.0
        }
        
        scrollView?.isHidden = true
        loadingIndicatorView?.startAnimating()
        
        slide?.image(completion: { (image, error) -> Void in

            DispatchQueue.main.async {
                
                self.imageView?.image = UIImage(named: image!)!
                self.loadingIndicatorView?.stopAnimating()
                self.scrollView?.isHidden = false

            }
            
        })
    }
    
   @objc func change_color(){
        self.imageView?.image = imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.imageView?.tintColor = .white
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        if enableZoom
        {
            //    Reset zoom scale when the controller is hidden
        
            scrollView?.zoomScale = 1.0
        }
    }
    
    //    MARK: UIScrollViewDelegate
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?)
    {
        willBeginZoom()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        if enableZoom
        {
            return imageView
        }
        
        return nil
    }
}
