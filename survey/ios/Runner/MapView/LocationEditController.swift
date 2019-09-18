//
//  LocationEditController.swift
//  SensoroCity
//
//  Created by David Yang on 2018/9/11.
//  Copyright © 2018年 Sensoro. All rights reserved.
//

import UIKit
import CityBase
import Alamofire
import MAMapKit

import AMapSearchKit

class LocationEditController: UIViewController {
    @IBOutlet weak var navBar: NavigationHeader!
    @IBOutlet weak var mapStub: UIView!
    @IBOutlet weak var mapBottomPos: NSLayoutConstraint!
    
    var mapView : MAMapView! = nil;
    var search : AMapSearchAPI! = nil;
    var centerAnn : CustomPointAnnotation!;
    var SN : String = "";
    var lon : Double = 0;
    var lat : Double = 0;
    
    @IBOutlet weak var cityLocationLabel: UILabel!
    
    var readOnly : Bool = false;//标识是否只用来显示位置，
    var repositionDeviceOnly : Bool = false; //是否只是编辑设备位置
    //    var deployType : DeployType = .device;//记录部署类型，部署基站时，并不需要相应的ChannelMask设定。
    //    var record : DeployRecord! = nil;
    
    var completion : ((_ lat : Double, _ lon : Double, _ address : String, _ channelMask : [UInt32])->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var navItems = [NavigationHeader.Item]();
        navItems.append(NavigationHeader.Item(type: .button,
                                              id: "",
                                              btnTitleID : "取消",
                                              btnTitleColor : ResourceManager.LIGHT_TEXT_COLOR,
                                              action: { [weak self] (id) in
                                                self?.navigationController?.popViewController(animated: true);
        }));
        
        
        navItems.append(NavigationHeader.Item(type: .title, id: localString("定位地址"), action: nil));
        
        if readOnly == false {
            let item = NavigationHeader.Item(type: .button,
                                             id: "",
                                             btnTitleID : "保存",
                                             btnTitleColor : ResourceManager.SELECTED_COLOR,
                                             action: { [weak self] (id) in
                                                self?.ok();
            })
            navItems.append(item);
        }
        navBar.initContents(items: navItems);
        
        initMap();
        
        if repositionDeviceOnly == false {
            if readOnly == true {
                //地图全铺，并且挡住保存按钮，😛
                mapBottomPos.constant = 0;
            }
        }
    }
    
    deinit {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func initMap() -> Void {
        if mapView != nil {
            return;
        }
        
        search = AMapSearchAPI();
        search.delegate = self;
        
        let frame = mapStub.bounds;
        
        //创建地图
        mapView = MAMapView(frame: frame);
        mapView.delegate = self
        mapView.zoomLevel = 16;
        mapView.showsCompass = false;
        mapView.showsScale = false;
        mapView.showsUserLocation  = true;
        mapView.userTrackingMode = .follow;
        mapView.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleWidth]
        mapStub.addSubview(mapView)
        
        if centerAnn == nil {
            centerAnn = CustomPointAnnotation();
            centerAnn.isLockedToScreen = false;
            
            if lon == 0 && lat == 0 {
                centerAnn.coordinate = mapView.region.center;
            }else{
                centerAnn.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon);
            }
            mapView.addAnnotation(centerAnn);
            mapView.selectAnnotation(centerAnn, animated: true);
            
            let pos = self.centerAnn.coordinate;
            DispatchQueue.main.async {
                self.updateLocationInfo(lon: pos.longitude, lat: pos.latitude);
            }
        }
        
    }
    
    func updateLocationInfo(lon : Double,lat : Double){
        let request = AMapReGeocodeSearchRequest();
        if lon == 0 && lat == 0 {
            request.location = AMapGeoPoint.location(withLatitude: CGFloat(mapView.region.center.latitude), longitude: CGFloat(mapView.region.center.longitude));
        }else{
            request.location = AMapGeoPoint.location(withLatitude: CGFloat(lat), longitude: CGFloat(lon));
        }
        request.requireExtension = true;
        search.aMapReGoecodeSearch(request);
    }
    
    @IBAction func locationMe(_ sender: Any) {
        
        if readOnly {
            mapView.setCenter(CLLocationCoordinate2D(latitude: lat, longitude: lon), animated: true);
        }else{
            mapView.setCenter(mapView.userLocation.coordinate, animated: true);
        }
    }
    
    func ok() {
        var address = "";
        if let temp = centerAnn.title {
            address = temp;
        }
        
        let doFinish = { [weak self] (_ channelMask : [UInt32]) in
            guard let weakSelf = self else {
                return;
            }
            //有可能后取不到相应的配置信息，此时不需要配置ChannelMask
            if let callback = weakSelf.completion {
                DispatchQueue.main.async {
                    callback(weakSelf.centerAnn.coordinate.latitude,
                             weakSelf.centerAnn.coordinate.longitude,
                             address,
                             channelMask);
                }
            }
            weakSelf.navigationController?.popViewController(animated: true);
        }
        doFinish([]);
    }
    
    
}

