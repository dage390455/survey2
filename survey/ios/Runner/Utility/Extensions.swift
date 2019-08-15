//
//  Extensions.swift
//  SensoroCity
//
//  Created by David Yang on 2017/7/31.
//  Copyright © 2017年 Sensoro. All rights reserved.
//

import UIKit
import Photos
import CoreServices
import SENEZPlayer
import CityBase

extension PHAsset {
    var isGIF: Bool {
        let resource = PHAssetResource.assetResources(for: self).first!
        // 通过统一类型标识符(uniform type identifier) UTI 来判断
        let uti = resource.uniformTypeIdentifier as CFString
        return UTTypeConformsTo(uti, kUTTypeGIF)
    }
}

extension UIButton {
    
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let c = UIGraphicsGetCurrentContext() {
            c.setFillColor(color.cgColor)
            c.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        }
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }
}

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

extension Date {
    func string(with formatter: String) -> String {
        let df = DateFormatter()
        df.dateFormat = formatter
        return df.string(from: self)
    }
    
    static func getCurrentTimeZoneTime() -> Date {
        let timezone = TimeZone.current
        let interval = timezone.secondsFromGMT()
        let date = Date().addingTimeInterval(TimeInterval(interval))
        return date
    }
}

extension String {
    func dateFromString(with formatter: String) -> Date? {
        let df = DateFormatter()
        df.dateFormat = formatter
        return df.date(from: self)
    }
    
    func dateFromISO8601() -> Date? {
        let formatter = DateFormatter() ;
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'";
        return formatter.date(from: self);
    }
}

