import UIKit
import Flutter
import MAMapKit
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    
    AMapServices.shared().apiKey = "9ca1eb424c7ffcfe31888b98aa85ff48";
    AMapServices.shared().enableHTTPS = true
    
    
    let flutterViewController = FlutterProjectListViewController.init(project: nil, nibName: nil, bundle: nil);
    if let flutterViewController = flutterViewController{
        flutterViewController.setModel(model: FLUTTER_PROJECT_LIST)//先设置页面，否则用到view会先进入viewDidLoad
        flutterViewController.splashScreenView =  FlutterSplashViewController().view
        flutterViewController.view.frame = UIScreen.main.bounds;
        let navigationC=RootNavController(rootViewController: flutterViewController)
        self.window?.rootViewController=navigationC
        
        //暂时写这里  后面整合到管理类
        let bascChanal = FlutterBasicMessageChannel(name: "BasicMessageChannelPlugin", binaryMessenger: flutterViewController, codec: FlutterStringCodec.init());
        
        bascChanal.setMessageHandler { [weak self] (message, fr) in
            guard let self = self else { return }

            let postion = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LocationEditController") as! LocationEditController;

              postion.completion = { [weak self] (lat,lon, address, channelMask)->Void in
                guard self != nil else {return;}

                 bascChanal.sendMessage(address)
            }
            navigationC.pushViewController(postion, animated: true);
            fr("swift 传值成功")
            
        }
    }
    
   
   
    let VC=FlutterTestViewController()
    
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
}


