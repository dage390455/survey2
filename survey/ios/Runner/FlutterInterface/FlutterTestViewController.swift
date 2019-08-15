//
//  ViewController.swift
//  FlutterComponent
//
//  Created by sensoro on 2019/7/12.
//  Copyright © 2019 sensoro. All rights reserved.
//

import UIKit
import Flutter
import CityBase
import Alamofire
 


class FlutterTestViewController: UIViewController{

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //swift的 appdelegate全局实例
//        var czzz = UIApplication.shared.delegate as! AppDelegate
//        czzz.flutterVC
//        czzz.aa
      
        self.navigationController?.isNavigationBarHidden=true;
        self.view.backgroundColor = UIColor.white;
//        let vc = ViewController.init()
//        UINavigationController.init(rootViewController: vc);
        
        var titleL = UILabel(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: 30))
        titleL.text="我是Swift测试页面";
        titleL.textAlignment = NSTextAlignment.center;
        view.addSubview(titleL)
        
        var LoginBtn = UIButton()
        LoginBtn = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width/2-80, y: 210, width: 160, height: 60))
        LoginBtn.addTarget(self, action: #selector(loginIn), for: .touchUpInside)
        LoginBtn.isHidden = false
        LoginBtn.backgroundColor =  UIColor.lightGray
        LoginBtn.titleLabel?.text = "登录"
        LoginBtn.setTitleColor(UIColor.black, for:.normal)
        LoginBtn.setTitle("登录", for: .normal)
        LoginBtn.isEnabled = true
        view.addSubview(LoginBtn)
        
        var nextBtn = UIButton()
        nextBtn = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width/2-80, y: 290, width: 160, height: 60))
        nextBtn.addTarget(self, action: #selector(pushFlutterViewController), for: .touchUpInside)
        nextBtn.isHidden = false
        nextBtn.backgroundColor =  UIColor.lightGray
        nextBtn.titleLabel?.text = "打开flutter"
        nextBtn.setTitleColor(UIColor.black, for:.normal)
        nextBtn.setTitle("去任务列表", for: .normal)
        nextBtn.isEnabled = true
        view.addSubview(nextBtn)
        
        loginIn()
//        getVideoFilterList()
        // Do any additional setup after loading the view.
    }
    
     @objc func loginIn(){
        SVProgressHUD.showProgress(-1, status:"数据加载中");
        Login()
        
        return;
    }
    
    @objc func pushFlutterViewController(){
        
        let flutterViewController = FlutterTaskListViewController.init(project: nil, nibName: nil, bundle: nil);
        if let flutterViewController = flutterViewController{
            flutterViewController.setModel(model: FLUTTER_TASK_LIST)//先设置页面，否则用到view会先进入viewDidLoad
            flutterViewController.splashScreenView =  FlutterSplashViewController().view
            flutterViewController.view.frame = UIScreen.main.bounds;
            self.navigationController?.pushViewController(flutterViewController, animated: true)
        }
        return;
        

    }
    
//    https://city-dev-api.sensoro.com/tasklogs?limit=10&endTime=1563811199999&beginTime=1563465600000&offset=0
   
    
    func Login(){
        let name = "15110041945"
        let key = "aa1111"
        let appType = "enterprise";
        
        NetworkManager.product = .DEV;
        NetworkManager.product = .TEST;
        NetworkManager.saveServerConfigToUserDifault();
        
        let _ = NetworkManager.shared.login(name, password: key, appType: appType) { (error) in
            
            if error == nil {
                print("登录成功")
                SVProgressHUD.showSuccess(withStatus:"登录成功" )
//                self.getVideoFilterList();
            }else{
                if error!.errCode == 0 {
                    SVProgressHUD.showError(withStatus: "登录失败");
                } else {
                    SVProgressHUD.showError(withStatus: error!.errMsg);
                }
            }
        }
    }
    
    

    @objc func pushTestViewController(){
//        let testViewController = TestViewController();
//        self.navigationController?.pushViewController(testViewController, animated: true)
 
    }


}


