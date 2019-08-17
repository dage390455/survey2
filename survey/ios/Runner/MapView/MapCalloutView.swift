//
//  MapCalloutView.swift
//  SensoroCity
//
//  Created by David Yang on 2017/12/7.
//  Copyright © 2017年 Sensoro. All rights reserved.
//

import UIKit
import CityBase

class MapCalloutView: UIView {
    var title : String = "";
    static var backgroundImage : UIImage? = nil;
    static var arrowImage : UIImage? = nil;
    let fontSize : CGFloat = 12;
    func sizeOfContent() -> CGSize {
        let font = UIFont.systemFont(ofSize: fontSize);
        let attributes : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : font,
            NSAttributedString.Key.foregroundColor : ResourceManager.NORMAL_TEXT_COLOR
        ];
        
        var size = title.size(withAttributes: attributes);
        if size.width < 50 {size.width = 50}
        return size;
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {

        let font = UIFont.systemFont(ofSize: fontSize);
        let attributes : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : font,
            NSAttributedString.Key.foregroundColor : UIColor.white
        ];
        
        let size = sizeOfContent();
        
        if MapCalloutView.backgroundImage == nil {
            MapCalloutView.backgroundImage = UIImage(named:"calloutBack")?.resizableImage(withCapInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), resizingMode:.stretch);
            MapCalloutView.arrowImage = UIImage(named:"calloutArrow");
        }
        
//        if let ctx = UIGraphicsGetCurrentContext() {
//            UIColor.red.setFill();
//            ctx.fill(rect);
//        }
        
        let rectBackground = rect.offsetBy(dx: 0, dy: -3);
        if let image = MapCalloutView.backgroundImage {
            image.draw(in: rectBackground);
        }
        
        if let image = MapCalloutView.arrowImage {
            let arrowRect = CGRect(x: (rect.width - image.size.width)/2,
                                   y: rectBackground.origin.y + 31,
                                   width: image.size.width,
                                   height: image.size.height);
            
            image.draw(in: arrowRect);
        }
        
        let point = CGPoint(x: (rectBackground.width - size.width)/2,
                            y: (rectBackground.height - size.height)/2 - 4);
        title.draw(at:point,withAttributes:attributes);
    }
}
