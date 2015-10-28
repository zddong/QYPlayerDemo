//
//  QYsongMode.m
//  MusicPlayer
//
//  Created by qingyun on 15/10/26.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "QYsongMode.h"
@implementation QYsongMode

-(instancetype)initWithDic:(NSDictionary *)dic{
    if (self=[super init]) {
        _name=dic[@"kName"];
        _type=dic[@"kType"];
        _lrcUrl=[[NSBundle mainBundle] URLForResource:_name withExtension:@"lrc"];
        _songUrl=[[NSBundle mainBundle] URLForResource:_name withExtension:_type];
    }
    
    return self;
}

@end
