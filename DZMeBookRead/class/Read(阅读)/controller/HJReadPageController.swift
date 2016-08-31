//
//  HJReadPageController.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/15.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import UIKit

class HJReadPageController: HJViewController,UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    
    // 阅读主对象
    var readModel:HJReadModel!
    
    /// 翻页控制器
    var pageViewController:UIPageViewController!
    
    /// 阅读设置
    var readSetup:HJReadSetup!
    var readConfigure:HJReadPageDataConfigure!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        readConfigure = HJReadPageDataConfigure.setupWithReadController(self)
        readSetup = HJReadSetup.setupWithReadController(self)
        
        // 刷新章节列表
        readSetup.readUI.leftView.dataArray = readModel.readChapterModels
        readSetup.readUI.bottomView.slider.maximumValue = Float(readModel.readChapterModels.count - 1)
        
        // 跳转章节
        readConfigure.GoToReadChapter(readModel.readRecord.readChapterModel.chapterID,isInit: true,chapterLookPageClear: false)
        
        // 初始化翻页效果
        readSetup.setFlipEffect(HJReadConfigureManger.shareManager.flipEffect)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
        
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
    }
    
    // MARK: -- PageController
    
    func creatPageController(displayController:UIViewController,transitionStyle: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation) {
        
        let options = [UIPageViewControllerOptionSpineLocationKey:NSNumber(float: 10)]
        
        pageViewController = UIPageViewController(transitionStyle:transitionStyle,navigationOrientation:navigationOrientation,options: options)
        
        pageViewController.delegate = self
        
        pageViewController.dataSource = self
        
        view.insertSubview(pageViewController.view, atIndex: 0)
        
        self.addChildViewController(pageViewController)
        
        pageViewController.setViewControllers([displayController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
    }
    
    // MARK: -- UIPageViewControllerDelegate
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if !completed {
            
        }else{
            
            // 刷新阅读记录
            readConfigure.synchronizationChangeDataUpdateReadRecord()
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        
    }
    
    
    // MARK: -- UIPageViewControllerDataSource
    
    /// 获取上一页
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        return readConfigure.GetReadPreviousPage()
    }
    
    /// 获取下一页
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        return readConfigure.GetReadNextPage()
    }
    
    deinit {
        
        print("HJReadPageController释放了")
    }
}
