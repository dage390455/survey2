//
//  FlutterBaseViewController.swift
//  Runner
//
//  Created by sensoro on 2019/7/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//
//  基类FlutterBaseViewController，实现了eventChannel的注册和监听，子类只需要override监听部分就可以了。

import UIKit
import Flutter
import CityBase
import Alamofire


class FlutterBaseViewController: FlutterViewController,FlutterStreamHandler {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         //eventChannel注册一次就可以，多次往flutter发送请求需要dart端主动执行eventChannel
        // Do any additional setup after loading the view.
    }
    
    //注册 EventChannel，用于原生往flutter发送数据
    func setEventChannel(channelName: String) -> Void {
        //FlutterEventChannel用于navtive给flutter主动发送数据 ,iOS 采用 bundleidentifier + event type + channelname
        let eventChannel = FlutterEventChannel(name: channelName,
                                              binaryMessenger: self)
        //注释掉就不能从往flutter发信息了
        eventChannel.setStreamHandler(self)
    }
    
    //注册 messageChannel，用于接收flutter的数据,子类可重写该方法
    func setMessageChannel(channelName:String) -> Void {
        let channelName  = channelName;
        let messageChannel = FlutterMethodChannel.init(name: channelName, binaryMessenger:  self);
        messageChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            if ("navBack" == call.method) {
                self.navigationController?.popViewController(animated: true);
            } else {
                result(FlutterMethodNotImplemented);
            }
        });
    }
    

    //以下是EventChannel的监听，在回调中向flutter发送数据
    var mEventSink: FlutterEventSink?
    //@escaping标明这个闭包是会“逃逸”,通俗点说就是这个闭包在函数执行完成之后才被调用,,子类重写该方法
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        mEventSink = events
        return nil
    }
    
    //此处的arguments可以转化为刚才receiveBroadcastStream("init")的名称，这样我们就可以一个event来监听多个方法实例
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        // arguments flutter给native的参数
        mEventSink = nil
        return nil
    }

    //字典和JSON互转的例子
    func modelToJson() -> Void {
        var modelDic = [String : String]()
        modelDic["1"] = "222"
        modelDic["2"] = "222"
        modelDic["3"] = "222"
        modelDic["4"] = "222"
        
        var jsonStr = "";
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: modelDic, options: [])
            jsonStr = String(data: jsonData, encoding: .utf8) ?? ""
        } catch { }
        
        let strData = jsonStr.data(using: .utf8)
        do {
            var account = [String : String]()
            if let jsonDic = try JSONSerialization.jsonObject(with: strData ?? Data(), options: []) as? [String:String] {
                account["1"] = jsonDic["1"] ?? ""
                account["1"] = jsonDic["2"] ?? ""
                account["1"] = jsonDic["3"] ?? ""
                account["1"] = jsonDic["4"] ?? ""
            }
        } catch { }
        return
    }
    
    //把模型转化为字典
    func convertToDictNesting(obj: Any, remainFeild: [String]? = nil, replace: (((label: String, value: Any)) -> (String, Any))? = nil) -> [String: Any] {
        var dict: [String: Any] = [:]
        var children: [Mirror.Child] = []
        if let superChildren = Mirror(reflecting: obj).superclassMirror?.children {
            children.append(contentsOf: superChildren)
        }
        children.append(contentsOf: Mirror(reflecting: obj).children)
        for child in children {
            if let key = child.label {
                if let remainFeild = remainFeild, !remainFeild.contains(key) {
                    continue
                }
                let subMirror = Mirror(reflecting: child.value)
                if let displayStyle = subMirror.displayStyle, displayStyle == .optional {
                    if subMirror.children.isEmpty {
                        continue
                    }
                }
                //解析类型属性
                let subDict = convertToDictNesting(obj: child.value, remainFeild: remainFeild, replace: replace)
                if subDict.isEmpty {
                    if let replaceReturn = replace?((key, child.value)) {
                        if !replaceReturn.0.isEmpty {
                            if let aryValue = replaceReturn.1 as? [Any] {
                                var dictAry: [Any] = []
                                for value in aryValue {
                                    let subDict = convertToDictNesting(obj: value, remainFeild: remainFeild, replace: replace)
                                    if subDict.isEmpty {
                                        dictAry.append(value)
                                    } else {
                                        dictAry.append(subDict)
                                    }
                                }
                                dict[replaceReturn.0] = dictAry
                            } else {
                                dict[replaceReturn.0] = replaceReturn.1
                            }
                        }
                    } else {
                        if let aryValue = child.value as? [Any] {
                            var dictAry: [Any] = []
                            for value in aryValue {
                                let subDict = convertToDictNesting(obj: value, remainFeild: remainFeild, replace: replace)
                                if subDict.isEmpty {
                                    dictAry.append(value)
                                } else {
                                    dictAry.append(subDict)
                                }
                            }
                            dict[key] = dictAry
                        } else {
                            dict[key] = child.value
                        }
                    }
                } else {
                    //非基础数据类型暂时只支持label替换
                    if let replace = replace?((key, child.value)) {
                        if !replace.0.isEmpty {
                            if let someDict = subDict["some"] {
                                dict[replace.0] = someDict
                            } else {
                                dict[replace.0] = subDict
                            }
                        }
                    } else {
                        if let someDict = subDict["some"] {
                            dict[key] = someDict
                        } else {
                            dict[key] = subDict
                        }
                    }
                }
            }
        }
        return dict
    }
}
