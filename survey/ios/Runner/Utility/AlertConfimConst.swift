//
//  AlertConfimConfig.swift
//  AlertConfirm
//
//  Created by 防神 on 2018/7/10.
//  Copyright © 2018年 吃面多放葱. All rights reserved.
//

import Foundation
import UIKit

typealias TextClosure = (String) -> Void
typealias EnumClosure = (Int) -> Void

class AlertConfimConst {
    
    static  let BTN_HEIGHT       : CGFloat = 44;
    static  let MARGIN           : CGFloat = 20;
    static  let MARGIN_TOP       : CGFloat = 8;
    static  let LABEL_HEIGHT     : CGFloat = 22;
    static let TEXT_LEADING     : CGFloat = 16;
    static let TEXTVIEW_HEGHT   : CGFloat = 82;
    static  let BORDER_RADIUS    : CGFloat = 4;
    
    static  let ITEM_TEXT_COLOR  : UIColor = UIColorFromRGB(0x252525)
    static  let NORMAL_TEXT_COLOR : UIColor = UIColorFromRGB(0x626262)
    static  let ALARM_COLOR      : UIColor = UIColorFromRGB(0xF34A4A)
    static  let PLACEHOLDER_COLOR: UIColor = UIColorFromRGB(0xB6B6B6)
    static  let PICKTURE_COLOR   : UIColor = UIColorFromRGB(0x5D5D5D)
    static  let BORDER_COLOR     : UIColor = UIColorFromRGB(0xDFDFDF)
    static  let LINE_COLOR       : UIColor = UIColorFromRGB(0xE7E7E7)
    static  let BG_COLOR         : UIColor = UIColorFromRGB(0xF4F4F4)
    static  let LIGHT_GRAY_COLOR : UIColor = UIColorFromRGB(0xB6B6B6)
    
    static  let NORMAL_TEXT_FONT : UIFont  = UIFont.systemFont(ofSize: 14)
    static  let SMALL_TEXT_FONT : UIFont  = UIFont.systemFont(ofSize: 12)
    static  let TITLE_TEXT_FONT  : UIFont  = UIFont.systemFont(ofSize: 17)
    
    static  let ALARM_TYPE         = [localString("ALARM_REAL_DESC"),
                                      localString("ALARM_TROUBLE_DESC"),
                                      localString("ALARM_MISS_DESC"),
                                      localString("ALARM_TEST_DESC")];
    static  let ALARM_TYPE_NOTE    = [localString("ALARM_REAL_DESC_TIP"),
                                      localString("ALARM_TROUBLE_DESC_TIP"),
                                      localString("ALARM_MISS_DESC_TIP"),
                                      localString("ALARM_TEST_DESC_TIP"),]
    static  let ALARM_REASON       = [localString("ALARM_REASON_1"),
                                      localString("ALARM_REASON_2"),
                                      localString("ALARM_REASON_3"),
                                      localString("ALARM_REASON_4"),
                                      localString("ALARM_REASON_5"),
                                      localString("ALARM_REASON_6"),
                                      localString("ALARM_REASON_7"),
                                      localString("ALARM_REASON_8"),
                                      localString("ALARM_REASON_9"),];
    static  let ALARM_PLACE        = [localString("ALARM_PLACE_1"),
                                      localString("ALARM_PLACE_2"),
                                      localString("ALARM_PLACE_3"),
                                      localString("ALARM_PLACE_4"),
                                      localString("ALARM_PLACE_5"),
                                      localString("ALARM_PLACE_6"),
                                      localString("ALARM_PLACE_7"),
                                      localString("ALARM_PLACE_8")];
    static  let ALARM_TITLE        = [localString("ALARM_CONFIRM_TITLE_1"),
                                      localString("ALARM_CONFIRM_TITLE_2"),
                                      localString("ALARM_CONFIRM_TITLE_3"),
                                      localString("ALARM_CONFIRM_TITLE_4")];
    static let ALARM_PLACEHOLDER  = [localString("ALARM_PLACEHOLDER_1"),
                                     localString("ALARM_PLACEHOLDER_2"),
                                     localString("ALARM_PLACEHOLDER_3")]
    static  let UPLOAD_ERROR       = localString("UPLOAD_ERROR")
    
    
    
}