extension String {
    //电话号码
    var isPhoneNumber: Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", "^((\\+86){0,1}1[3|4|5|6|7|8|9](\\d){9}|(\\d{3,4}-){0,1}(\\d{7,8})(-\\d{1,4}){0,1})$");
        return predicate.evaluate(with: self)
    }
    var isContainInvalidChar: Bool {
        let regex = ".*[a-zA-Z0-9].*";
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex);
        return predicate.evaluate(with: self);
    }
    //统一社会信用代码
    var isEnterpriseCardID: Bool {
        
        let regex = "[0-9A-HJ-NPQRTUWXY]{2}\\d{6}[0-9A-HJ-NPQRTUWXY]{10}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex);
        return predicate.evaluate(with: self)
    }
    //邮箱
    var isEmail: Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    //身份证
    var isUserID: Bool {
        let regex = "(^\\d{15}$)|(^\\d{18}$)|(^\\d{17}(\\d|X|x)$)";
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    //IP地址
    var isIP: Bool {
        let regex = "((?:(?:25[0-5]|2[0-4]\\d|[01]?\\d?\\d)\\.){3}(?:25[0-5]|2[0-4]\\d|[01]?\\d?\\d))";
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    //车牌号
    var isCarID: Bool {
        let regex = "^[\\u4e00-\\u9fa5]{1}[a-hj-zA-HJ-Z]{1}[a-hj-zA-HJ-Z_0-9]{4}[a-hj-zA-HJ-Z_0-9_\\u4e00-\\u9fa5]$";
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    //企业注册号
    var isRegisterCode: Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", "^[0-9\\u4e00-\\u9fa5]{0,7}[0-9]{6,13}[u4e00-\\u9fa5]{0,1}$");
        return predicate.evaluate(with: self)
    }
    
    var md5: String {
        let str = cString(using: .utf8)
        let strLen = CC_LONG(lengthOfBytes(using: .utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        var hash = ""
        for i in 0..<digestLen {
            hash = hash.appendingFormat("%02x", result[i])
        }
        
        result.deallocate()
        return hash
    }
    
    var md5Data: Data {
        let str = cString(using: .utf8)
        let strLen = CC_LONG(lengthOfBytes(using: .utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        return Data(buffer:UnsafeMutableBufferPointer<CUnsignedChar>(start:result,count:digestLen));
    }
    
    func trimZero() -> String {
        
        if self == "0" {
            return self;
        }
        var string = self.trimmingCharacters(in: ["0"]);
        //第一个字符如果是".",则补"0"
        if string.first == "." {
            string.insert("0", at: string.startIndex)
        }
        
        if string.hasSuffix("."){
            let i = string.firstIndex(of: ".")!;
            string.remove(at: i);
        }
        return string;
    }
    
    func formatAttributeString(_ leftAttrs: [NSAttributedString.Key: Any]? = nil,_ rightAttrs: [NSAttributedString.Key: Any]? = nil) -> NSAttributedString{
        
        if self.contains(".") {
            let strArr = self.components(separatedBy: ["."]);
            let str = NSMutableAttributedString();
            let leftAttrStr = NSMutableAttributedString.init(string: strArr[0], attributes: leftAttrs);
            let rightAttrStr = NSMutableAttributedString.init(string: strArr[1], attributes: rightAttrs);
            let dotAttrStr = NSMutableAttributedString.init(string: ".", attributes: leftAttrs);
            str.append(leftAttrStr);
            str.append(dotAttrStr);
            str.append(rightAttrStr);
            return str;
        }else{
            return NSAttributedString.init(string: self, attributes: leftAttrs);
        }
    }
    
    func getSizeWithFont(_ font:UIFont, constrainedToSize size:CGSize) -> CGSize{
        
        if self.isEmpty == true { return CGSize.zero }
        let str = self as NSString
        let rect =  str.boundingRect(with: size, options: [NSStringDrawingOptions(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue)
            ], attributes: [NSAttributedString.Key.font: font], context: nil)
        return rect.size
    }
}

extension UIView {
    
    func takeSnapshot() -> UIImage {//截屏
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let rect = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height);
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        if radius == 0 {
            self.layer.mask = nil;
        }else{
            let mask = CAShapeLayer();
            mask.path = path.cgPath;
            mask.frame = rect;
            self.layer.mask = mask
        }
    }
    
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }
        
        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }
        
        return nil
    }
    
    //获取当前控制器
    func parentViewController() -> UIViewController? {
        
        var n = self.next
        
        while n != nil {
            
            if (n is UIViewController) {
                
                return n as? UIViewController
            }
            
            n = n?.next
        }
        
        return nil
    }
    
    // MARK:  UIViewAnimation
    class  func transformRotate(view: UIView, duration: TimeInterval, rotationAngle angle: CGFloat){
        UIView.animate(withDuration: duration) {
            view.transform = CGAffineTransform.init(rotationAngle: angle)
        }
    }
    
    class func transformTranslate(view: UIView, duration: TimeInterval, translationX tx: CGFloat, y ty: CGFloat){
        UIView.animate(withDuration: duration) {
            view.transform = CGAffineTransform.init(translationX: tx, y: ty)
        }
    }
    
    class func transformScale(view: UIView, duration: TimeInterval, scaleX sx: CGFloat, y sy: CGFloat){
        UIView.animate(withDuration: duration) {
            view.transform = CGAffineTransform.init(scaleX: sx, y: sy)
        }
    }
    
    func shadowView(color : UIColor,opacity : Float = 0.05, offset : CGSize = CGSize(width: 0, height: 4),blur : CGFloat = 3){
        return;
//        layer.shadowColor = color.cgColor;
//        layer.shadowOffset = offset;
//        layer.shadowOpacity = opacity;
//        layer.shadowRadius = blur;
//        layer.shadowPath = nil;
    }
}

extension UIViewController {
    func setStatusBarColor(color : UIColor) {
        if ResourceManager.isiPhoneXSeries {
            if let statusWin = UIApplication.shared.value(forKey: "statusBarWindow") as? UIView {
                if let statusBar = statusWin.value(forKey: "statusBar") as? UIView {
                    statusBar.backgroundColor = color;
                }
            }
        }
    }
    
    @objc func popAction() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func dismissAction() {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func mtaEnter(_ title : String){
        if let baiduStat = BaiduMobStat.default() {
            baiduStat.pageviewStart(withName: title);
        }
    }
    
    func mtaLeave(_ title : String){
        if let baiduStat = BaiduMobStat.default() {
            baiduStat.pageviewEnd(withName: title);
        }
    }
}

public extension UIImage {
    
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    func withRoundCorners(_ cornerRadius: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(origin: CGPoint.zero, size: size)
        let context = UIGraphicsGetCurrentContext()
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        
        context?.beginPath()
        context?.addPath(path.cgPath)
        context?.closePath()
        context?.clip()
        
        draw(at: CGPoint.zero)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return image;
    }

    func transform(withNewColor color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.clip(to: rect, mask: cgImage!)
        
        color.setFill()
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    convenience init(view: UIView, scale : CGFloat) {

        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, scale)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        defer {UIGraphicsEndImageContext()};
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        self.init(cgImage: (image?.cgImage)!)
        
    }
}

/// 水印添加
extension UIImage {
    
    /// Add WaterMarkingImage
    ///
    /// - Parameters:
    ///   - image: the image that painted on
    ///   - waterImageName: waterImage
    /// - Returns: the warterMarked image
    static func waterMarkingImage(image : UIImage, with waterImage: UIImage) -> UIImage?{
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        let waterImageX = image.size.width * 0.78
        let waterImageY = image.size.height - image.size.width / 5.4
        let waterImageW = image.size.width * 0.2
        let waterImageH = image.size.width * 0.075
        waterImage.draw(in: CGRect(x: waterImageX, y: waterImageY, width: waterImageW, height: waterImageH))
        
        let waterMarkingImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return waterMarkingImage
    }
    
    /// Add WaterMarking Text
    ///
    /// - Parameters:
    ///   - image: the image that painted on
    ///   - text: the text that needs painted
    /// - Returns: the waterMarked image
    static func waterMarkingImage(image : UIImage, with text: String) -> UIImage?{
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        let str = text as NSString
        let pointY = image.size.height - image.size.width * 0.1
        let point = CGPoint(x: image.size.width * 0.78, y: pointY)
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.8),
                          NSAttributedString.Key.font           : UIFont.systemFont(ofSize: image.size.width / 25.0)
            ] as [NSAttributedString.Key : Any]
        str.draw(at: point, withAttributes: attributes)
        
        let waterMarkingImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return waterMarkingImage
    }
}

