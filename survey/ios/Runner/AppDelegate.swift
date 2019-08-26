import UIKit
import Flutter
import MAMapKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate,UIDocumentInteractionControllerDelegate {
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
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url.absoluteString)
       
        NotificationCenter.default.post(name: NSNotification.Name("flutter_open_file"), object: self, userInfo: ["url":url.absoluteString])
        
//        DocumentManagerViewController.openFileAndSave(url.absoluteString);
        return true;
        //file:///private/var/mobile/Containers/Data/Application/43D523A9-B4CC-4B79-819B-761666AD9413/Documents/Inbox/iOS%E9%9D%A2%E8%AF%95%E8%A6%81%E9%97%AE%E7%9A%84-1.txt
        //打开文件，读取数据

        let documentVC = UIDocumentInteractionController(url: url)
        documentVC.delegate = self
//        documentVC.presentOpenInMenu(from: CGRect.zero, in: (topVC?.view)!, animated: true)
        return true
    }
    
    
 
  
}


