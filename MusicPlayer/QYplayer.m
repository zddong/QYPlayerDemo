//
//  QYplayer.m
//  MusicPlayer
//
//  Created by qingyun on 15/10/26.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "QYplayer.h"
#import "QYsongMode.h"
#import <AVFoundation/AVFoundation.h>


@interface QYplayer ()<AVAudioPlayerDelegate>
@property(nonatomic,strong)AVAudioPlayer *player;


@end

@implementation QYplayer

+(instancetype)sharePlayer{
    static QYplayer *qy;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        qy=[[self alloc] init];
        qy.currentNuber=-1;
    });
    return qy ;
}
//解析歌词的方法
-(void)deSongsLrc:(NSURL*)url{
  //
    NSError *error;
    NSString *lrcStr=[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    //歌词放在数组
    NSArray *lrcArr=[lrcStr componentsSeparatedByString:@"\n"];

    //取出有效歌词
    //存放歌词和时间
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    for (NSString *str in lrcArr) {
        
    if (str.length>=10) {
        if ([[str substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"["]&&[[str substringWithRange:NSMakeRange(3, 1)] isEqualToString:@":"]&&[[str substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"."]&&[[str substringWithRange:NSMakeRange(9, 1)] isEqualToString:@"]"]) {
           //取出时间 和 歌词
            float timer=[[str substringWithRange:NSMakeRange(1, 2)]intValue]*60+[[str substringWithRange:NSMakeRange(4, 5)]floatValue];
            NSString *valuelrc=[str substringFromIndex:10];
            [dic setObject:valuelrc forKey:[NSNumber numberWithFloat:timer]];//@(timer)
        }
      }
    }
    //按时间重新拍续歌词；
    //timer
    _arrTime=[[dic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    //lircvalue
    _arrLrc=[NSMutableArray array];
    for (NSNumber *key in _arrTime) {
        //字典的歌词装到arr
        [_arrLrc addObject:dic[key]];
    }
}

-(NSMutableArray *)songsList{
    if (_songsList==nil) {
    NSArray *arr=[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SongsInfos" ofType:@"plist"]];
    _songsList=[NSMutableArray array];
    for (NSDictionary *dic in arr) {
        [_songsList addObject:[[QYsongMode alloc] initWithDic:dic]];
    }
  }
  return _songsList;
}

-(NSTimeInterval)duration{
     _duration= _player.duration;
    return _duration;
}

-(void)setCurrentTime:(NSTimeInterval)CurrentTime{
    _player.currentTime=CurrentTime;
}

-(NSTimeInterval)CurrentTime{
    return _player.currentTime;
}

-(BOOL)isplaying{
    return _player.playing;
}

//-(void)setCurrentTime:(NSTimeInterval)CurrentTime{
//
//}



-(void)setMode:(QYsongMode *)mode{
    if (![_mode.songUrl.absoluteString isEqualToString:mode.songUrl.absoluteString]) {
         _mode=mode;
        NSError *error;
        _player=[[AVAudioPlayer alloc] initWithContentsOfURL:_mode.songUrl error:&error];
        _player.volume=.2;
        [_player prepareToPlay];
        _player.delegate=self;
        
        //解析歌词
        [self deSongsLrc:mode.lrcUrl];
    }
}

-(void)setCurrentNuber:(NSInteger)currentNuber{
    if (_currentNuber!=currentNuber) {
        _currentNuber=currentNuber;
        self.mode=_songsList[_currentNuber];
    }
}


//播放
-(void)songPlay{
    if (_player.isPlaying) {
        return;
    }
    [_player play];
}
//暂停
-(void)songPause{
    [_player pause];
}

-(void)updatesongswithoption:(SONGSSTATE)state{

    switch (state) {
        case PRESONGS:
            if (_currentNuber>0){
             self.currentNuber--;
             [self songPlay];
             //self.mode=_songsList[_currentNuber];
            }
            break;
        case NEXTSONGS:
            if (_currentNuber<(_songsList.count-1)){
              self.currentNuber++;
              [self songPlay];
            }
            break;
        default:
            break;
    }


}


#pragma mark 播放完成

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (flag) {
    
    }
}

@end