extension UIColor {
    
    static var randomColor: UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}

extension UISearchBar {
    
    private func getViewElement<T>(type: T.Type) -> T? {
        
        let svs = subviews.flatMap { $0.subviews }
        guard let element = (svs.filter { $0 is T }).first as? T else { return nil }
        return element
    }
    
    func getSearchBarTextField() -> UITextField? {
        
        return getViewElement(type: UITextField.self)
    }
    
    func setTextColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            textField.textColor = color
        }
    }
    
    func setTextFieldColor(color: UIColor) {
        
        if let textField = getViewElement(type: UITextField.self) {
            switch searchBarStyle {
            case .minimal:
                textField.layer.backgroundColor = color.cgColor
                textField.layer.cornerRadius = 6
                
            case .prominent, .default:
                textField.backgroundColor = color
            @unknown default:
                print("Unknown searchBarStyle")
            }
        }
    }
    
    func setPlaceholderTextColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            textField.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor: color])
        }
    }
    
    func setTextFieldClearButtonColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            
            let button = textField.value(forKey: "clearButton") as! UIButton
            if let image = button.imageView?.image {
                button.setImage(image.transform(withNewColor: color), for: .normal)
            }
        }
    }
    
    func setSearchImageColor(color: UIColor) {
        
        if let imageView = getSearchBarTextField()?.leftView as? UIImageView {
            imageView.image = imageView.image?.transform(withNewColor: color)
        }
    }
    
    func suitAppearance(){
        setSearchFieldBackgroundImage(UIImage(named: "search_back"), for: .normal);//设定背景
        setPositionAdjustment(UIOffset(horizontal: 5, vertical: 1), for: .search);//调整search图标的位置。
        setImage(UIImage(named: "searchbar_clear"), for: .clear, state: .normal);//设定清除图标
        setPositionAdjustment(UIOffset(horizontal: -7, vertical: 0), for: .clear);//调整清除图标位置
        setImage(UIImage(named: "ic_search"), for: .search, state: .normal);//设定搜索图标
        setPositionAdjustment(UIOffset(horizontal: 3, vertical: 0), for: .search);//调整搜索图标位置

        tintColor = ResourceManager.LIGHT_TEXT_COLOR;
        if let textField = getSearchBarTextField() {
            textField.font = ResourceManager.SMALL_FONT;
        }
        setPlaceholderTextColor(color: ResourceManager.PLACEHOLDER_TEXT_COLOR);
//        setSearchImageColor(color: ResourceManager.NORMAL_TEXT_COLOR);
        setTextColor(color: ResourceManager.NORMAL_TEXT_COLOR);
        backgroundColor = UIColor.white;
        searchTextPositionAdjustment = UIOffset.init(horizontal: 8, vertical: 1.0);
    }
}

