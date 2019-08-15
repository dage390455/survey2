//
//  AuthorizationManager.swift
//  SensoroCity
//
//  Created by David Yang on 2018/12/5.
//  Copyright © 2018 Sensoro. All rights reserved.
//

import UIKit
import UserNotifications
import Contacts

class AuthorizationManager: NSObject {
    static let shared = AuthorizationManager();
    
    var addingContact = false;//标记是否正在检查，这里是因为在iOS11中，由于Alert出现，会导致调用两次BecomeActive。
    
    //用于记录现在弹出的对话框的状态，如果一个对话框弹出过，则不再弹出此对话框。
    var alertStatus = [String:Bool]();
    
    private override init() {
        super.init();
    }
    
    deinit {
        stopWatching();
    }
    
    func startWatching() {
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive(_:)),
                                               name: UIApplication.NSNotification.Name.UIApplicationDidBecomeActive, object: nil);
    }
    
    func stopWatching() -> Void {
        NotificationCenter.default.removeObserver(self);
    }
    
    @objc func appDidBecomeActive(_ notification : NSNotification){
        //如果不加入 Dispatch 处理，在部分机型上，已知 iPhone 5C 上，即使用户选择了允许，收到的却是拒绝。
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
            guard let self = self else {return;}
            self.checkNotificationSetting();
            self.checkContactsSetting();
        }
    }

    func showAlertForEnableTip(titleID : String, messageID : String) -> Void {
        //正在显示此对话框
        if alertStatus[messageID] != nil {return;}
        
        //记录此消息相关的对话框正在显示
        alertStatus[messageID] = true;
        
        let alert = UIAlertController(title: localString(titleID),
                                      message: localString(messageID),
                                      preferredStyle: .alert);
        alert.loadViewIfNeeded();
        
        let untilNotNear = UIAlertAction(title : localString("CANCEL_TITLE"),
                                         style : .default,
                                         handler:{ action in
                                            alert.dismiss(animated: true, completion: nil);
                                            self.alertStatus.removeValue(forKey: messageID);
        });
        alert.addAction(untilNotNear);
        
        let untilSuccess = UIAlertAction(title : localString("GOTO_SETTING"),
                                         style : .default,
                                         handler:
            { action in
                self.alertStatus.removeValue(forKey: messageID);
                UIApplication.shared.open( URL(string: UIApplication.openSettingsURLString)!,
                                           options: [:],completionHandler: nil);
        });
        alert.addAction(untilSuccess);
        
        if let root = UIApplication.shared.keyWindow?.visibleViewController() {
            //必须在主线程队列中进行显示，否则在显示键盘时，会出现Crash的问题。
            DispatchQueue.main.async {
                root.present(alert, animated: true, completion: nil);
            }
        }
    }
}

// MARK: 检查用方法实现
extension AuthorizationManager {
    func checkContactsSetting() -> Void {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .notDetermined:
            CNContactStore().requestAccess(for: .contacts) { (isRight, error) in
                if isRight{
                    //授权成功
                    let _ = self.Inquire(telephoneNumbers: [localString("TELEPHONE"),localString("TELEPHONE_TWO")], givenName: localString("TELEPHONE_TITLE"))
                }else{
                    //不做任何动作，程序再次被激活时，会进行检查。
                    print("授权失败");
                }
            }
            return;
        case .denied,.restricted:
            showAlertForEnableTip(titleID: "ENABLE_ACCESS_CONTACT_TIP_TITLE",messageID: "ENABLE_ACCESS_CONTACT_TIP");
            return;
        case .authorized:
            let _ = Inquire(telephoneNumbers: [localString("TELEPHONE"),localString("TELEPHONE_TWO")], givenName: localString("TELEPHONE_TITLE"))
            
            return;
        @unknown default:
            print("未知授权状态");
        }
    }
    
    //查询原有联系人是否存在 -- 存在编辑
    private func Inquire(telephoneNumbers:Array<String>, givenName : String)->Bool{
        if telephoneNumbers.count == 0{
            return false;
        }
        if givenName.isEmpty{
            return false;
        }
        let store = CNContactStore();
        let keys = [CNContactGivenNameKey,CNContactFamilyNameKey,CNContactNicknameKey,CNContactPhoneNumbersKey];
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        var Mcontact : CNMutableContact? = nil;
        //遍历所有联系人
        do {
            try store.enumerateContacts(with: request, usingBlock: { (contact, stop) in
                let mutableContact = contact.mutableCopy() as! CNMutableContact
                if givenName == mutableContact.givenName || givenName == mutableContact.familyName || givenName == mutableContact.nickname || givenName == "\(mutableContact.familyName)\(mutableContact.givenName)"{
                    Mcontact = mutableContact;
                }
            })
            if Mcontact == nil{//没找到联系人
                return addIntoContacts(telephoneNumbers: telephoneNumbers, givenName: givenName)
            }else{
                return editContacts(telephoneNumbers: telephoneNumbers, givenName: givenName, mutableContact: Mcontact!);
            }
        }catch{
            return false;
        }
    }
    
    private func editContacts(telephoneNumbers:Array<String>, givenName: String, mutableContact:CNMutableContact)->Bool{
        var isEdit = false;
        var arry = [CNLabeledValue<CNPhoneNumber>]();
        let store = CNContactStore();
        for value in telephoneNumbers {
            if !value.isEmpty{
                let mobileNumber = CNPhoneNumber(stringValue:value);
                let mobuleValue = CNLabeledValue(label: CNLabelWork, value: mobileNumber);
                arry.append(mobuleValue);
            }
        }
        if arry.count == 0{
            return false;
        }
        mutableContact.phoneNumbers = arry;
        let request = CNSaveRequest();
        request.update(mutableContact)
        do {
            try store.execute(request)
            isEdit = true;
        } catch  {
            isEdit = false;
        }
        
        return isEdit;
    }
    
    //添加到通讯录
    private func addIntoContacts(telephoneNumbers:Array<String>, givenName : String)->Bool{
        if addingContact == true {return false;}
        addingContact = true;
        var isSuccess = false;
        var arry = [CNLabeledValue<CNPhoneNumber>]();
        let store = CNContactStore();
        //创建CNMutableContact类型的实例
        let contactToAdd = CNMutableContact();
        //设置姓名
        contactToAdd.givenName = givenName;
        //设置电话
        for value in telephoneNumbers{
            if !value.isEmpty{
                let mobileNumber = CNPhoneNumber(stringValue:value);
                let mobileValue = CNLabeledValue(label: CNLabelWork, value: mobileNumber);
                arry.append(mobileValue)
            }
        }
        if arry.count == 0 {
            return false;
        }
        contactToAdd.phoneNumbers = arry;
        //添加联系人请求
        let saveRequest = CNSaveRequest();
        saveRequest.add(contactToAdd, toContainerWithIdentifier: nil);
        do{
            //写入联系人
            try store.execute(saveRequest);
            isSuccess = true;
        }catch{
            isSuccess = false;
        }
        return isSuccess;
    }
    
    func checkNotificationSetting() -> Void {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current();
            center.getNotificationSettings { [weak self] (settings) in
                if settings.authorizationStatus == .denied {
                    self?.showAlertForEnableTip(titleID: "ENABLE_NOTIFICATION_TIP_TITLE",messageID: "ENABLE_NOTIFICATION_TIP");
                }
            }
        } else {
            if UIApplication.shared.isRegisteredForRemoteNotifications == false {//没有设定
                showAlertForEnableTip(titleID: "ENABLE_NOTIFICATION_TIP_TITLE",messageID: "ENABLE_NOTIFICATION_TIP");
            }
        }
    }

}
