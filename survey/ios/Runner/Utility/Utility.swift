//
//  Utility.swift
//  SensoroCity
//
//  Created by David Yang on 16/2/29.
//  Copyright © 2016年 Sensoro. All rights reserved.
//

import UIKit
import Foundation
//import MapKit
//import SystemConfiguration.CaptiveNetwork
import CityBase

final class Utility {
    
}
enum VersionSize {
    case greaterThan;//大于
    case equalTo;//等于
    case lessThan;//小于
}

// 状态栏高度
let STATUS_BAR_HEIGHT = CGFloat((ResourceManager.isiPhoneXSeries ? 44.0 : 20.0))
// 导航栏高度
let NAVIGATION_BAR_HEIGHT = CGFloat((ResourceManager.isiPhoneXSeries ? 100.0 : 76.0))
// tabBar高度
let TAB_BAR_HEIGHT    =  CGFloat((ResourceManager.isiPhoneXSeries ? (49.0 + 34.0) : 49.0))
// home indicator
let HOME_INDICATOR_HEIGHT = CGFloat((ResourceManager.isiPhoneXSeries ? 34.0 : 0.0))
// distance between header and content
let HEADER_CONTENT_OFFSET = CGFloat(12);
// tableView 适配 iOS 11
func contentInsetAdjustment(view: UIScrollView?, controller: UIViewController){
    if #available(iOS 11.0, *){
        view?.contentInsetAdjustmentBehavior = .never
    }else{
        controller.automaticallyAdjustsScrollViewInsets = false
    }
}

let LONGITUDE_INDEX = 0;
let LATITUDE_INDEX = 1;
let LOC_ARRAY_SIZE = 2;

func UIColorFromRGB(_ rgbValue : Int32) -> UIColor {
    return UIColor.fromRGB(rgbValue);
}

func UIColorFromRGBWithAlpha(_ rgbValue : Int32,alpha : CGFloat) -> UIColor {
    return UIColor.fromRGBWithAlpha(rgbValue, alpha: alpha);
}

func kScreen_Width() -> CGFloat {
    return UIScreen.currentWidth();
}

func kScreen_Height() -> CGFloat {
    return UIScreen.currentHeight();
}

let kKeyboardHeight : CGFloat = 238;

let searchBarTextColor = UIColor(red: 0x88/255, green: 0x9E/255, blue: 0xB1/255, alpha: 1.0);
let searchBarBackgroundColor = UIColor(red: 0xFE/255, green: 0xFE/255, blue: 0xFF/255, alpha: 1.0);

 
//时间戳转日期字符串
func timestamp(timestamp: UInt64, _ format: String) -> String {
    
    let timeInterval = TimeInterval(timestamp)/TimeInterval(1000);
    let date = Date(timeIntervalSince1970: timeInterval);
    let formatter = DateFormatter();
    formatter.dateFormat = format;
    return formatter.string(from: date);
}
