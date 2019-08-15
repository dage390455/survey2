//
//  MediaManager.swift
//  SensoroCity
//
//  Created by 防神 on 2018/10/12.
//  Copyright © 2018年 Sensoro. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices
import CityBase

typealias MediaClosure = (_ ret: Bool, _ images: [String]?, _ videos: [[String: String]]?) -> Void

class MediaManager: NSObject {
    
    static let shared = MediaManager()
    let uploadMannager = QNUploadManager.init()
    var dispatchGroup  : DispatchGroup?
    var request        : NetworkRequest? = nil;
    var uploadProgress : Int = 0
    var selectModel    = [PHAsset]()
    var images         = [String]()
    var indexKey       = [String : Int]()
    var videos         = [[String : Any]]()
    var videosURL      = [[String : String]]()
    var totalCount     = 0
    weak var controller : UIViewController?
    var pickCompletion : (([PHAsset], [UIImage]) -> Void)?//拍照和从相册选取后回调
    var videoCompletion: (([String: Any]) -> Void)? //拍摄视频后回调
    
    func uploadMediaSource(selectModel: [PHAsset], videos: [[String: Any]], callback: @escaping MediaClosure) {
        
        if selectModel.isEmpty && videos.isEmpty {
            return
        }
        self.totalCount = selectModel.count + videos.count
        self.selectModel = selectModel
        self.videos = videos
        self.images = [String].init(repeating: "", count: self.selectModel.count)
        self.uploadProgress = 0
        
        self.videosURL.removeAll()
        
        SVProgressHUD.showProgress(-1, status: localString("LOADING_DATA"))
        NetworkManager.shared.getQiniuTokenInfo { [weak self] (result, ret, error) in
            guard let self = self else {return;}
            if ret {
                let uptoken = result!["uptoken"].stringValue
                let domain  = result!["domain"].stringValue
                self.dispatchGroup = DispatchGroup()
                 //上传视频和缩略图
                for item in self.videos {
                    if let videoPath = item["videoUrl"] as? URL {
                        self.dispatchGroup?.enter()
                        DispatchQueue.global().async {
                            var videoDic = [String: String]()
                            
                            let group = DispatchGroup()
                            group.enter()
                            
                            self.uploadVideo(path: videoPath, token: uptoken, domain: domain, callback: { (videoURL) in
                                videoDic["videoUrl"] = videoURL
                                group.leave()
                            })
                            if let thumb = item["thumb"] as? UIImage {
                                group.enter()
                                self.uploadThumb(token: uptoken, domain: domain, thumb: thumb, callback: { (thumbURL) in
                                    videoDic["thumbUrl"] = thumbURL
                                    group.leave()
                                })
                            }
                            
                            group.notify(queue: DispatchQueue.main, execute: { [weak self] in
                                guard let self = self else {return;}
                                if let thumbURL = videoDic["thumbUrl"], thumbURL.isEmpty == false, let videoURL = videoDic["videoUrl"], videoURL.isEmpty == false {
                                    self.uploadProgress += 1
                                    var str = "\(self.uploadProgress)" + "\\"
                                    str = str + "\(self.totalCount )"
                                    SVProgressHUD.show(withStatus: str)
                                    self.videosURL.append(videoDic)
                                }
                                
                                self.dispatchGroup?.leave()
                            })
                        }
                    }
                }
               
                //上传图片
                for index in 0 ..< self.selectModel.count {
                    self.dispatchGroup?.enter()
                    DispatchQueue.global().async {
                        self.transferModel(asset: self.selectModel[index], token: uptoken, domain: domain, subIndex: index)
                    }
                }
            
                self.dispatchGroup?.notify(queue: DispatchQueue.main, execute: {[weak self] in
                    let imgURL = self?.images.filter({$0 != ""})
                    if let imgCount = imgURL?.count, let videoCount = self?.videosURL.count {
                        if self?.totalCount == (imgCount + videoCount) {
                            callback(true, self?.images,self?.videosURL)
                        }else{
                            callback(false, nil,nil)
                        }
                    }else{
                        callback(false, nil,nil)
                    }
                    SVProgressHUD.dismiss();
                })
            }else{
                callback(false, nil,nil)
                SVProgressHUD.showError(withStatus: error.errMsg)
                return
            }
        }
    }
    
