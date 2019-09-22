//
//  SelectCityViewController.h
//  Runner
//
//  Created by liwanchun on 2019/9/21.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^ReturnTextBlock)(NSArray *citySelect);//给block重命名,方便调用
@interface SelectCityViewController : UIViewController
@property(nonatomic,copy)ReturnTextBlock returnTextBlock;
@end

NS_ASSUME_NONNULL_END
