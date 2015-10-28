//
//  QYplayer.h
//  MusicPlayer
//
//  Created by qingyun on 15/10/26.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QYsongMode.h"


enum{
    PRESONGS, //上一曲
    NEXTSONGS //下一曲
}typedef SONGSSTATE;

@interface QYplayer : NSObject
@property(nonatomic,strong)NSMutableArray *songsList;
@property(nonatomic,strong)QYsongMode *mode;
@property(nonatomic,assign) NSInteger currentNuber;//当前播放的位置
@property(nonatomic,assign) BOOL isplaying;//播放状态
@property(nonatomic,assign) NSTimeInterval duration;//总
@property(nonatomic,assign) NSTimeInterval CurrentTime;//当前
@property(nonatomic,strong,readonly)NSArray *arrTime;      //时间
@property(nonatomic,strong,readonly)NSMutableArray *arrLrc;//歌词

+(instancetype)sharePlayer;

//播放
-(void)songPlay;

//暂停
-(void)songPause;

//上一曲下一曲

-(void)updatesongswithoption:(SONGSSTATE)state;



@end
