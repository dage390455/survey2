//
//  DocumentManagerViewController.m
//  Runner
//
//  Created by sensoro on 2019/8/22.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "DocumentManagerViewController.h"
#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "WXApi.h" //微信SDK头文件
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "Runner-Bridging-Header.h"

//#import <WechatOpenSDK/WXApiObject.h>

@interface DocumentManagerViewController ()
@property (nonatomic, copy)NSString *path;
@end


@implementation DocumentManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
}

//字符串的导出（写入到文件）
- (void) outputTxt:(NSDictionary*)json{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
        return;
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSInteger projectId = [[json objectForKey:@"id"]integerValue];
    if(projectId<=0)
        return;
    
    NSString *rootPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *path = [NSString stringWithFormat:@"%@/%ld.txt",rootPath,projectId];
    self.path = path;
    //文件不存在会自动创建，文件夹不存在则不会自动创建会报错
//    NSString *path = @"/Users/gx/Desktop/test_export.txt";
    NSError *error1;
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"," withString:@";"];
    [jsonString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error1];
    if (error1) {
        NSLog(@"写入失败:%@",error);
    }else{
        NSLog(@"写入成功");
    }
    
    [self shareInit];
    //分享出去，暂时用txt格式。
    [self shareConfig];
}

- (void)shareConfig{
    //1、创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    NSURL *thumbImageUrl = [NSURL URLWithString:@"http://owvmcf0eg.bkt.clouddn.com/image/share/app_share_ios_thumb.png"];
    NSURL *imageUrl = [NSURL URLWithString:@"http://image.imwaka.com/image/share/app_share.png"];
    
    //文件数据
    WXFileObject *fileObj = [WXFileObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"shareFile" ofType:@"pdf"];
    NSData *data = [NSData dataWithContentsOfFile:self.path];
    fileObj.fileData = [NSData dataWithContentsOfFile:self.path];
    //多媒体消息
    fileObj.fileExtension = @"txt";
    WXMediaMessage *wxMediaMessage = [WXMediaMessage message];
    wxMediaMessage.title = @"来自升哲勘察的文件";
    wxMediaMessage.description = @"项目记录";
    wxMediaMessage.messageExt = @"txt";
    wxMediaMessage.mediaObject = fileObj;
    //发送消息
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.message = wxMediaMessage;
    req.bText = NO;
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
    
    
    //微信好友
    [shareParams SSDKSetupWeChatParamsByText:nil
                                       title:nil
                                         url:nil
                                  thumbImage:thumbImageUrl
                                       image:imageUrl
                                musicFileURL:nil
                                     extInfo:nil
                                    fileData:data
                                emoticonData:nil
                                        type:SSDKContentTypeAuto
                          forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    
    //微信朋友圈
    [shareParams SSDKSetupWeChatParamsByText:nil
                                       title:nil
                                         url:nil
                                  thumbImage:thumbImageUrl
                                       image:imageUrl
                                musicFileURL:nil
                                     extInfo:nil
                                    fileData:data
                                emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    
    
    
    //有的平台要客户端分享需要加此方法，例如微博
    [shareParams SSDKEnableUseClientShare];
    
    
//    [ShareSDK showShareActionSheet:nil
//                             items:@[@(SSDKPlatformSubTypeWechatSession),
//                                     @(SSDKPlatformSubTypeWechatTimeline)]
//                       shareParams:shareParams
//               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                   switch (state) {
//                       case SSDKResponseStateBegin:
//                           break;
//                       case SSDKResponseStateSuccess:
//                           if (platformType == SSDKPlatformTypeCopy) {
//                               NSLog(@"复制成功");
//                           }else{
//                               NSLog(@"分享成功");
//                           }
//                           break;
//                       case  SSDKResponseStateFail:
//                           if (platformType == SSDKPlatformTypeCopy) {
//                               NSLog(@"复制失败");
//                           }else{
//                               NSLog(@"分享失败");
//                           }
//                           NSLog(@"失败：%@", error);
//                           break;
//                       default:
//                           break;
//                   }
//               }];
}

#pragma mark - Share
- (void)shareInit {
    /*
     @param activePlatforms
     使用的分享平台集合
     @param importHandler (onImport)
     导入回调处理，当某个平台的功能需要依赖原平台提供的SDK支持时，需要在此方法中对原平台SDK进行导入操作
     @param configurationHandler (onConfiguration)
     配置回调处理，在此方法中根据设置的platformType来填充应用配置信息
     */
    [ShareSDK registerActivePlatforms:@[@(SSDKPlatformTypeWechat)]
                             onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             default:
                 break;
         }
     }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType) {
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxf274fbb694ee5981"
                                       appSecret:@"c63730e77d8a95a0670a161a053814f0"];
                 break;
             default:
                 break;
         }
     }];
}

+(void)openFileAndSave:(NSString*)filePath{
    //NSString *dataFile = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil]; 本地文件用这个
    NSString *dataFile = [NSString stringWithContentsOfURL:[NSURL URLWithString:filePath] encoding:NSUTF8StringEncoding error:nil];
    NSArray *dataarr = [dataFile componentsSeparatedByString:@";"];
    if(dataarr.count>0){
        NSString *str = dataarr[0];
        str = [str stringByReplacingOccurrencesOfString:@"," withString:@";"];
        [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"histroySurveysiteProjectname"];

    }
}

- (void)openDocument:(NSString*)urlPath{
    _documentController =[UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:urlPath]];
    
    _documentController.delegate = self;  [_documentController presentOpenInMenuFromRect:CGRectMake(0, 0, 500, 300) inView:self.view animated:YES];
}

-(void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application{

}

-(void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application{
    
}

-(void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller{
    
}



@end