    func uploadVideo(path: URL, token: String, domain: String, callback: @escaping (String) -> Void){
        let array = path.absoluteString.components(separatedBy: "/")
        let fileName = array.last ?? ""
        let md5Str = (fileName + getSystemTime()).md5
        var videoData : Data?
        do{
            videoData = try Data(contentsOf: path)
        }catch{
            callback("")
            let errorMsg = localString("VIDE_DATA_GOT_FAILED")
            SVProgressHUD.showError(withStatus: errorMsg)
            return
        }
        self.uploadMannager?.put(videoData, key: md5Str, token: token, complete: {(info, key, resp) in
            var videoURL = ""
            if let response = resp {
                let videoKey = response["key"] as! String
                videoURL = domain + videoKey
            }else{
                let errorMsg = localString("VIDEO_UPLOAD_FAILED")
                SVProgressHUD.showError(withStatus: errorMsg)
            }
            callback(videoURL)
            }, option: nil)
    }
    
    func uploadThumb(token: String, domain: String, thumb: UIImage, callback: @escaping (String) -> Void) {
        let md5Str = getSystemTime().md5
        compressImage(image: thumb) { (data) in
            if data != nil {
                self.uploadMannager?.put(data!, key: md5Str, token: token, complete: {(info, key, resp) in
                    var thumbURL = ""
                    if let response = resp {
                        let thumbKey = response["key"] as! String
                        thumbURL = domain + thumbKey
                    }else{
                        let errorMsg = localString("THUMBNAIL_UPLOAD_FAILED")
                        SVProgressHUD.showError(withStatus: errorMsg)
                    }
                    callback(thumbURL)
                }, option: nil)
            }else{
                callback("")
                SVProgressHUD.showError(withStatus: localString("THUMBNAIL_COMPRESS_FAILED"))
            }
        }
    }
    
    func uploadImage(data: Data, filename: String, token: String, domain: String, subIndex: Int) {
        let array = filename.components(separatedBy: ".")
        let fileName = array[0]
        let md5Str = (fileName + getSystemTime()).md5
        
        self.uploadMannager?.put(data, key: md5Str, token: token, complete: { [weak self] (info, key, resp) in
            //进度圈
            if let response = resp {
                self?.uploadProgress += 1
                var str = "\(self?.uploadProgress ?? 0)" + "\\"
                str += "\(self?.totalCount ?? 0)"
                SVProgressHUD.show(withStatus: str)
                
                let imgKey = response["key"] as! String
                let imgURL = domain + imgKey
                self?.images[subIndex] = imgURL
                debugPrint(imgURL)
            }else{
                let errorMsg = AlertConfimConst.UPLOAD_ERROR.replacingOccurrences(of: "#", with: String(subIndex))
                SVProgressHUD.showError(withStatus: errorMsg)
            }
            self?.dispatchGroup?.leave()
            }, option: nil)
    }
    
