//
//  QYsongMode.h
//  MusicPlayer
//
//  Created by qingyun on 15/10/26.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYsongMode : NSObject
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *type; //文件播放类型

@property(nonatomic,strong) NSURL *songUrl;
@property(nonatomic,strong) NSURL *lrcUrl;


-(instancetype)initWithDic:(NSDictionary *)dic;


@end
