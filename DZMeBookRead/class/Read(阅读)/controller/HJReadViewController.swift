//
//  HJReadViewController.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/25.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import UIKit

private let HJReadCellID:String = "HJReadCellID"

class HJReadViewController: HJCollectionViewController,UICollectionViewDelegateFlowLayout {
    
    weak var readPageController:HJReadPageController!
    
    /// 当前阅读形式
    private var flipEffect:HJReadFlipEffect!
    
    /// 当前使用的layout
    private var layout:UICollectionViewFlowLayout!
    
    /// 单独模式的时候显示的内容
    var content:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置背景颜色
        changeBGColor()
        
        // 设置翻页方式
        changeFlipEffect()
        
        // 通知在deinit 中会释放
        // 添加背景颜色改变通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HJReadViewController.changeBGColor), name: HJReadChangeBGColorKey, object: nil)
    }
    
    override func initCollectionView(layout: UICollectionViewFlowLayout) {
        
        layout.minimumLineSpacing = 0
        
        layout.minimumInteritemSpacing = 0
        
        self.layout = layout
        
        super.initCollectionView(layout)
        
        collectionView.registerClass(HJReadViewCell.classForCoder(), forCellWithReuseIdentifier: HJReadCellID)
        
        collectionView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight)
        
        collectionView.backgroundColor = UIColor.clearColor()
    }

    // MARK: -- UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        if flipEffect == HJReadFlipEffect.None { // 无效果
            
            return 1
            
        }else if flipEffect == HJReadFlipEffect.Translation { // 平滑
            
        }else if flipEffect == HJReadFlipEffect.Simulation { // 仿真
            
            return 1
            
        }else if flipEffect == HJReadFlipEffect.UpAndDown { // 上下滚动
            
        }else{}
        
        return readPageController.readModel.readChapterModels.count
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if flipEffect == HJReadFlipEffect.None { // 无效果
            
            return 1
            
        }else if flipEffect == HJReadFlipEffect.Translation { // 平滑
            
        }else if flipEffect == HJReadFlipEffect.Simulation { // 仿真
            
            return 1
            
        }else if flipEffect == HJReadFlipEffect.UpAndDown { // 上下滚动
            
        }else{}
        
        let readChapterModel = readPageController.readModel.readChapterModels[section]
        
        return readChapterModel.pageCount.integerValue
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(HJReadCellID, forIndexPath: indexPath) as! HJReadViewCell
        
        if flipEffect == HJReadFlipEffect.None { // 无效果
            
            cell.content = content
            
        }else if flipEffect == HJReadFlipEffect.Translation { // 平滑
            
            let readChapterModel = readPageController.readModel.readChapterModels[indexPath.section]
            
            cell.content = readChapterModel.stringOfPage(indexPath.row)
            
            readPageController.readModel.readRecord.page = indexPath.row
            
            readPageController.readModel.readRecord.readChapterModel = readChapterModel
            
            readPageController.title = readChapterModel.chapterName
            
            // 刷新阅读记录
            readPageController.readConfigure.updateReadRecord()
            
        }else if flipEffect == HJReadFlipEffect.Simulation { // 仿真
            
            cell.content = content
            
        }else if flipEffect == HJReadFlipEffect.UpAndDown { // 上下滚动
            
            let readChapterModel = readPageController.readModel.readChapterModels[indexPath.section]
            
            cell.content = readChapterModel.stringOfPage(indexPath.row)
            
            readPageController.readModel.readRecord.page = indexPath.row
            
            readPageController.readModel.readRecord.readChapterModel = readChapterModel
            
            readPageController.title = readChapterModel.chapterName
            
            // 刷新阅读记录
            readPageController.readConfigure.updateReadRecord()
            
        }else{}
        
        
        return cell
    }
    
    // MARK: -- UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // MARK: -- UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if flipEffect == HJReadFlipEffect.None { // 无效果
            
        }else if flipEffect == HJReadFlipEffect.Translation { // 平滑
            
        }else if flipEffect == HJReadFlipEffect.Simulation { // 仿真
            
        }else if flipEffect == HJReadFlipEffect.UpAndDown { // 上下滚动
            
        }else{}
        
        return CGSizeMake(ScreenWidth, ScreenHeight)
    }
    
    // MARK: -- 通知
    
    /// 修改背景颜色
    func changeBGColor() {
        
        view.backgroundColor = HJReadConfigureManger.shareManager.readColor
    }
    
    /// 修改阅读方式
    func changeFlipEffect() {
        
        flipEffect = HJReadConfigureManger.shareManager.flipEffect
        
        if flipEffect == HJReadFlipEffect.None { // 无效果
            
            collectionView.scrollEnabled = false
            
        }else if flipEffect == HJReadFlipEffect.Translation { // 平滑
            
            collectionView.scrollEnabled = true
            
            collectionView.pagingEnabled = true
           
            collectionView.alwaysBounceHorizontal = true
            
            collectionView.alwaysBounceVertical = false
            
            layout.scrollDirection = .Horizontal
            
            collectionView.setCollectionViewLayout(layout, animated: false)
            
            collectionView.reloadData()
            
            collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: readPageController.readModel.readRecord.page.integerValue,inSection: Int(readPageController.readSetup.readUI.bottomView.slider.value)), atScrollPosition: UICollectionViewScrollPosition.None, animated: false)
            
        }else if flipEffect == HJReadFlipEffect.Simulation { // 仿真
            
            collectionView.scrollEnabled = false
            
        }else if flipEffect == HJReadFlipEffect.UpAndDown { // 上下滚动
            
            collectionView.scrollEnabled = true
            
            collectionView.pagingEnabled = false
            
            collectionView.alwaysBounceHorizontal = false
            
            collectionView.alwaysBounceVertical = true
            
            layout.scrollDirection = .Vertical
            
            collectionView.setCollectionViewLayout(layout, animated: false)
            
            collectionView.reloadData()
            
            collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: readPageController.readModel.readRecord.page.integerValue,inSection: Int(readPageController.readSetup.readUI.bottomView.slider.value)), atScrollPosition: UICollectionViewScrollPosition.None, animated: false)
            
        }else{}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit{
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}