    /// 上传图片
    func transferModel(asset: PHAsset, token: String, domain: String, subIndex: Int) -> Void {
        let imageRequestOptins = PHImageRequestOptions.init()
        imageRequestOptins.deliveryMode = .fastFormat
        imageRequestOptins.resizeMode = .fast
        imageRequestOptins.isSynchronous = true
        PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.aspectFit, options: imageRequestOptins, resultHandler: { (image, info) -> Void in
            if image != nil {
                let name = asset.value(forKey: "filename") as! String
                //等比例压缩图片
                self.compressImage(image: image!, completion: { (data) in
                    if data != nil{
                        self.uploadImage(data: data!, filename: name, token: token, domain: domain, subIndex: subIndex)
                    }else{
                        let errorMsg = AlertConfimConst.UPLOAD_ERROR.replacingOccurrences(of: "#", with: String(subIndex))
                        SVProgressHUD.showError(withStatus: errorMsg)
                    }
                })
            }else{
                let errorMsg = AlertConfimConst.UPLOAD_ERROR.replacingOccurrences(of: "#", with: String(subIndex))
                SVProgressHUD.showError(withStatus: errorMsg)
            }
        })
    }
    
    /**
     * 用户相册未授权，Dialog提示
     */
    
    func showNoPermissionDailog(controller: UIViewController?){
        let alert = UIAlertController.init(title: nil, message: localString("PHOTO_ALBUM_AUTHORIZED_TIP"), preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: localString("OK_TITLE"), style: .default, handler: nil))
        controller?.present(alert, animated: true, completion: nil)
    }
    
    func compressImage(image: UIImage, completion: @escaping (Data?) -> Void) -> Void{
        var size = CGSize.zero
        let widthScale = (1024/image.scale)/image.size.width
        let heightScale = (1024/image.scale)/image.size.height
        if widthScale < heightScale{
            size = CGSize(width: 1024/image.scale, height: image.size.height * widthScale)
        }else{
            size = CGSize(width: image.size.width * heightScale, height: 1024/image.scale)
        }
        DispatchQueue.global().async {
            var resultImage : UIImage? = nil
            UIGraphicsBeginImageContextWithOptions(size, false, image.scale)
            image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let result = resultImage {
                if let waterImage = self.addWaterMarkInImage(result) {//添加水印
                    completion(waterImage.jpegData(compressionQuality: 0.3))
                }else{
                    completion(nil)
                }
            }else{
                completion(nil)
            }
        }
    }
    
    func addWaterMarkInImage(_ image: UIImage) -> UIImage? {
        
        if let logo = UIImage(named: "watermark") {
            let currentDateStr = Date().string(with: "yyyy.MM.dd")
            if let imageMark = UIImage.waterMarkingImage(image: image, with: logo) {
                if let textMark = UIImage.waterMarkingImage(image: imageMark, with: currentDateStr) {
                    return textMark
                }
            }
        }
        return nil
    }
}

