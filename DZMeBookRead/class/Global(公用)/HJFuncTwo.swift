//
//  HJFuncTwo.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/2.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import Foundation
import UIKit

// MARK: -- 自动获取屏幕高度 -----------------------

/// 自动获取view的高度 自动判断 是否有 导航栏跟TabBar
func ViewHeight(controller:UIViewController) ->CGFloat {
    
    var navigationHidden = true
    
    var tabBarHidden = true
    
    if controller.navigationController != nil { // 有导航栏
        
        navigationHidden = controller.navigationController!.navigationBarHidden
    }
    
    if controller.tabBarController != nil { // 有tabBar
        
        tabBarHidden = controller.tabBarController!.tabBar.hidden
    }
    
    return ViewHeight(navigationHidden, tabBarHidden: tabBarHidden)
}

/// 自动判断 是否有 导航栏 手动设置 是否有 TabBar
func ViewHeight(controller:UIViewController,tabBarHidden:Bool) ->CGFloat {
    
    var navigationHidden = true
    
    if controller.navigationController != nil { // 有导航栏
        
        navigationHidden = controller.navigationController!.navigationBarHidden
    }
    
    return ViewHeight(navigationHidden, tabBarHidden: tabBarHidden)
}

/// 自定义计算View高 手动设置 是否有 导航栏跟TabBar
func ViewHeight(navigationHidden:Bool,tabBarHidden:Bool) -> CGFloat {
    
    var h = ScreenHeight
    
    if !navigationHidden { // 有导航栏
        
        h -= NavgationBarHeight
    }
    
    if !tabBarHidden { // 有tabBar
        
        h -= TabBarHeight
    }
    
    return h
}



// MARK: -- 时间 -----------------------

// MARK: - "yyyy-MM-dd HH:mm:ss" 格式 字符串转成NSDate

func DateWithString(str:String) ->NSDate {
    
    let format = NSDateFormatter()
    
    format.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    let timeDate = format.dateFromString(str)
    
    return timeDate!
}

// MARK: - 获取 "yyyy-MM-dd HH:mm:ss" 格式 的时间字符串

func DateString() ->String {
    
    let format = NSDateFormatter()
    
    format.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    let timeDate = NSDate()
    
    return format.stringFromDate(timeDate)
}



// MARK: -- 手机号码处理 -----------------------

/// 判断输入的是否是手机格式  YES 为是手机号码 NO 不是
func CheckIsPhoneNumber(phoneNum:String) ->Bool {
    
    /// 手机号码
    let MOBILE:String = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
    
    /// 中国移动：China Mobile
    let CM:String = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
    
    /// 手机号码
    let CU:String = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
    
    /// 手机号码
    let CT:String = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
    
    /// 大陆地区固话及小灵通
    // let PHS:String = "^0(10|2[0-5789]|\\d{3})\\d{7,8}$"
    
    let regextestmobile:NSPredicate = NSPredicate(format: "SELF MATCHES %@", MOBILE)
    let regextestcm:NSPredicate = NSPredicate(format: "SELF MATCHES %@", CM)
    let regextestcu:NSPredicate = NSPredicate(format: "SELF MATCHES %@", CU)
    let regextestct:NSPredicate = NSPredicate(format: "SELF MATCHES %@", CT)
    let res1:Bool = regextestmobile.evaluateWithObject(phoneNum)
    let res2:Bool = regextestcm.evaluateWithObject(phoneNum)
    let res3:Bool = regextestcu.evaluateWithObject(phoneNum)
    let res4:Bool = regextestct.evaluateWithObject(phoneNum)
    
    if res1 || res2 || res3 || res4 {
        return true
    }else{
        return false
    }
}

/**
 隐藏手机号码中间的数 188*****449
 
 - parameter phoneNum: 手机号码 18812345449
 
 - returns: 处理好的手机号码 188*****449
 */
func phoneNumberEncryption(phoneNum:String) ->String {
    
    if CheckIsPhoneNumber(phoneNum) {
        
        let length:Int = 3 // 前后隐藏长度
        
        let strOneStart = phoneNum.startIndex.advancedBy(0)
        
        let strOneEnd = phoneNum.startIndex.advancedBy(length)
        
        let strOne:String = phoneNum.substringWithRange(Range(strOneStart ..< strOneEnd))
        
        
        let strTwoStart = phoneNum.endIndex.advancedBy(-length)
        
        let strTwoEnd = phoneNum.endIndex.advancedBy(0)
        
        let strTwo:String = phoneNum.substringWithRange(Range(strTwoStart ..< strTwoEnd))
        
        return strOne + "*****" + strTwo
    }
    
    return phoneNum
}

