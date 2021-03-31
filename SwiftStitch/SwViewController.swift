//
//  SwViewController.swift
//  CVOpenStitch
//
//  Created by Foundry on 04/06/2014.
//  Copyright (c) 2014 Foundry. All rights reserved.
//

import UIKit
import AVKit
import CoreGraphics

class SwViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var spinner:UIActivityIndicatorView!
    @IBOutlet var imageView:UIImageView?
    @IBOutlet var scrollView:UIScrollView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        stitch()
    }
    
    func stitch() {
        self.spinner.startAnimating()
        DispatchQueue.global().async {
            
            /// Gets all of the frames of the image
            let splitter = VideoSplitter(urlVideo: URL(fileURLWithPath: Bundle.main.path(forResource: "TestVideo_1", ofType: "mp4")!))
            splitter.getAllFrames()
            
            let imageArray: [UIImage?] = [UIImage(named: "test0"), UIImage(named: "frame3")]
            
//            var imageArray: [UIImage?] = []
            
            
            // This part works and just appends every frame that were captured using a KNN algorithm to imageArray
//            Array(0...12).forEach { i in
//                imageArray.append(UIImage(named: "frame\(i)"))
//            }
            
//            splitter.imageFromVideo(at: TimeInterval(1), completion: { img in
//                imageArray.append(img)
//            })
//            splitter.imageFromVideo(at: TimeInterval(3), completion: { image in
//                imageArray.append(image)
//            })
//            imageArray.append(UIImage(named: "frame0"))
//            imageArray.append(UIImage(named: "frame1"))
            
            
            let stitchedImage: UIImage = CVWrapper.process(with: imageArray as! [UIImage]) as UIImage
            
            DispatchQueue.main.async {
                NSLog("stichedImage %@", stitchedImage)
                let imageView:UIImageView = UIImageView.init(image: stitchedImage)
                self.imageView = imageView
                self.scrollView.addSubview(self.imageView!)
                self.scrollView.backgroundColor = UIColor.black
                self.scrollView.contentSize = self.imageView!.bounds.size
                self.scrollView.maximumZoomScale = 4.0
                self.scrollView.minimumZoomScale = 0.001
                self.scrollView.delegate = self
                self.scrollView.contentOffset = CGPoint(x: -(self.scrollView.bounds.size.width - self.imageView!.bounds.size.width)/2.0, y: -(self.scrollView.bounds.size.height - self.imageView!.bounds.size.height)/2.0)
                NSLog("scrollview \(self.scrollView.contentSize)")
                self.spinner.stopAnimating()
            }
        }
    }
    
    
    func viewForZooming(in scrollView:UIScrollView) -> UIView? {
        return self.imageView!
    }
    
}
