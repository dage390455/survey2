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
//    [[[UIAlertView alloc] initWithTitle:@"提示"
//                                message:@"导出的文件如果包含图片，会需要一点时间，请耐心等待"
//                               delegate:nil
//                      cancelButtonTitle:@"确定"
//                      otherButtonTitles:nil] show];
    [self makeExcel:json];
    return;
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


- (void)makeExcel :(NSDictionary*)json{
    [self shareInit];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentPath stringByAppendingPathComponent:@"c_demo.xlsx"];
    lxw_workbook  *workbook   = workbook_new([path UTF8String]);
    
    /* Set up some worksheets. */
    lxw_worksheet *worksheet1 = workbook_add_worksheet(workbook, "sheet1");
//    lxw_worksheet *worksheet2 = workbook_add_worksheet(workbook, NULL);
//    lxw_worksheet *worksheet3 = workbook_add_worksheet(workbook, NULL);
//    lxw_worksheet *worksheet4 = workbook_add_worksheet(workbook, NULL);
    
    
    /* Set the tab colors. */
    worksheet_set_tab_color(worksheet1, LXW_COLOR_WHITE);
//    worksheet_set_tab_color(worksheet2, LXW_COLOR_GREEN);
//    worksheet_set_tab_color(worksheet3, 0xFF9900); /* Orange. */
    NSMutableArray *list =[[NSMutableArray alloc]init];
    
    int column =0;
    for(NSString* key  in json.allKeys){

        id  value = [json objectForKey:key];
        NSString* key1 = [key stringByReplacingOccurrencesOfString:@"id" withString:@"项目编号"];
        key1 = [key1 stringByReplacingOccurrencesOfString:@"projectName" withString:@"项目名称"];
        key1 = [key1 stringByReplacingOccurrencesOfString:@"createTime" withString:@"创建时间"];
        key1 = [key1 stringByReplacingOccurrencesOfString:@"remark" withString:@"备注"];
        
        if([value isKindOfClass:[NSString class]]){
            NSString *str =[NSString stringWithFormat:@"%@:%@",key1,value];
            char *cString = [str UTF8String];
            worksheet_write_string(worksheet1, column, 0, cString, NULL);
            column++;
        }
        if([value isKindOfClass:[NSNumber class]]){
            NSString *str =[NSString stringWithFormat:@"%@:%@",key1,value];
            char *cString = [str UTF8String];
            worksheet_write_string(worksheet1, column, 0, cString, NULL);
            column++;
        }
        if([value isKindOfClass:[NSArray class]]){
            list = value;
        }
    }
    
    if(list.count>0){
        worksheet_write_string(worksheet1, column, 0, "{", NULL);
        column++;
    }
    NSMutableArray *imgList = [[NSMutableArray alloc]init];
    for (int i=0;i<list.count;i++){
        NSDictionary *dic = [list objectAtIndex:i];
        for(NSString* key  in dic.allKeys){
            id  value = [dic objectForKey:key];
            
            NSString* key1 = [key stringByReplacingOccurrencesOfString:@"editName" withString:@"勘察点信息"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"editPurpose" withString:@"勘察点用途"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"editAddress" withString:@"具体地址"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"editPosition" withString:@"定位地址"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"editLongitudeLatitude" withString:@"定位坐标"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"editPointArea" withString:@"面积"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"headPerson" withString:@"负责人"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"headPhone" withString:@"负责人电话"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"bossName" withString:@"老板名字"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"bossPhone" withString:@"老板电话"];
            
            key1 = [key1 stringByReplacingOccurrencesOfString:@"page2editAddress" withString:@"电箱位置"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"page2editPurpose" withString:@"电箱用途"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"step1Remak" withString:@"电箱备注"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"isNeedCarton" withString:@"是否需要外箱"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"isOutSide" withString:@"电箱位置"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"isNeedLadder" withString:@"是否需要梯子"];
            
            key1 = [key1 stringByReplacingOccurrencesOfString:@"step3Remak" withString:@"备注"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"isEffectiveTransmission" withString:@"报警音可否传播"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"isNuisance" withString:@"是否扰民"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"isNoiseReduction" withString:@"是否消音"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"step4Remak" withString:@"备注"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"allOpenValue" withString:@"总开"];
            
            key1 = [key1 stringByReplacingOccurrencesOfString:@"isSingle" withString:@"单项三箱"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"allOpenValue" withString:@"总开"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"isMolded" withString:@"是否微断"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"current" withString:@"额定电流"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"dangerous" withString:@"危险线路数"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"probeNumber" withString:@"探头个数"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"isZhiHui" withString:@"是否智慧空开"];
            
            key1 = [key1 stringByReplacingOccurrencesOfString:@"editenvironmentpic1" withString:@"环境图1"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"editenvironmentpic2" withString:@"环境图2"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"editenvironmentpic3" withString:@"环境图3"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"editenvironmentpic4" withString:@"环境图4"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"editenvironmentpic5" withString:@"环境图5"];
            
            key1 = [key1 stringByReplacingOccurrencesOfString:@"editpic1" withString:@"电箱图1"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"editpic2" withString:@"电箱图2"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"editpic3" withString:@"电箱图3"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"editpic4" withString:@"电箱图4"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"editpic5" withString:@"电箱图5"];
            
            key1 = [key1 stringByReplacingOccurrencesOfString:@"recommendedTransformer" withString:@"推荐互感器"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"currentSelect" withString:@"额定电流"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"editPointStructure" withString:@"勘察点结构"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"electricalFireId" withString:@"勘察点id"];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"editPointStructure" withString:@"勘察点结构"];
            
            key1 = [key1 stringByReplacingOccurrencesOfString:@"page1" withString:@""];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"page2" withString:@""];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"page3" withString:@""];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"page4" withString:@""];
            key1 = [key1 stringByReplacingOccurrencesOfString:@"page5" withString:@""];

            
            if(value ==nil ||value==NULL||value ==0){
                NSString *str =[NSString stringWithFormat:@"%@:",key1];
                char *cString = [str UTF8String];
                worksheet_write_string(worksheet1, column, 0, cString, NULL);
                column++;
            }
            if([value isKindOfClass:[NSString class]]){
                NSString *str1 = value;
                //图片
                if([str1 rangeOfString:@"var/mobile"].location!=NSNotFound){
                    [imgList addObject:str1];
                    
                }else{
                    NSString *str =[NSString stringWithFormat:@"%@:%@",key1,value];
                    char *cString = [str UTF8String];
                    worksheet_write_string(worksheet1, column, 0, cString, NULL);
                    column++;
                }
            }
            if([value isKindOfClass:[NSNumber class]]){
                NSString *str =[NSString stringWithFormat:@"%@:%@",key1,value];
                char *cString = [str UTF8String];
                worksheet_write_string(worksheet1, column, 0, cString, NULL);
                column++;
            }
        }
    }
    
    worksheet_write_string(worksheet1, column, 0, "}", NULL);
    
    column++;
    column++;
    column++;
    
    
    //图片要放在最后处理，否则插入会出错
    for( int i=0;i<imgList.count;i++){
        //先压缩
        NSString *str1 = [imgList objectAtIndex:i];
        UIImage *image = [UIImage imageWithContentsOfFile:str1];
        NSData *dataObj = UIImageJPEGRepresentation(image, 0.1);
        UIImage *image2 = [UIImage imageWithData:dataObj];
        
        NSString *rootPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        NSString * Pathimg = [NSString stringWithFormat:@"%@/%d.png",rootPath,i];
        [UIImagePNGRepresentation(image2) writeToFile:Pathimg atomically:YES];
        
        CGSize  size = CGSizeMake(120, 120);
        UIImage *image11 = [self compressOriginalImage:[UIImage imageWithData:dataObj] toSize:size ];
        [UIImagePNGRepresentation(image11)  writeToFile:Pathimg atomically:YES];
        
        const char *imageStr = [Pathimg UTF8String];
        worksheet_insert_image(worksheet1,  column,  i*2, imageStr);
    }
    
    column++;
    
