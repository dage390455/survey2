//
//  LocationManager.swift
//  SensoroCity
//
//  Created by David Yang on 2018/9/30.
//  Copyright © 2018 Sensoro. All rights reserved.
//

import UIKit

class LocationManager: NSObject {
    static var shared = LocationManager();

    private let locationManager = CLLocationManager();
    
    private let geocoder = CLGeocoder();

    
    var currentLoc : CLLocation!;

    func requireAuthorization() -> Void {
        locationManager.requestWhenInUseAuthorization();
    }
    
    func startService() {
        locationManager.delegate = self;
        locationManager.startUpdatingLocation();
    }
    
    func stopService() {
        locationManager.delegate = nil;
        locationManager.stopUpdatingLocation();
    }
    
    func checkAvailable() -> Bool {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways,.authorizedWhenInUse:
            return true;
        case .denied,.restricted:
            return false;
        case .notDetermined:
            requireAuthorization();
            return true;
        @unknown default:
            return false;
        }
    }
    
    //true: location1 更近，false: location2 更近;
    func isMoreNear(loc1 : [Double],loc2 : [Double]) -> Bool {
        
        if currentLoc == nil { return false; }
        
        let location1 = CLLocation(latitude: loc1[1], longitude: loc1[0])
        let location2 = CLLocation(latitude: loc2[1], longitude: loc2[0])

        let dist1 = currentLoc.distance(from: location1);
        let dist2 = currentLoc.distance(from: location2);

        //10米内不进行排序
        if fabs(dist1 - dist2) < 10 {return false;}
        
        if dist1 < dist2 { return true; }
        
        return false;
    }
    
    func lookUpCurrentLocation( loc : CLLocationCoordinate2D, completionHandler: @escaping (CLPlacemark?)
        -> Void ) {
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(CLLocation(latitude: loc.latitude, longitude: loc.longitude),
                                        completionHandler: { (placemarks, error) in
                                            if error == nil {
                                                let firstLocation = placemarks?[0]
                                                completionHandler(firstLocation)
                                            }
                                            else {
                                                // An error occurred during geocoding.
                                                completionHandler(nil)
                                                //                                                print(error?.localizedDescription);
                                            }
        })
    }
}

extension LocationManager : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLoc = locations.last;
    }
}
