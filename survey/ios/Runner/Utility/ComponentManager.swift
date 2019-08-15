//
//  ComponentManager.swift
//  
//
//  Created by David Yang on 2019/6/27.
//

import Foundation
import CityBase

class FlutterComponentManager {
    static let shared = FlutterComponentManager();

    private static let controllerIDMap : [String : (compnent:String,factory : String, controllerIDInComponent : String)] = [
        "calendar" : ("UIComponents","UIComponentsFactory","calendar"),
    ]
    
    private init() {
        
    }
    
    static func getController(controllerID : String, parameter : [String:Any]? = nil) -> UIViewController? {
        guard let (component, factory, controllerIDInComponent) = controllerIDMap[controllerID] else {
            return nil;
        }
        
        let classType : AnyClass? = NSClassFromString("\(component).\(factory)");
        if let instance = classType as? ModuleFactoryProtocol.Type {
            let componenetRet = instance.component(type : .controller, identifier : controllerIDInComponent, parameters: parameter);
            switch componenetRet {
            case .successful(let ret):
                switch ret {
                case let value where value is UIViewController:
                    let controller = value as! UIViewController;
                    return controller;
                default:
                    print("Error component")
                }
            case .failure(let error):
                print(error)
            }
        }
        
        
        return nil;
    }
    
}
