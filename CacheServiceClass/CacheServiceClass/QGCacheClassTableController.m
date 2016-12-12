//
//  QGCacheClassTableController.m
//  CacheServiceClass
//
//  Created by apple on 12/12/12.
//  Copyright © 2012年 zhangbaiquan. All rights reserved.
//

#import "QGCacheClassTableController.h"
#import <SDImageCache.h>
#import "XMGFileManager.h"
#import <SVProgressHUD.h>


#define  XMGCachePath  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject
static NSString* ID = @"cell";

@interface QGCacheClassTableController ()
@property (nonatomic, assign)NSInteger  size ;

@end

@implementation QGCacheClassTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self imageVV];
    [SVProgressHUD showWithStatus:@"正在计算缓存,请稍后..."];
    [XMGFileManager getDirectorySize:XMGCachePath :^(NSInteger result) {
        [SVProgressHUD dismiss];
        self.size = result;
        [self.tableView reloadData];
        
    }];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    
    
    
}

- (void)imageVV{
    //01 确定URL地址
    NSURL *url = [NSURL URLWithString:@"http://pic33.nipic.com/20130916/3420027_192919547000_2.jpg"];
    
    NSLog(@"--");
    //02 把图片的二进制数据下载到本地
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    
    //03 把图片的二进制格式转换为UIimage
    UIImage *image = [UIImage imageWithData:imageData];
    
    //uiview 放在view 上
    UIImageView *image1=[[UIImageView alloc] initWithFrame:CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, 300)];
    image1.backgroundColor=[UIColor redColor];
    
    image1.image=image;
    [self.view addSubview:image1];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
   
    //2,清除缓存
    cell.textLabel.text = [self getCacheStr] ;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [XMGFileManager clearDirectory:XMGCachePath];
    [XMGFileManager getDirectorySize:XMGCachePath :^(NSInteger result) {
        
        self.size = result;
        [self.tableView reloadData];
        
    }];
}

//缓存字符串
-(NSString*)getCacheStr{
    //缓存尺寸
    //1MB=1000KB=1000*1000B
    //1KB =1000B
    NSString*  cacheStr = @"清除缓存";
    NSInteger  size = 0;

    size = _size;
    CGFloat sizeF = 0;
    if (size>=1000*1000) {//大于1MB
        sizeF = size/1000.0/1000.0;
        cacheStr = [NSString stringWithFormat:@"%@(%.1fMB)",cacheStr,sizeF];
        
    }else if (size>=1000){//大于1KB
        sizeF = size/1000.0;
        cacheStr = [NSString stringWithFormat:@"%@(%.1fKB)",cacheStr,sizeF];
        
        
    }else if (size>0){//大于0B
        cacheStr = [NSString stringWithFormat:@"%@(%zdB)",cacheStr,size];
    }
    
    cacheStr  = [cacheStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
    
    
    return cacheStr;
}

@end