extension MediaManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //推出相机控制器
    func presentImagePickerContrller(controller: UIViewController?) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera // 调用摄像头
        imagePicker.cameraDevice = .rear // 后置摄像头拍照
        imagePicker.cameraCaptureMode = .photo // 拍照
        imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.mediaTypes = [kUTTypeImage as String]
        
        imagePicker.modalPresentationStyle = .popover
        controller?.present(imagePicker, animated: true, completion: nil);
    }
    
    // 拍照获取
    func selectByCamera(controller: UIViewController?){
        self.controller = controller;
        if AVCaptureDevice.default(for: .video) != nil {
            let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
            if authStatus == .restricted {
                SVProgressHUD.showError(withStatus: localString("CAMERA_AUTHORIZED_TIP"))
            }else if authStatus == .denied {
                SVProgressHUD.showError(withStatus: localString("CAMERA_AUTHORIZED_GUIDE_TIP"))
            }else if authStatus == .authorized{
                presentImagePickerContrller(controller: controller)
            }else if authStatus == .notDetermined {
                AVCaptureDevice.requestAccess(for: .video) { (granted) in
                    if granted {
                        self.presentImagePickerContrller(controller: controller)
                    }
                }
            }
        }else{
            SVProgressHUD.showError(withStatus: localString("CAMERA_UNFIND_TIP"))
        }
    }
    
    /**
     * 打开本地相册列表
     */
    func showLocalPhotoGallery(controller: UIViewController?, selectNum: Int, maxNum: Int ){
        let picker = PhotoPickerController(type: PageType.RecentAlbum)
        picker.imageSelectDelegate = controller as? PhotoPickerControllerDelegate
        picker.modalPresentationStyle = .popover
        PhotoPickerController.imageMaxSelectedNum = maxNum
        PhotoPickerController.alreadySelectedImageNum = selectNum
        controller?.present(picker, animated: true, completion: nil);
    }
    
    /**
     * 从相册中选择图片
     */
    func selectFromPhoto(controller: UIViewController?, maxNum: Int, selectNum: Int){
        PHPhotoLibrary.requestAuthorization {(status) -> Void in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    self.showLocalPhotoGallery(controller: controller, selectNum: selectNum, maxNum: maxNum)
                    break
                default:
                    self.showNoPermissionDailog(controller: controller)
                    break
                }
            }
        }
    }
    
    // 退出拍照
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // 完成拍照
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let mediaType = info[.mediaType] as! String;
        if mediaType == kUTTypeImage as String { // 图片类型
            var image: UIImage? = nil
            var localId: String? = ""
            
            if picker.isEditing { // 拍照图片运行编辑，则优先尝试从编辑后的类型中获取图片
                image = info[.editedImage] as? UIImage
            }else{
                image = info[.originalImage] as? UIImage
            }
            PHPhotoLibrary.requestAuthorization {[unowned self](status) -> Void in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized:
                        // 存入相册
                        if image != nil {
                            PHPhotoLibrary.shared().performChanges({
                                let result = PHAssetChangeRequest.creationRequestForAsset(from: image!)
                                let assetPlaceholder = result.placeholderForCreatedAsset
                                localId = assetPlaceholder?.localIdentifier
                            }, completionHandler: { (success, error) in
                                if success && localId != nil {
                                    let assetResult = PHAsset.fetchAssets(withLocalIdentifiers: [localId!], options: nil)
                                    let asset = assetResult[0]
                                    DispatchQueue.main.async {
                                        if let closure = self.pickCompletion {
                                            closure([asset], [image!]);
                                        }
                                    }
                                }
                            })
                        }
                        break
                    default:
                        MediaManager.shared.showNoPermissionDailog(controller: MediaManager.shared.controller);
                        break
                    }
                }
            }
        }
    }
    
    // 页面底部 stylesheet
    @objc func eventAddImage() {
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // change the style sheet text color
        alert.view.tintColor = UIColor.black
        
        let actionCancel = UIAlertAction.init(title: localString("CANCEL_TITLE"), style: .cancel, handler: nil)
        
        let actionCamera = UIAlertAction.init(title: localString("PHOTO"), style: .default) { (UIAlertAction) -> Void in
            self.selectByCamera(controller: MediaManager.shared.controller)
        }
        let actionPhoto = UIAlertAction.init(title: localString("PHOTO_ALBUM"), style: .default) { (UIAlertAction) -> Void in
            self.selectFromPhoto(controller: MediaManager.shared.controller, maxNum: 9, selectNum: self.totalCount)
        }
        let actionVideo = UIAlertAction.init(title: localString("SHOOT_VIDEO"), style: .default) { (UIAletAction) -> Void in
            self.takeVideo()
        }
        alert.addAction(actionCancel)
        alert.addAction(actionCamera)
        alert.addAction(actionPhoto)
        alert.addAction(actionVideo)
        MediaManager.shared.controller?.present(alert, animated: true, completion: nil)
    }
    
    //拍摄视频
    func takeVideo() {
        let cameracontroller = XFCameraController.default()
        cameracontroller?.shootCompletionBlock = {[weak cameracontroller] (videoUrl, videoTimeLength, thumbImage, error) in
            cameracontroller?.dismissAction()
            
            var videoInfo = [String: Any]()
            if thumbImage != nil {
                videoInfo["thumb"] = thumbImage!
            }
            if videoUrl != nil {
                videoInfo["videoUrl"] = videoUrl
            }
            self.videos.append(videoInfo)
            if error != nil {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
            if let videoClosure = self.videoCompletion {
                videoClosure(videoInfo);//视频回调
            }
        }
        MediaManager.shared.controller?.present(cameracontroller!, animated: true, completion: nil)
    }
    
}
