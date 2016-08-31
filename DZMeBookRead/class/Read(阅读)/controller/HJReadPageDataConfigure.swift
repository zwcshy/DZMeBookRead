//
//  HJReadPageDataConfigure.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/31.
//  Copyright © 2016年 HanJue. All rights reserved.
//

/*
    
    主要存放阅读页面的数据方法
 
 */

import UIKit

class HJReadPageDataConfigure: NSObject {

    /// 阅读控制器
    private weak var readPageController:HJReadPageController!
    
    /// 临时记录值
    var changeReadChapterModel:HJReadChapterModel!
    var changeLookPage:Int = 0
    var changeChapterID:Int = 0
    
    /// 阅读控制器配置
    class func setupWithReadController(readPageController:HJReadPageController) ->HJReadPageDataConfigure {
        
        let readPageDataConfigure = HJReadPageDataConfigure()
        
        readPageDataConfigure.readPageController = readPageController
        
        return readPageDataConfigure
    }
    
    // MARK: -- 阅读控制器
    
    /**
     获取阅读控制器
     
     - parameter readChapterModel: 当前阅读的章节模型
     - parameter page:             当前章节阅读到page
     */
    func GetReadViewController(readChapterModel:HJReadChapterModel,currentPage:Int) ->HJReadViewController {
        
        let readVC = HJReadViewController()
        
        readVC.readPageController = readPageController
        
        readVC.content = readChapterModel.stringOfPage(currentPage)
        
        return readVC
    }
    
    // MARK: -- 阅读指定章节
    
    /**
     跳转指定章节
     
     - parameter chapterID:            章节ID
     - parameter isInit:               是否为初始化true 还是跳转章节false
     - parameter chapterLookPageClear: 阅读到的章节页码是否清0
     */
    func GoToReadChapter(chapterID:String,isInit:Bool,chapterLookPageClear:Bool) ->Bool {
        
        if !readPageController.readModel.readChapterModels.isEmpty {
            
            let chapterModel = GetReadChapterModel(chapterID)
            
            if chapterModel != nil { // 有这个章节
                
                changeReadChapterModel = chapterModel
                
                readPageController.readModel.readRecord.readChapterModel = chapterModel
                
                if chapterLookPageClear {
                    
                    readPageController.readModel.readRecord.page = 0
                    
                    changeLookPage = 0
                }
                
                // 跳转
                if isInit {
                    
                    readPageController.creatPageController(GetReadViewController(chapterModel!, currentPage: readPageController.readModel.readRecord.page.integerValue),transitionStyle: UIPageViewControllerTransitionStyle.PageCurl, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal)
                }else{
                    
                    readPageController.pageViewController.setViewControllers([GetReadViewController(chapterModel!, currentPage: readPageController.readModel.readRecord.page.integerValue)], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
                }
                
                return  true
            }
        }
        
        return false
    }
    
    // MARK: -- 通过章节ID 获取 数组索引
    
    // 通过章节ID获取章节模型 需要滚动到的
    func GetReadChapterModel(chapterID:String) ->HJReadChapterModel? {
        
        let pre = NSPredicate(format: "chapterID == %@",chapterID)
        
        let results = (readPageController.readModel.readChapterModels as NSArray).filteredArrayUsingPredicate(pre)
        
        if !results.isEmpty { // 获取当前数组位置
            
            let readChapterModel = results.first as! HJReadChapterModel
            
            readPageController.readModel.readRecord.readChapterModel = readChapterModel
            
            readPageController.title = readChapterModel.chapterName
            
            // 章节list 进行滚动
            let index = readPageController.readModel.readChapterModels.indexOf(readChapterModel)
            
            readPageController.readModel.readRecord.chapterIndex = index!
            
            readPageController.readSetup.readUI.leftView.scrollRow = index!
            
            readPageController.readSetup.readUI.bottomView.slider.value = Float(index!)
        }
        
        return results.first as? HJReadChapterModel
    }
    
    // MARK: -- 上一页
    
    func GetReadPreviousPage() ->HJReadViewController? {
        
        changeChapterID = readPageController.readModel.readRecord.readChapterModel.chapterID.integerValue()
        
        changeLookPage = readPageController.readModel.readRecord.page.integerValue
        
        if readPageController.readModel.isLocalBook.boolValue { // 本地小说
            
            if changeChapterID == 1 && changeLookPage == 0 {
                
                return nil
            }
            
            if changeLookPage == 0 { // 这一章到头部了
                
                changeChapterID -= 1
                
                let chapterModel = GetReadChapterModel("\(changeChapterID)")
                
                if chapterModel != nil { // 有上一张
                    
                    changeReadChapterModel = chapterModel
                    
                    changeLookPage = changeReadChapterModel.pageCount.integerValue - 1
                    
                }else{ // 没有上一章
                    
                    return nil
                }
                
                
            }else{
                
                changeLookPage -= 1
            }
            
        }else{ // 网络小说阅读
            
            
        }
        
        return GetReadViewController(changeReadChapterModel, currentPage: changeLookPage)
    }
    
    // MARK: -- 下一页
    
    func GetReadNextPage() ->HJReadViewController? {
        
        changeChapterID = readPageController.readModel.readRecord.readChapterModel.chapterID.integerValue()
        
        changeLookPage = readPageController.readModel.readRecord.page.integerValue
        
        if readPageController.readModel.isLocalBook.boolValue { // 本地小说
            
            if changeChapterID == readPageController.readModel.readChapterModels.count && changeLookPage == (changeReadChapterModel.pageCount.integerValue - 1) {
                
                return nil
            }
            
            if changeLookPage == (changeReadChapterModel.pageCount.integerValue - 1) { // 这一章到尾部了
                
                changeChapterID += 1
                
                let chapterModel = GetReadChapterModel("\(changeChapterID)")
                
                if chapterModel != nil { // 有下一章
                    
                    changeReadChapterModel = chapterModel
                    
                    changeLookPage = 0
                    
                }else{ // 没有下一章
                    
                    return nil
                }
                
            }else{
                
                changeLookPage += 1
            }
            
        }else{ // 网络小说阅读
            
            
        }
        
        return GetReadViewController(changeReadChapterModel, currentPage: changeLookPage)
    }
    
    
    // MARK: -- 阅读记录
    
    /// 同步临时数据并更新保存记录
    func synchronizationChangeDataUpdateReadRecord() {
        
        readPageController.readModel.readRecord.readChapterModel =  changeReadChapterModel
        readPageController.readModel.readRecord.page = changeLookPage
        updateReadRecord()
    }
    
    /// 刷新阅读记录
    func updateReadRecord() {
        
        HJReadModel.updateReadModel(readPageController.readModel, fileName: readPageController.readModel.bookID)
    }
}