extension UIWindow {
    
    func visibleViewController() -> UIViewController? {
        if let rootViewController : UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
        }
        return nil
    }
    class func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
        if vc is UINavigationController {
            let navigationController = vc as! UINavigationController
            return UIWindow.getVisibleViewControllerFrom( vc: navigationController.visibleViewController!);
            
        } else if vc is UITabBarController {
            
            let tabBarController = vc as! UITabBarController
            return UIWindow.getVisibleViewControllerFrom(vc: tabBarController.selectedViewController!)
//        } else if vc is MenuRootController {
//            let menuController = vc as! MenuRootController;
//            return UIWindow.getVisibleViewControllerFrom(vc: menuController.contentViewController)
        } else {
            
            if let presentedViewController = vc.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(vc : presentedViewController)
            } else {
                return vc;
            }
        }
    }
}

extension UITableView {
    func footerShadowView(height : CGFloat) -> UIView {
        let shadowView = UIView(frame: CGRect(x: 0, y: 0, width: kScreen_Width(), height: height));
        return shadowView;
        
//        let gradient = CAGradientLayer()
//        gradient.frame.size = CGSize(width: kScreen_Width(), height: height)
//        let stopColor = UIColorFromRGB(0xFAFAFA).cgColor;
//        let startColor = ResourceManager.BACK_COLOR.cgColor
//        gradient.colors = [stopColor,startColor]
//        gradient.locations = [0.0,0.8]
//        shadowView.layer.addSublayer(gradient)
//        return shadowView;
    }
}

//Encrypt and Decrypt
extension String {
    func versionIsNewerThan(version : String) -> Bool {
        return compare(version,options: .numeric) == .orderedDescending;
    }

