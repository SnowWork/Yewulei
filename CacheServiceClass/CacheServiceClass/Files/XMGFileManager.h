//
//  XMGFileManager.h
//  HongDe
//
//  Created by shunde on 2012/12/11.
//  Copyright © 2012年 shunde. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 这是一个管理文件的业务类,可以删除指定文件夹,或者计算文件下的尺寸大小
 */
@interface XMGFileManager : NSObject

+(instancetype)manager;

/**
 计算一个指定文件夹的尺寸

 @param path 指定的文件夹
  计算好的文件夹的尺寸
 */
+(void)getDirectorySize:(NSString*)path :(void(^)(NSInteger result))finishBlok;


/**
 清除一个文件夹的文件
 */
+(void)clearDirectory:(NSString*)path;
@end
