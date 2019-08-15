//
//  Station.swift
//  SensoroCity
//
//  Created by David Yang on 2018/6/26.
//  Copyright © 2018年 Sensoro. All rights reserved.
//

import UIKit
import CityBase

class Station: NSObject {
    let SN : String;
    var name : String = "";
    var lonlat = [Double]();//0 : lon, 1 : lat
    var tags = [String]();
    var updatedTime : Int64 = 0;
    var deployTime : Int64 = 0;
    var status : StationStatus = .unknown;

    init(SN : String) {
        self.SN = SN;
    }
    
}

extension Station : Decodable {
    static func decode(_ json: JSON) -> Decoded<Station> {
        var ret : Decoded<Station> = .failure(.missingKey("Json"));
        
        var failedField = [String]();
        
        var sn = "";
        if let temp = json["sn"].string {
            sn = temp;
        }else{
            failedField.append("sn");
            return .failure(.missingKey(failedField.joined(separator: ",")));
        }
        
        let device = Station(SN: sn);
        
        if let temp = json["name"].string {
            device.name = temp;
        }
        
        if let temp = json["lonlat"].array {
            
            for item in temp {
                if let value = item.double{
                    device.lonlat.append(value);
                }
            }
        }
        
        if let temp = json["normalStatus"].int {
            if let status = StationStatus(rawValue: temp){
                device.status = status;
            }
        }

        if let temp = json["tags"].array {
            for item in temp {
                if let value = item.string{
                    device.tags.append(value);
                }
            }
        }

        
        if let temp = json["updatedTime"].int64 {
            device.updatedTime = temp;
        }else{
            device.updatedTime = 0;
            print("not include updatedTime")
        }
        
        if let temp = json["deployTime"].int64 {
            device.deployTime = temp;
        }else{
            device.deployTime = 0;
            print("not include deployTime")
        }

        if failedField.count == 0 {
            ret = .success(device);
        }else{
            ret = .failure(.missingKey(failedField.joined(separator: ",")));
        }
        
        return ret;
    }
}

enum StationStatus : Int {
    case normal = 0;
    case error = 1;
    case danger = 2;
    case offline = 4;
    case timeout = 3;
    case inactive = -1;
    case unknown = -10;

    var desc : String {
        switch self {
        case .error:
            return localString("STATUS_STATION_ERROR_TITLE");
        case .danger:
            return localString("STATUS_STATION_DANGER_TITLE");
        case .normal:
            return localString("STATUS_STATION_NORMAL_TITLE");
        case .offline:
            return localString("STATUS_STATION_OFFLINE_TITLE");
        case .inactive:
            return localString("STATUS_STATION_INACTIVE_TITLE");
        case .timeout:
            return localString("STATUS_STATION_TIMEOUT_TITLE");
        case .unknown:
            return localString("UNKNOWN");
        }
    }
}


func localString(_ string : String, comment : String = "Error") -> String {
    return NSLocalizedString(string, tableName: "localization",comment: comment)
}