    func aesEncrypt(key:String, iv:String, options:Int = kCCOptionPKCS7Padding) -> String? {
        if let keyData = key.data(using: String.Encoding.utf8) as NSData?,
            let data = self.data(using: String.Encoding.utf8) as NSData?,
            let cryptData  = NSMutableData(length: Int((data.length)) + kCCBlockSizeAES128) {
            
            let keyLength              = size_t(kCCKeySizeAES128)
            let operation: CCOperation = UInt32(kCCEncrypt)
            let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmAES128)
            let options:   CCOptions   = UInt32(options)
            
            var numBytesEncrypted :size_t = 0
            
            let cryptStatus = CCCrypt(operation,
                                      algoritm,
                                      options,
                                      keyData.bytes, keyLength,
                                      iv,
                                      data.bytes, data.length,
                                      cryptData.mutableBytes, cryptData.length,
                                      &numBytesEncrypted)
            
            if UInt32(cryptStatus) == UInt32(kCCSuccess) {
                cryptData.length = Int(numBytesEncrypted)
                let base64cryptString = cryptData.base64EncodedString(options: .lineLength64Characters)
                return base64cryptString
            }
            else {
                return nil
            }
        }
        return nil
    }
    
    func aesDecrypt(key:String, iv:String, options:Int = kCCOptionPKCS7Padding) -> String? {
        if let keyData = key.data(using: String.Encoding.utf8) as NSData?,
            let data = NSData(base64Encoded: self, options: .ignoreUnknownCharacters),
            let cryptData    = NSMutableData(length: Int((data.length)) + kCCBlockSizeAES128) {
            
            let keyLength              = size_t(kCCKeySizeAES128)
            let operation: CCOperation = UInt32(kCCDecrypt)
            let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmAES128)
            let options:   CCOptions   = UInt32(options)
            
            var numBytesEncrypted :size_t = 0
            
            let cryptStatus = CCCrypt(operation,
                                      algoritm,
                                      options,
                                      keyData.bytes, keyLength,
                                      iv,
                                      data.bytes, data.length,
                                      cryptData.mutableBytes, cryptData.length,
                                      &numBytesEncrypted)
            
            if UInt32(cryptStatus) == UInt32(kCCSuccess) {
                cryptData.length = Int(numBytesEncrypted)
                let unencryptedMessage = String(data: cryptData as Data, encoding:String.Encoding.utf8)
                return unencryptedMessage
            }
            else {
                return nil
            }
        }
        return nil
    }
    
    func aesDataEncrypt(key:NSData, iv:NSData?, options:Int = kCCOptionPKCS7Padding|kCCModeECB) -> String? {
        if  let data = self.data(using: String.Encoding.utf8) as NSData?,
            let cryptData  = NSMutableData(length: Int((data.length)) + kCCBlockSizeAES128) {
            
            let keyLength              = size_t(kCCKeySizeAES128)
            let operation: CCOperation = UInt32(kCCEncrypt)
            let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmAES128)
            let options:   CCOptions   = UInt32(options)
            
            var numBytesEncrypted :size_t = 0
            
            let cryptStatus = CCCrypt(operation,
                                      algoritm,
                                      options,
                                      key.bytes, keyLength,
                                      iv?.bytes,
                                      data.bytes, data.length,
                                      cryptData.mutableBytes, cryptData.length,
                                      &numBytesEncrypted)
            
            if UInt32(cryptStatus) == UInt32(kCCSuccess) {
                cryptData.length = Int(numBytesEncrypted)
                let base64cryptString = cryptData.base64EncodedString(options: .lineLength64Characters)
                return base64cryptString
            }
            else {
                return nil
            }
        }
        return nil
    }
    
    /*
     *去掉首尾空格
     */
    var removeHeadAndTailSpace:String {
        let whitespace = NSCharacterSet.whitespaces
        return self.trimmingCharacters(in: whitespace)
    }
    /*
     *去掉首尾空格 包括后面的换行 \n
     */
    var removeHeadAndTailSpacePro:String {
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        return self.trimmingCharacters(in: whitespace)
    }
    /*
     *去掉所有空格
     */
    var removeAllSapce: String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    /*
     *去掉首尾空格 后 指定开头空格数
     */
    func beginSpaceNum(num: Int) -> String {
        var beginSpace = ""
        for _ in 0..<num {
            beginSpace += " "
        }
        return beginSpace + self.removeHeadAndTailSpacePro
    }
}

extension FileManager {
    class func documentsDir() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
    
    class func cachesDir() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
}

//extension UITabBar{
//    
//    open override func layoutSubviews() {
//        super.layoutSubviews()
//        if let UITabBarButtonClass = NSClassFromString("UITabBarButton") as? NSObject.Type{
//            let subItems = self.subviews.filter({return $0.isKind(of: UITabBarButtonClass)})
//            if subItems.count > 0{
//                let tmpWidth = UIScreen.main.bounds.width / CGFloat(subItems.count)
//                for (index,item) in subItems.enumerated(){
//                    item.frame = CGRect(x: CGFloat(index) * tmpWidth, y: 0, width: tmpWidth, height: item.bounds.height)
//                }
//            }
//        }
//    }
//    
//    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        if let view:UITabBar = super.hitTest(point, with: event) as? UITabBar{
//            for item in view.subviews{
//                if point.x >= item.frame.origin.x  && point.x <= item.frame.origin.x + item.frame.size.width{
//                    return item
//                }
//            }
//        }
//        return super.hitTest(point, with: event)
//    }
//}

extension CLLocationCoordinate2D {
    private struct JZConstant {
        static let A = 6378245.0
        static let EE = 0.00669342162296594323
    }
    
    func isOutOfChina() -> Bool {
        return (longitude < 72.004 || longitude > 137.8347 || latitude < 0.8293 || latitude > 55.8271 || false);
    }
    