// MARK: -- 创建文件夹 -----------------------

/**
 创建文件夹 如果存在则不创建
 
 - parameter filePath: 文件路径
 
 return 是否有文件夹存在
 */
func CreatFilePath(filePath:String) ->Bool {
    
    let fileManager = NSFileManager.defaultManager()
    
    // 文件夹是否存在
    if fileManager.fileExistsAtPath(filePath) {
        
        return true
    }
    
    do{
        try fileManager.createDirectoryAtPath(filePath, withIntermediateDirectories: true, attributes: nil)
        
        return true
        
    }catch{}
    
    return false
}

// MARK: - 获取缓存大小
func getCacheSize() -> NSString {
    let basePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
    let fileManager = NSFileManager.defaultManager()
    
    func caculateCache() -> Float{
        var total: Float = 0
        if fileManager.fileExistsAtPath(basePath!){
            let childrenPath = fileManager.subpathsAtPath(basePath!)
            if childrenPath != nil{
                for path in childrenPath!{
                    let childPath = basePath!.stringByAppendingString("/").stringByAppendingString(path)
                    do{
                        let attr = try fileManager.attributesOfItemAtPath(childPath)
                        let fileSize = attr["NSFileSize"] as! Float
                        total += fileSize
                        
                    }catch _{
                        
                    }
                }
            }
        }
        return total
    }
    let totalCache = caculateCache()
    return NSString(format: "%.2f M", totalCache / 1024.0 / 1024.0 ) as String
}

// MARK: --清理缓存
func clearCache(){
    let basePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
    let fileManager = NSFileManager.defaultManager()
    if fileManager.fileExistsAtPath(basePath!){
        let childrenPath = fileManager.subpathsAtPath(basePath!)
        for childPath in childrenPath!{
            let cachePath = basePath?.stringByAppendingString("/").stringByAppendingString(childPath)
            do{
                try fileManager.removeItemAtPath(cachePath!)
            }catch _{
                
            }
        }
    }
}
// MARK: --获取当前版本号 version
func versionCheck() -> String{
    
    let infoDictionary = NSBundle.mainBundle().infoDictionary
    
    //        let appDisplayName: AnyObject? = infoDictionary!["CFBundleDisplayName"]
    
    let majorVersion : AnyObject? = infoDictionary! ["CFBundleShortVersionString"]
    
    //        let minorVersion : AnyObject? = infoDictionary! ["CFBundleVersion"]
    
    let appversion = majorVersion as! String
    
    //        let iosversion : NSString = UIDevice.currentDevice().systemVersion   //ios 版本
    
    //        let identifierNumber = UIDevice.currentDevice().identifierForVendor   //设备 udid
    
    //        let systemName = UI/Device.currentDevice().systemName   //设备名称
    
    //        let model = UIDevice.currentDevice().model   //设备型号
    
    //        let localizedModel = UIDevice.currentDevice().localizedModel   //设备区域化型号 如 A1533
    
    
    return appversion
}

// MARK: - 颜色渐变
func colorGradChange(witchView:AnyObject ,starPoint:CGPoint,endPoint:CGPoint,starColor:CGColor,endColor:CGColor) {
    let layer:CAGradientLayer = CAGradientLayer()
    layer.colors = [starColor,endColor]
    layer.startPoint = starPoint
    layer.endPoint = endPoint
    layer.frame = witchView.bounds
    witchView.layer.addSublayer(layer)
}

// MARK: -- view的手势禁用开启

/// 当前view的 Tap Enabled
func ViewTapGestureRecognizerEnabled(view:UIView,enabled:Bool) {
    
    for ges in view.gestureRecognizers! {
        
        if ges.isKindOfClass(UITapGestureRecognizer.classForCoder()) {
            
            ges.enabled = enabled
        }
    }
}

/// 当前view的 Pan Enabled
func ViewPanGestureRecognizerEnabled(view:UIView,enabled:Bool) {
    
    for ges in view.gestureRecognizers! {
        
        if ges.isKindOfClass(UIPanGestureRecognizer.classForCoder()) {
            
            ges.enabled = enabled
        }
    }
}

