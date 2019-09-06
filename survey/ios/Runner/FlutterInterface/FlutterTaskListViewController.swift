//
//  FlutterTaskListViewController.swift
//  Runner
//
//  Created by sensoro on 2019/7/22.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import UIKit
import Foundation
import CityBase
import UIComponents
import Flutter

class FlutterTaskListViewController: FlutterBaseViewController {
    
    var eventSink: FlutterEventSink?;
    var beginTime          : TimeInterval = 0.0
    var endTime            : TimeInterval = 0.0
    var dateTime           : String = ""
    var cmdID           : String = ""
    var calendarView       : UIView?
    var timeLabel          : UILabel?
    
    var currentPage : Int = 1;
    var isComplete = false;
    
    var checkTimer : Timer!;
    
    var pageModel : FlutterPageModel? = nil;
    
    var dataList = [NSDictionary]();
    
    //    @IBOutlet weak var dateHeight: NSLayoutConstraint!
    //    @IBOutlet weak var dateTime: UILabel!
    
    
    func setModel(model:FlutterPageModel){
        setInitialRoute(model.routeName)
        pageModel = model
        //        self.loadContent(isComplete: self.isComplete, isHeader: true ,isShowLoading: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let time: TimeInterval = 1.0
        
        beginTime=1562464600000  //测试用
        endTime=1563897599999
        beginTime = 0;
        endTime = 0;
        
        setMessageChannel(channelName:pageModel!.methodChannel);
        setEventChannel(channelName: pageModel!.eventChannel);
        // Do any additional setup after loading the view.
    }
    
    var islightContent = false {
        
        didSet{
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if !islightContent {
            return UIStatusBarStyle.default
        }
        return UIStatusBarStyle.default
    }
     
    
//    func showCalendar() -> Void{
//        if let controller = FlutterComponentManager.getController(controllerID: "calendar") as? CalendarViewController {
//            if self.beginTime != 0 && self.endTime != 0 {
//                controller.firstDate = Date(timeIntervalSince1970: self.beginTime);
//                controller.endDate = Date(timeIntervalSince1970: self.endTime);
//            }
//
//
//            controller.completion = { [weak self] (start,end) in
//                guard let weakSelf = self else {return;}
//
//                let formatter = DateFormatter()
//                formatter.dateFormat = "yyyy.MM.dd"
//                //                weakSelf.dateTime.text = formatter.string(from: start) + " ~ " + formatter.string(from: end);
//
//                weakSelf.beginTime = start.timeIntervalSince1970;
//                weakSelf.endTime = end.timeIntervalSince1970;
//
//                var beginTime = start.timeIntervalSince1970*1000
//                var endTime = end.timeIntervalSince1970*1000;
//
//                let headers:[String: String]? = NetworkManager.shared.headers ;
//                let TaskLogURL = NetworkManager.TaskLogURL;
//                let baseURL = NetworkManager.baseURL;
//                let urlStr:String? = baseURL+TaskLogURL;
//                let parameters : Dictionary?  = ["finish" : "false","offset" : 0, "limit" : 10,"beginTime" :  beginTime,"endTime" :  endTime] as [String : Any];
//
//                if let urlStr = urlStr, let headers = headers,let parameters = parameters {
//                    weakSelf.mEventSink?(["name":"showCalendar","beginTime" :  beginTime,"endTime" :  endTime] )
//                    weakSelf.mEventSink?(["name":"getURL","urlStr":urlStr,"headers":headers,"params":parameters] )
//                }
//
//            }
//            controller.modalPresentationStyle = .overFullScreen;
//            self.present(controller, animated: false, completion: nil);
//        }
//    }
    
    //MARK: - flutter delegate
    //注册 messageChannel，用于接收flutter的数据
    override func setMessageChannel(channelName:String) -> Void {
        let messageChannel = FlutterMethodChannel.init(name: channelName, binaryMessenger:  self);
        messageChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            if ("navBack" == call.method) {
                self.navigationController?.popViewController(animated: true);
                //                    [flutterViewController dismissViewControllerAnimated:YES completion:nil];
                //                    self.receiveBatteryLevel(result: result);
            }
            else if ("getList" == call.method) {
                var dic =  call.arguments as! NSDictionary
                var pageNo = dic["pageNO"] as! Int;
                self.currentPage = pageNo;
                if(pageNo==1){
                    //                    self.loadContent(isComplete: self.isComplete, isHeader: true ,isShowLoading: false)
                    //清空datalist
                    self.dataList.removeAll();
                }else{
                    //                    self.loadContent(isComplete: self.isComplete, isHeader: false ,isShowLoading: false)
                }
                
                let headers:[String: String]? = NetworkManager.shared.headers ;
                let TaskLogURL = NetworkManager.TaskLogURL;
                let baseURL = NetworkManager.baseURL;
                let urlStr:String? = baseURL+TaskLogURL;
                
                var parameters : Dictionary?  = ["finish" : "false","offset" : 0, "limit" : 10,"beginTime" : self.beginTime,"endTime" : self.endTime] as [String : Any];
                if (self.beginTime == 0 || self.endTime == 0){
                    parameters = ["finish" : "false","offset" : 0, "limit" : 10];
                }
                
                if let urlStr = urlStr, let headers = headers,let parameters = parameters {
                    self.mEventSink?(["name":"getURL","urlStr":urlStr,"headers":headers,"params":parameters] )
                }
                
                
            }
            else if ("showCalendar" == call.method) {
                
            }
                
            else {
                result(FlutterMethodNotImplemented);
            }
        });
    }
    
    //setEventChannel 后需要重写该方法来向flutter发送消息
    override func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        mEventSink = events
        let str:String = arguments as! String
        if str == "getList"{
            
            if(self.dataList.count>0){
                //                events(["content":self.dataList,"name":"getList"] )
            }
            
            events("我来自native11")
        }
        if str == "showCalendar"{
            //            events("我来自native133")
            //字典类型，数组都可以直接传过去
            //            events(self.userInfo2)
        }
        events("我来自native222")
        return nil
    }
    
}