    private func gcj02Offset() -> CLLocationCoordinate2D {
        let x = self.longitude - 105.0
        let y = self.latitude - 35.0
        let latitude = (-100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x))) +
            ((20.0 * sin(6.0 * x * .pi) + 20.0 * sin(2.0 * x * .pi)) * 2.0 / 3.0) +
            ((20.0 * sin(y * .pi) + 40.0 * sin(y / 3.0 * .pi)) * 2.0 / 3.0) +
            ((160.0 * sin(y / 12.0 * .pi) + 320 * sin(y * .pi / 30.0)) * 2.0 / 3.0)
        let longitude = (300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x))) +
            ((20.0 * sin(6.0 * x * .pi) + 20.0 * sin(2.0 * x * .pi)) * 2.0 / 3.0) +
            ((20.0 * sin(x * .pi) + 40.0 * sin(x / 3.0 * .pi)) * 2.0 / 3.0) +
            ((150.0 * sin(x / 12.0 * .pi) + 300.0 * sin(x / 30.0 * .pi)) * 2.0 / 3.0)
        let radLat = 1 - self.latitude / 180.0 * .pi;
        var magic = sin(radLat);
        magic = 1 - JZConstant.EE * magic * magic
        let sqrtMagic = sqrt(magic);
        let dLat = (latitude * 180.0) / ((JZConstant.A * (1 - JZConstant.EE)) / (magic * sqrtMagic) * .pi);
        let dLon = (longitude * 180.0) / (JZConstant.A / sqrtMagic * cos(radLat) * .pi);
        return CLLocationCoordinate2DMake(dLat, dLon);
    }
    
    func WGS84toBD09() -> CLLocationCoordinate2D {
        let gcj02Point = WGS84toGCJ02();
        return gcj02Point.GCJ02toBD09();
    }
    
    func WGS84toGCJ02() -> CLLocationCoordinate2D {
        
        if isOutOfChina() {
            return self;
        }else{
            let offsetPoint = gcj02Offset();
            return CLLocationCoordinate2DMake(latitude + offsetPoint.latitude, longitude + offsetPoint.longitude);
        }
    }

    func BD09toWGS84() -> CLLocationCoordinate2D {
        let gcj = BD09toGCJ02();
        return gcj.GCJ02toWGS84();
    }
    
    func GCJ02toWGS84() -> CLLocationCoordinate2D {
        if isOutOfChina() {
            return self;
        }else{
            let mgPoint = WGS84toGCJ02();
            return CLLocationCoordinate2DMake(latitude * 2 - mgPoint.latitude,longitude * 2 - mgPoint.longitude);
        }
    }
    
    func GCJ02toBD09() -> CLLocationCoordinate2D {
        let x = longitude
        let y = latitude
        let z = sqrt(x * x + y * y) + 0.00002 * sin(y * .pi);
        let theta = atan2(y, x) + 0.000003 * cos(x * .pi);
        return CLLocationCoordinate2DMake(z * sin(theta) + 0.006, z * cos(theta) + 0.0065);
    }
    
    func BD09toGCJ02() -> CLLocationCoordinate2D {
        let x = longitude - 0.0065
        let y = latitude - 0.006
        let z = sqrt(x * x + y * y) - 0.00002 * sin(y * .pi);
        let theta = atan2(y, x) - 0.000003 * cos(x * .pi);
        return CLLocationCoordinate2DMake(z * sin(theta), z * cos(theta))
    }
}

extension CLPlacemark {
    func shortAdress() -> String {
        var ret = "";
        
        if let thoroughfare = self.thoroughfare {
            if let sub = self.subThoroughfare {
                ret = thoroughfare + sub;
            } else {
                ret = thoroughfare;
            }
        }
        if ret.isEmpty,let sub = self.subLocality {
            ret = sub;
        }
        if ret.isEmpty,let city = self.locality {
            ret = city;
        }
        
        if ret.isEmpty,let sub = self.subAdministrativeArea {
            ret = sub;
        }
        
        if ret.isEmpty,let state = self.administrativeArea {
            ret = state;
        }
        if ret.isEmpty { ret = localString("LOCATION_DEFINED");}
        
        return ret;
    }
}