//    worksheet_write_string(worksheet1, 0, 0, "哈哈哈", NULL);
//    worksheet_write_string(worksheet1, 0, 1, "你好", nil);
//    worksheet_write_string(worksheet1, 0, 2, "就是", nil);
//    worksheet_write_string(worksheet1, 0, 3, "这样", nil);
//    worksheet_write_string(worksheet1, 0, 4, "的", nil);
    
//    NSString *itemPath1=[[NSBundle mainBundle] pathForResource:@"location_me" ofType:@"png"];
//    const char *image = [itemPath1 UTF8String];
     workbook_close(workbook);
    //文件数据
    WXFileObject *fileObj = [WXFileObject object];
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"shareFile" ofType:@"pdf"];
    NSData *data = [NSData dataWithContentsOfFile:path];
 
    
    fileObj.fileData =data;
    //多媒体消息
    fileObj.fileExtension = @"xlsx";
    WXMediaMessage *wxMediaMessage = [WXMediaMessage message];
    wxMediaMessage.title = @"来自升哲勘察的文件";
    wxMediaMessage.description = @"项目记录";
    wxMediaMessage.messageExt = @"xlsx";
    wxMediaMessage.mediaObject = fileObj;
    //发送消息
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.message = wxMediaMessage;
    req.bText = NO;
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
    
    //1、创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    NSURL *thumbImageUrl = [NSURL URLWithString:@"http://owvmcf0eg.bkt.clouddn.com/image/share/app_share_ios_thumb.png"];
    NSURL *imageUrl = [NSURL URLWithString:@"http://image.imwaka.com/image/share/app_share.png"];
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
}

-(UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}


@end
