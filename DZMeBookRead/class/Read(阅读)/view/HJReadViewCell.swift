//
//  HJReadViewCell.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/29.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import UIKit

class HJReadViewCell: UICollectionViewCell {
    
    var content:String! {
        
        didSet{
            
            let redFrame = HJReadParser.GetReadViewFrame()
            
            readView.frameRef = HJReadParser.parserRead(content, configure: HJReadConfigureManger.shareManager, bounds: CGRectMake(0, 0, redFrame.width, redFrame.height))
        }
    }
    
    var readView:HJReadView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        readView = HJReadView()
        readView.backgroundColor = UIColor.clearColor()
        contentView.addSubview(readView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        readView.frame = HJReadParser.GetReadViewFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
