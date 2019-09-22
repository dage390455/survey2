//
//  CitySelectMangager.h
//  Runner
//
//  Created by liwanchun on 2019/9/21.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CitySelectMangager : NSObject

+(instancetype)shard;
-(void)saveCityDB;
-(void)openDb;
- (NSArray*)queryData:(NSString*)key;


@end

