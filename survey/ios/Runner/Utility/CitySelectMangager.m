//
//  CitySelectMangager.m
//  Runner
//
//  Created by liwanchun on 2019/9/21.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "CitySelectMangager.h"
#import "FMDatabase.h"
#import <FMDatabase.h>

@interface CitySelectMangager(){
    FMDatabase *_db;//FMDB对象
    NSString *_docPath;//路径
    int i;//标记
    int j;//标记
    NSArray *nameArray;
}

@end
@implementation CitySelectMangager


+(instancetype)shard{
    static CitySelectMangager *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //不能再使用alloc方法
        //因为已经重写了allocWithZone方法，所以这里要调用父类的分配空间的方法
        _sharedSingleton = [[super allocWithZone:NULL] init];
        
    });
    return _sharedSingleton;
}

-(void)openDb{

//    //设置数据库名称
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    _docPath = [paths objectAtIndex:0];
//     NSLog(@"%@",_docPath);
//     NSString *fileName = [_docPath stringByAppendingPathComponent:@"selectCity.db"];
//    //2.获取数据库
//    _db = [FMDatabase databaseWithPath:fileName];
//
//    if ([_db open]) {
//        NSLog(@"打开数据库成功");
//    } else {
//        NSLog(@"打开数据库失败");
//    }
}

-(void)saveCityDB{
    NSArray *searchPaths  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *docPath = [searchPaths objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"selectCity.db"];
    NSLog(@"%@",dbPath);
    
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    BOOL isExit = [fileManager fileExistsAtPath:dbPath];
    //如果不存在，讲工程里面数据库的复制到Document里面
    if (!isExit) {
        NSLog(@"原来不存在数据库");
        
        //获取工程里面的数据库路径
        NSString *studentDBPath = [[NSBundle mainBundle] pathForResource:@"selectCity" ofType:@"db"];
        NSLog(@"%@",studentDBPath);
        BOOL success = [fileManager copyItemAtPath:studentDBPath toPath:dbPath error:nil];
        if (success) {
            NSLog(@"数据库复制成功");
        }
        
    }
    
    FMDatabase *database = [[FMDatabase alloc]initWithPath:dbPath];
    
    if ([database open]) {
        NSLog(@"打开数据库成功");
    }
    _db = database;
    
}

- (NSArray*)queryData:(NSString*)key {
    NSLog(@"查询数据");
    
    FMResultSet *resultSet = [_db executeQuery:@"SELECT * FROM city WHERE parent_code = ?",key];
    //    FMResultSet *resultSet = [_db executeQuery:@"select * from t_student where  sex = ?", @"未知"];
    NSMutableArray*array = [NSMutableArray array];
    while ([resultSet next]) {
        NSString *name = [resultSet objectForKeyedSubscript:@"short_name"];
        NSString *code = [resultSet objectForKeyedSubscript:@"code"];
        NSMutableDictionary*dic = [NSMutableDictionary dictionary];
        dic[@"name"] = name;
        dic[@"code"] = code;
        [array addObject:dic];
        NSLog(@"地址：%@",name);
        
    }
    
    return array;
}


@end
