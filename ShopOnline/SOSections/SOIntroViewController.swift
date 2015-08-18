//
//  SOIntroViewController.swift
//  ShopOnline
//
//  Created by CanhTran on 8/11/15.
//  Copyright (c) 2015 CanhTran. All rights reserved.
//

import UIKit

class SOIntroViewController: UIViewController , UIScrollViewDelegate {
    
    @IBOutlet weak var mScrollView: UIScrollView!
    @IBOutlet weak var mTextImageView: UIImageView!
    @IBOutlet weak var mLogoImageView: UIImageView!
    @IBOutlet weak var mGetStartButton: UIButton!
    @IBOutlet weak var mDescriptionLabel: UILabel!
    @IBOutlet weak var mPageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self .setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Setup content of view
    func setupView()
    {
        //Set up frame of scroll view equals super view
        self.mScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        let scrollViewWidth:CGFloat = self.mScrollView.frame.width
        let scrollViewHeight:CGFloat = self.mScrollView.frame.height
        
        //Setup text & button
        self.mDescriptionLabel.text = "Bạn muốn trở thành doanh nhân ?"
        self.mGetStartButton.layer.cornerRadius = 4.0;
        
        //Create background image for scroll view
        var imgOne = UIImageView(frame: CGRectMake(0, 0, scrollViewWidth, scrollViewHeight))
        imgOne.image = UIImage(named: "intro")
        var imgTwo = UIImageView(frame: CGRectMake(scrollViewWidth, 0, scrollViewWidth, scrollViewHeight))
        imgTwo.image = UIImage(named: "intro1")
        var imgThree = UIImageView(frame: CGRectMake(scrollViewWidth * 2, 0, scrollViewWidth, scrollViewHeight))
        imgThree.image = UIImage(named: "intro2")
        var imgFour = UIImageView(frame: CGRectMake(scrollViewWidth * 3, 0, scrollViewWidth, scrollViewHeight))
        imgFour.image = UIImage(named: "intro3")
        
        //Add image into scrollview
        self.mScrollView .addSubview(imgOne)
        self.mScrollView.addSubview(imgTwo)
        self.mScrollView.addSubview(imgThree)
        self.mScrollView.addSubview(imgFour)
        
        //Reset content size of scroll view
        self.mScrollView.contentSize = CGSizeMake(scrollViewWidth * 4, scrollViewHeight)
        self.mPageControl.currentPage = 0
        
        // Schedule a timer to auto slide to next page
        NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "moveToNextPage", userInfo: nil, repeats: true)
    }

    func moveToNextPage ()
    {
        // Move to next page
        var pageWidth:CGFloat = CGRectGetWidth(self.mScrollView.frame)
        let maxWidth:CGFloat = pageWidth * 4
        var contentOffset:CGFloat = self.mScrollView.contentOffset.x
        
        var slideToX = contentOffset + pageWidth
       
        if  contentOffset + pageWidth == maxWidth
        {
            slideToX = 0
        }
        self.mScrollView.scrollRectToVisible(CGRectMake(slideToX, 0, pageWidth, CGRectGetHeight(self.mScrollView.frame)), animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        var pageWidth:CGFloat = CGRectGetWidth(scrollView.frame)
        var currentPage:CGFloat = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        
        // Change the indicator
        self.mPageControl.currentPage = Int(currentPage)
        // Change the text accordingly
        if Int(currentPage) == 0
        {
            self.mDescriptionLabel.text = "Sweettutos.com is your blog of choice for Mobile tutorials"
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.mGetStartButton.alpha = 0.0
            })
        }
        else if Int(currentPage) == 1
        {
            self.mDescriptionLabel.text = "I write mobile tutorials mainly targeting iOS"
        }
        else if Int(currentPage) == 2
        {
            self.mDescriptionLabel.text = "And sometimes I write games tutorials about Unity"
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.mGetStartButton.alpha = 0.0
            })
        }
        else
        {
            self.mDescriptionLabel.text = "Mua may bán đắt với ShopOnline nào!"
            // Show the "Let's Start" button in the last slide (with a fade in animation)
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.mGetStartButton.alpha = 1.0
            })
        }

    }
    
    @IBAction func clickGetStartButton(sender: AnyObject)
    {
        
    }
 
}