extension LocationEditController : MAMapViewDelegate, AMapSearchDelegate {
    
    func mapViewRegionChanged(_ mapView: MAMapView!) {
        if readOnly == false {//显示状态下不能编辑相应的位置
            if centerAnn != nil {
                centerAnn.coordinate = mapView.region.center;
            }
            
            //            DispatchQueue.main.async {
            //                self.updateLocationInfo(lon: mapView.region.center.longitude, lat: mapView.region.center.latitude);
            //            }
        }
    }
    
    func mapViewDidFailLoadingMap(_ mapView: MAMapView!, withError error: Error!) {
        //        mapTip.isHidden = false;
        mapView.isHidden = true;
    }
    
    func mapView(_ mapView: MAMapView!, regionDidChangeAnimated animated: Bool) {
        if readOnly == false {//显示状态下不能编辑相应的位置
            if centerAnn != nil {
                centerAnn.coordinate = mapView.region.center;
            }
            //            DispatchQueue.main.async {
            //                self.updateLocationInfo(lon: self.centerAnn.coordinate.longitude,
            //                                        lat: self.centerAnn.coordinate.latitude);
            //            }
        }
    }
    
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        if readOnly == false {//显示状态下不能编辑相应的位置
            if centerAnn != nil {
                centerAnn.coordinate = mapView.region.center;
            }
            
            DispatchQueue.main.async {
                self.updateLocationInfo(lon: mapView.region.center.longitude, lat: mapView.region.center.latitude);
            }
        }
    }
    
    func mapView(_ mapView: MAMapView!, mapDidZoomByUser wasUserAction: Bool) {
        if readOnly == false {//显示状态下不能编辑相应的位置
            if centerAnn != nil {
                centerAnn.coordinate = mapView.region.center;
            }
            
            //            DispatchQueue.main.async {
            //                self.updateLocationInfo(lon: mapView.region.center.longitude, lat: mapView.region.center.latitude);
            //            }
        }
    }
    
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        
        if centerAnn != nil {
            //                print(response.regeocode.formattedAddress )
            centerAnn.title = getCustomAddress(components:response.regeocode.addressComponent);
            self.cityLocationLabel.text = getProvinceAddress(components:response.regeocode.addressComponent);
            
            if centerAnn.annotationView != nil && centerAnn.annotationView.calloutView != nil {
                centerAnn.annotationView.udpateCalloutTitle(title:centerAnn.title);
            }
        }
    }
    
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        print("Error: \(error.localizedDescription)")
    }
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        if annotation is MAUserLocation {
            return nil;
        }
        
        if annotation is CustomPointAnnotation {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: CustomAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as? CustomAnnotationView;
            
            if annotationView == nil {
                annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
                annotationView!.centerOffset = CGPoint(x:0, y:-20);
                annotationView!.canShowCallout = false
            }
            
            (annotation as! CustomPointAnnotation).annotationView = annotationView;
            annotationView!.image = UIImage(named:"annotation");
            return annotationView!
        }
        
        return nil;
    }
    
    
    
    //通过统一的规则从高德返回的地址中获取到一个描述
    public func getProvinceAddress(components : AMapAddressComponent) -> String {
        var ret = "";
        
        if components.province != nil { ret += components.province; }
        if components.city != nil {
            if components.city != components.province {
                ret += components.city;
            }
        }
        if components.district != nil { ret += components.district; }
        
        
        return ret;
    }
    
    
}



