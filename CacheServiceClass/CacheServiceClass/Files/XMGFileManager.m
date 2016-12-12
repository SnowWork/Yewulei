//
//  XMGFileManager.m
//  HongDe
//
//  Created by shunde on 2012/12/11.
//  Copyright © 2012年 shunde. All rights reserved.
//

#import "XMGFileManager.h"

@implementation XMGFileManager

+(instancetype)manager{


    return [[self alloc] init];
}

+(void)getDirectorySize:(NSString*)path :(void(^)(NSInteger result))finishBlok{
    //有一个文件管理者
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSFileManager* mgr = [NSFileManager defaultManager];
        
        //判断路径是否和法
        
        BOOL isDirectory;
        [mgr fileExistsAtPath:path isDirectory:&isDirectory];
        if (!isDirectory){//路径不是一个文件夹
            
            @throw  [NSException exceptionWithName:@"exception error" reason:@"exception error!!!" userInfo:nil];
            
        }
        //获得指定路径下的所有文件名
        NSArray* paths =  [mgr subpathsAtPath:path];
        //遍历所有的子路径
        NSUInteger size =0;
        
        for (NSString* filename in paths) {
            //忽略隐藏文件
            if(  [filename containsString:@"Snapshots"]) continue;
            
            if( [filename containsString:@".DS"]) continue;
            //忽略掉文件夹
            NSString* filePath = [path stringByAppendingPathComponent:filename];
            BOOL isDirectory;
            BOOL isExistFile = [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
            if (!isExistFile||isDirectory) continue;
            
            //获得属性字典
            NSDictionary* dic = [mgr attributesOfItemAtPath:filePath error:nil];
            
            // 累加计算的size
            size +=[dic fileSize];;
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finishBlok) {
                
                finishBlok(size);
            }
        });
       

    });
    

        
}

//清除缓存功能
+(void)clearDirectory:(NSString*)path{
    
    //有一个文件管理者
    NSFileManager* mgr = [NSFileManager defaultManager];
    //判断路径是否合法
    //判断路径是否和法
    
    BOOL isDirectory;
    [mgr fileExistsAtPath:path isDirectory:&isDirectory];
    if (!isDirectory){ //路径不是一个文件夹
        
        @throw  [NSException exceptionWithName:@"exception error" reason:@"exception error!!!" userInfo:nil];
    
        
    } ;
    //删除对应路径上的文件 Snapshots
    //遍历我这个缓存路径下的所有文件
    NSArray* paths =  [mgr subpathsAtPath:path];
    
    //遍历所有的子路径
    for (NSString* filename in paths) {
        if(  [filename containsString:@"Snapshots"]) continue;
        //忽略隐藏文件
        if( [filename containsString:@".DS"]) continue;
        //忽略掉文件夹
        NSString* filePath = [path stringByAppendingPathComponent:filename];
        BOOL isDirectory;
        [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
        if (isDirectory) continue;
        
        [mgr removeItemAtPath:filePath error:nil];
    }
    
}




@end
