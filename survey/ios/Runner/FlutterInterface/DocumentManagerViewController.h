//
//  DocumentManagerViewController.h
//  Runner
//
//  Created by sensoro on 2019/8/22.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface DocumentManagerViewController : UIViewController<UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) UIDocumentInteractionController *documentController;
- (void) outputTxt: (NSDictionary*)json;
+(void)openFileAndSave:(NSString*)filePath;


@end

NS_ASSUME_NONNULL_END
