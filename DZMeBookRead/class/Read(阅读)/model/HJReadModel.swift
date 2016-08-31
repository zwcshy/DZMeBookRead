//
//  HJReadModel.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/29.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import UIKit

class HJReadModel: NSObject,NSCoding {

    /// 当前的小说ID
    var bookID:String!
    
    /// 章节数组
    var readChapterModels:[HJReadChapterModel]!
    
    /// 阅读记录
    var readRecord:HJReadRecord!
    
    /// 是否为本地小说
    var isLocalBook:NSNumber! = 0
    
    /// 本地小说使用 解析获得的整本字符串
//    var content:String! = ""
    
    /// 本地小说使用 来源地址 路径
    var resource:NSURL?
    
    // MARK: -- 构造方法
    
    /// 初始化大字符串文本
    convenience init(content:String) {
        self.init()
        
//        self.content = content
        
        readChapterModels = HJReadParser.separateContent(content)
        
        if !readChapterModels.isEmpty {
            
            readRecord.readChapterModel = readChapterModels.first
            
            readRecord.chapterIndex = 0
            
            readRecord.chapterCount = readChapterModels.count
        }
    }
    
    override init() {
        super.init()
        
        readChapterModels = [HJReadChapterModel]()
        
        readRecord = HJReadRecord()
    }
    
    /// 初始化本地URL小说地址
    class func readModelWithLocalBook(url:NSURL) ->HJReadModel {
        
        let fileName = url.path!.lastPathComponent()
        
        var model = KeyedUnarchiver(fileName) as? HJReadModel
        
        // 没有缓存
        if model == nil {
            
            if fileName.pathExtension() == "txt" {  // text 格式
                
                model = HJReadModel(content:HJReadParser.encodeURL(url))
                model!.resource = url
                model!.isLocalBook = 1
                model!.bookID = fileName
                HJReadModel.updateReadModel(model!, fileName: fileName)
                
                return model!
                
            }else{
                
                print("格式错误!")
            }
        }
        
        return model!
    }
    
    /// 传入Key 获取对应阅读模型
    class func readModelWithFileName(fileName:String) ->HJReadModel? {
        
        return KeyedUnarchiver(fileName) as? HJReadModel
    }
    
    // MARK: -- 刷新缓存数据
    
    class func updateReadModel(readModel:HJReadModel,fileName:String) {
        
        KeyedArchiver(fileName, object: readModel)
    }
    
    // MARK: -- aDecoder
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        
        bookID = aDecoder.decodeObjectForKey("bookID") as! String
        
        readChapterModels = aDecoder.decodeObjectForKey("readChapterModels") as! [HJReadChapterModel]
        
        readRecord = aDecoder.decodeObjectForKey("readRecord") as! HJReadRecord
        
        isLocalBook = aDecoder.decodeObjectForKey("isLocalBook") as! NSNumber
        
        resource = aDecoder.decodeObjectForKey("resource") as? NSURL
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(bookID, forKey: "bookID")
        
        aCoder.encodeObject(readChapterModels, forKey: "readChapterModels")
        
        aCoder.encodeObject(readRecord, forKey: "readRecord")
        
        aCoder.encodeObject(isLocalBook, forKey: "isLocalBook")
        
        aCoder.encodeObject(resource, forKey: "resource")
    }
}
