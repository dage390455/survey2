import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    
    let flutterViewController = FlutterProjectListViewController.init(project: nil, nibName: nil, bundle: nil);
    if let flutterViewController = flutterViewController{
        flutterViewController.setModel(model: FLUTTER_PROJECT_LIST)//先设置页面，否则用到view会先进入viewDidLoad
        flutterViewController.splashScreenView =  FlutterSplashViewController().view
        flutterViewController.view.frame = UIScreen.main.bounds;
        let navigationC=RootNavController(rootViewController: flutterViewController)
        self.window?.rootViewController=navigationC
    }
    
    let VC=FlutterTestViewController()
    
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}


