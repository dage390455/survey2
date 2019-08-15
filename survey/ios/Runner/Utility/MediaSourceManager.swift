//
//  MediaSourceManager.swift
//  SensoroCity
//
//  Created by 防神 on 2018/10/12.
//  Copyright © 2018年 Sensoro. All rights reserved.
//

import Foundation
import UIKit
import Photos
import MobileCoreServices


/**
 * 用户相册未授权，Dialog提示
 */

func showNoPermissionDailog(controller: UIViewController){
    let alert = UIAlertController.init(title: nil, message: localString("PHOTO_ALBUM_AUTHORIZED_TIP"), preferredStyle: .alert)
    alert.addAction(UIAlertAction.init(title: localString("OK_TITLE"), style: .default, handler: nil))
    controller.present(alert, animated: true, completion: nil)
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
            if let waterImage = addWaterMarkInImage(result) {//添加水印
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

func presentImagePickerContrller(controller: UIViewController) {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .camera // 调用摄像头
    imagePicker.cameraDevice = .rear // 后置摄像头拍照
    imagePicker.cameraCaptureMode = .photo // 拍照
    imagePicker.delegate = controller as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
    imagePicker.mediaTypes = [kUTTypeImage as String]
    
    imagePicker.modalPresentationStyle = .popover
    controller.present(imagePicker, animated: true, completion: nil);
}

// 拍照获取
func selectByCamera(controller: UIViewController){
    
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
                    presentImagePickerContrller(controller: controller)
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
func showLocalPhotoGallery(controller: UIViewController, selectNum: Int, maxNum: Int ){
    let picker = PhotoPickerController(type: PageType.RecentAlbum)
    picker.imageSelectDelegate = controller as? PhotoPickerControllerDelegate
    picker.modalPresentationStyle = .popover
    PhotoPickerController.imageMaxSelectedNum = maxNum
    PhotoPickerController.alreadySelectedImageNum = selectNum
    controller.present(picker, animated: true, completion: nil);
}

/**
 * 从相册中选择图片
 */
func selectFromPhoto(controller: UIViewController, maxNum: Int, selectNum: Int){
    PHPhotoLibrary.requestAuthorization {[unowned controller] (status) -> Void in
        DispatchQueue.main.async {
            switch status {
            case .authorized:
                showLocalPhotoGallery(controller: controller, selectNum: selectNum, maxNum: maxNum)
                break
            default:
                showNoPermissionDailog(controller: controller)
                break
            }
        }
    }
}
