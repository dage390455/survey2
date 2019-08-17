//
//  CustomAnnotationView.swift
//  SensoroCity
//
//  Created by David Yang on 2017/7/26.
//  Copyright © 2017年 Sensoro. All rights reserved.
//

import UIKit
import MAMapKit

class CustomAnnotationView: MAAnnotationView {

    
    var calloutView : MapCalloutView! = nil;
    
    override func setSelected(_ selected: Bool, animated: Bool) {

        if self.isSelected == selected {
            return ;
        }

        if selected {
            if self.calloutView == nil {
                let frame = CGRect(x: 0, y: 0, width: 51, height: 35);
                let view = MapCalloutView(frame: frame);
                view.backgroundColor = UIColor.clear;
                view.title = "";
                self.calloutView = view;
                self.calloutView.center = CGPoint(x: bounds.width/2 + self.calloutOffset.x,
                                                  y: -calloutView.bounds.height/2 + calloutOffset.y)
            }
            
            if let title = self.annotation.title {
                if title != nil  {
//                    self.calloutView.title = title!
                    udpateCalloutTitle(title: title!);
                }
            }
            
            self.addSubview(calloutView);
        }else{
            self.calloutView.removeFromSuperview();
        }
        
        super.setSelected(selected, animated: animated);
    }
    
    func udpateCalloutTitle(title : String) {
        guard calloutView != nil else {
            return;
        }
        
        calloutView.title = title;
        
        let size = calloutView.sizeOfContent();
        
        calloutView.frame = CGRect(x: 0, y: 0, width: size.width + 20, height: 35);
        
        calloutView.center = CGPoint(x: bounds.width/2 + self.calloutOffset.x,
                                          y: -calloutView.bounds.height/2 + calloutOffset.y)
        calloutView.setNeedsDisplay();
        
    }
    
//    
//    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        var inside = super.point(inside: point, with: event);
//        
//        if !inside && isSelected {
//            inside = calloutView.point(inside: convert(point, to: calloutView), with: event);
//        }
//        
//        return inside;
//    }
    
}
