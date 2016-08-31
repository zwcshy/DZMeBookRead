//
//  HJCollectionViewController.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/1.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import UIKit

class HJCollectionViewController: HJViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var collectionView:HJCollectionView!                              // collectionView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        // 创建CollectionView
        initCollectionView(UICollectionViewFlowLayout())
        
    }
    
    // 初始化CollectionView
    func initCollectionView(layout:UICollectionViewFlowLayout) {
        
        collectionView = HJCollectionView(frame: CGRectMake(0, NavgationBarHeight, ScreenWidth, ViewHeight(false, tabBarHidden: true)), collectionViewLayout:layout)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        view.addSubview(collectionView)
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("", forIndexPath: indexPath)
        
        // Configure the cell
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        collectionView.scrollViewWillDisplayCell(cell)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
