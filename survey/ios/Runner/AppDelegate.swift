import UIKit
import Flutter
import MAMapKit
import city_pickers
import shared_preferences
import Photos

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate,UIDocumentInteractionControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
  var bascChanalpickImage:FlutterBasicMessageChannel!;
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    
//    CityPickersPlugin.register(with:self.registrar(forPlugin: "city_pickers"))
    
    AMapServices.shared().apiKey = "59b32dda2847efb5b44c249b24cc5e77";
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
      
        bascChanalpickImage = FlutterBasicMessageChannel(name: "BasicMessageChannelPluginPickImage", binaryMessenger: flutterViewController, codec: FlutterStringCodec.init());
        
        bascChanalpickImage.setMessageHandler { [weak self] (message, fr) in
            guard let self = self else { return }
            
//            let postion = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LocationEditController") as! LocationEditController;
//
//            postion.completion = { [weak self] (lat,lon, address, channelMask)->Void in
//                guard self != nil else {return;}
//
//                bascChanal.sendMessage(address)
//            }
//            navigationC.pushViewController(postion, animated: true);
            fr("swift 传值成功")
            var sourceType = UIImagePickerControllerSourceType.camera
            
            
            if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
                sourceType = UIImagePickerControllerSourceType.photoLibrary
            }

            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = sourceType
    
            flutterViewController.present(picker, animated: true, completion: nil)//进入照相界面
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
    
    var localId:String!
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        PHPhotoLibrary.shared().performChanges({
            let result = PHAssetChangeRequest.creationRequestForAsset(from: image)
            let assetPlaceholder = result.placeholderForCreatedAsset
            //保存标志符
            self.localId = assetPlaceholder?.localIdentifier
        }) { (isSuccess: Bool, error: Error?) in
            if isSuccess {
                print("保存成功!")
                //通过标志符获取对应的资源
                let assetResult = PHAsset.fetchAssets(
                    withLocalIdentifiers: [self.localId], options: nil)
                let asset = assetResult[0]
                let options = PHContentEditingInputRequestOptions()
                options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData)
                    -> Bool in
                    return true
                }
                //获取保存的图片路径
                asset.requestContentEditingInput(with: options, completionHandler: {
                    (contentEditingInput:PHContentEditingInput?, info: [AnyHashable : Any]) in
                    print("地址：",contentEditingInput!.fullSizeImageURL!.absoluteString)
                    self.bascChanalpickImage.sendMessage(contentEditingInput!.fullSizeImageURL!.absoluteString)
                })
            } else{
                print("保存失败：", error!.localizedDescription)
            }
        }
        picker.dismiss(animated: true, completion: nil)

    }
   
}


