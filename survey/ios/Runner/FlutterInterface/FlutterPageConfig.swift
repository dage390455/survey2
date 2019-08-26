//
//  FlutterPageConfig.swift
//  Runner
//
//  Created by zhangyg on 2019/7/22.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import UIKit

//每个flutter页面用这几个属性传递数据
struct FlutterPageModel {
    let routeName : String; //路由名称，用于唯一标识一个flutter页面
    let eventChannel : String    //native->flutter
    let methodChannel : String ;  //flutter->native
    let methods : [String]?; //方法列表
    let events : [String]?; //方法列表

}

let FLUTTER_CITY_DETAIL = FlutterPageModel.init(routeName: "cityDetail",
                                                eventChannel: "App/Event/Channel",
                                                methodChannel: "com.pages.your/city_detail",
                                                methods: nil, events:nil);

let FLUTTER_CITY_LIST = FlutterPageModel.init(routeName: "cityList",
                                              eventChannel: "App/Event/Channel",
                                              methodChannel: "com.pages.your/city_list",
                                              methods: nil, events:nil);

let FLUTTER_TASK_LIST = FlutterPageModel.init(routeName: "taskList",
                                              eventChannel: "App/Event/Channel",
                                              methodChannel: "com.pages.your/task_list",
                                              methods: nil, events:nil);

let FLUTTER_TASK_TEST = FlutterPageModel.init(routeName: "taskTest",
                                              eventChannel: "App/Event/Channel",
                                              methodChannel: "com.pages.your/task_test",
                                              methods: nil, events:nil);

let FLUTTER_ELECTRIC_INSTALL = FlutterPageModel.init(routeName: "electricInstall",
                                              eventChannel: "App/Event/Channel",
                                              methodChannel: "com.pages.your/electric_install",
                                              methods: nil, events:nil);

let FLUTTER_PROJECT_LIST = FlutterPageModel.init(routeName: "projectList",
                                                     eventChannel: "App/Event/Channel",
                                                     methodChannel: "com.pages.your/project_list",
                                                     methods: nil, events:nil);

let FLUTTER_INFORMATION = FlutterPageModel.init(routeName: "surveyInformation",
                                                 eventChannel: "App/Event/Channel",
                                                 methodChannel: "com.pages.your/project_list",
                                                 methods: nil, events:nil);
