//
//  SOCloestProductViewController.swift
//  ShopOnline
//
//  Created by Canh on 9/3/15.
//  Copyright (c) 2015 CanhTran. All rights reserved.
//

import UIKit
import Parse
import SCLAlertView

class SOCloestProductViewController: UIViewController {

    @IBOutlet weak var mListProductCollectionView: UICollectionView!
    @IBOutlet weak var mResultLoadingView: UIView!
    @IBOutlet weak var mResultLoadingLabel: UILabel!
    
    var refreshControl:UIRefreshControl!
    
    var mListNewProduct :[Product] = []
    
    let mSectionInsets = UIEdgeInsets(top: 3.0, left: 3.0, bottom: 3.0, right: 3.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(animated: Bool)
    {
        self.setupView()
        self.mListProductCollectionView.registerNib(UINib(nibName: "ProductCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionCell")
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.mListProductCollectionView.addSubview(refreshControl)
        self.mListProductCollectionView.alwaysBounceVertical = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh(sender:AnyObject)
    {
        if SONetworking.sharedInstance.isHaveConnection()
        {
            self.mListNewProduct.removeAll(keepCapacity: true)
            self.getDataNewProduct()
        }
        else
        {
            SCLAlertView().showNotice("Lỗi!", subTitle: "Không có kết nối mạng, vui lòng kết nối với Wifi/3G.")
        }
    }
    
    // MARK: - Setup view
    
    func setupView()
    {
        if !SONetworking.sharedInstance.isHaveConnection()
        {
            self.mResultLoadingView.hidden = false
            self.mResultLoadingLabel.text = ResultLoadDataError
        }
        else
        {
            self.getDataNewProduct()
        }
    }
    
    // MARK: - Load Data from server Parse
    
    /**
    Load data form server by querry
    */
    func getDataNewProduct()
    {
        // Loading view
        self.view.showLoading()
        // Get user location
        let userLocation : CLLocationManager! = SOUtils.sharedInstance.getLocationAppDelegate() as! CLLocationManager
        var objectLocation = PFGeoPoint()
        
        // If user is turn on location
        if userLocation.location != nil
        {
            objectLocation = PFGeoPoint(latitude:userLocation.location.coordinate.latitude, longitude:userLocation.location.coordinate.longitude)
        }
        else
        {
            objectLocation = PFGeoPoint(latitude:10.87018, longitude:106.8023)
        }
        
        //Create querry Product
        let querry = Product.query()
        //Include key with pointer nameCategories
        querry!.includeKey("nameCategories")
        querry?.whereKey("nameCategories", equalTo: SOListProductViewController.mCategories)
        querry?.whereKey("location", nearGeoPoint: objectLocation)
        querry?.limit = 100
        querry!.findObjectsInBackgroundWithBlock({(objects , error) -> Void in
            if let listProducts = objects as? [Product]
            {
                for object : Product in listProducts
                {
                    self.mListNewProduct.append(object)
                }
                
                // Reloaddata collection view
                if self.mListNewProduct.count < 1
                {
                    self.mResultLoadingView.hidden = false
                    self.mResultLoadingLabel.text = ResultLoadDataEmpty
                }
                self.mListProductCollectionView.reloadData()
            }
            else
            {
                println("Error:\(error?.description)")
                self.mResultLoadingView.hidden = false
            }
            self.view.hideLoading()
            self.refreshControl.endRefreshing()
        })
    }
    
    //MARK: - UICollection View
    
    /* Num of sections collection view */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    /* Num of each item in section */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if self.mListNewProduct.count > 0
        {
            return self.mListNewProduct.count
        }
        return 0
    }
    
    /* Cell for item at index */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.mListProductCollectionView.dequeueReusableCellWithReuseIdentifier(ProductCell, forIndexPath: indexPath) as! ProductCollectionCell
        // Fill data to cell with value
        if self.mListNewProduct.count > 0
        {
            cell.fillCellWithData(self.mListNewProduct[indexPath.row])
        }
        return cell
    }
    
    /* Set size for collection cell */
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenWidth = getWidthScreen()
        let twoPiecesWidth = floor(screenWidth / 2.0 - 4.0)
        return CGSizeMake(twoPiecesWidth, 215 * SOUtils.sharedInstance.getRatioHeight())
    }
    
    /* Set layout for collection cell */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return mSectionInsets
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let productDetail = setupPushView(SOProductDetailViewController) as! SOProductDetailViewController
        self.navigationController?.pushViewController(productDetail, animated: true)
    }

    @IBAction func clickReloadPageTapGesture(sender: AnyObject)
    {
        if SONetworking.sharedInstance.isHaveConnection()
        {
            self.getDataNewProduct()
        }
        else
        {
            SCLAlertView().showNotice("Lỗi!", subTitle: "Không có kết nối mạng, vui lòng kết nối với Wifi/3G.")
        }
    }

}
