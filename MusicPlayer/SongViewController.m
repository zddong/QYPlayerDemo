//
//  SongViewController.m
//  MusicPlayer
//
//  Created by qingyun on 15/10/26.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "SongViewController.h"
#import "QYplayer.h"
@interface SongViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *songTableView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UISlider *silder;
@property (nonatomic,strong)NSIndexPath *selecPath;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)int currentLine;
@end

@implementation SongViewController

- (void)viewDidLoad {
    [[QYplayer sharePlayer] songPlay];
    _silder.maximumValue=[QYplayer sharePlayer].duration;
    _silder.minimumValue=0;
    _currentLine=-1;
    [super viewDidLoad];
    [self startTimer];
    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if ([QYplayer sharePlayer].isplaying) {
        [_playBtn setTitle:@"暂停" forState:UIControlStateNormal];
    }else{
        [_playBtn setTitle:@"播放" forState:UIControlStateNormal];
        
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self uninstimer];
}
-(void)isPlayBtnState{
    if ([QYplayer sharePlayer].isplaying) {
        //刷新歌词［tableveiw］；
         _currentLine=-1;
         [_songTableView reloadData];
        
        _timer.fireDate=[NSDate  date];
        [_playBtn setTitle:@"暂停" forState:UIControlStateNormal];
    }else{
        [_playBtn setTitle:@"播放" forState:UIControlStateNormal];
    }
}
-(void)updateUI{
    //更新进度条
    [self updateLrcView];
    _silder.value=[QYplayer sharePlayer].CurrentTime;
}

-(void)updateLabColor:(NSIndexPath *)path{
    
    //选中的cell
    [UIView animateWithDuration:.3f animations:^{
        //选中当前的cell
        UITableViewCell *cell=[_songTableView cellForRowAtIndexPath:path];
        cell.textLabel.textColor=[UIColor greenColor];
        cell.textLabel.font=[UIFont systemFontOfSize:25];
        if (_selecPath) {
            //恢复上一个选中cell
            UITableViewCell *preCell=[_songTableView cellForRowAtIndexPath:_selecPath];
            preCell.textLabel.textColor=[UIColor blackColor];
            preCell.textLabel.font=[UIFont systemFontOfSize:15];
        }
        //纪录最后选中的cell
        _selecPath=path;
    }];
}


-(void)scrollTableCell{

    NSIndexPath *indepath=[NSIndexPath indexPathForRow:_currentLine inSection:0];
    
    // [_songTableView selectRowAtIndexPath:indepath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [_songTableView  scrollToRowAtIndexPath:indepath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    //更新选中文字的字体颜色
    [self updateLabColor:indepath];

}

-(void)updateLrcView{
    //判断当前是最后一行不再执行了
    if (_currentLine<((int)[QYplayer sharePlayer].arrTime.count-1)) {
    
    float nextLineTime=[[QYplayer sharePlayer].arrTime[_currentLine+1] doubleValue]
    ;

     if ([QYplayer sharePlayer].CurrentTime-nextLineTime>=0) {
        NSLog(@"=======%f",[QYplayer sharePlayer].CurrentTime);
        //执行下一行
        _currentLine++;
         [self scrollTableCell];
         
     }
    }
}
-(void)startTimer{
    _timer=[NSTimer timerWithTimeInterval:.3 target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}
-(void)uninstimer{
    [_timer invalidate];
    _timer=nil;
}
#pragma mark 上一曲

- (IBAction)preClick:(UIButton *)sender {
    
    [[QYplayer sharePlayer]updatesongswithoption:PRESONGS];
    [self isPlayBtnState];
}
#pragma mark 下一曲
- (IBAction)nextClick:(id)sender {
    [[QYplayer sharePlayer]updatesongswithoption:NEXTSONGS];
    [self isPlayBtnState];
}
#pragma mark 播放暂停
- (IBAction)playOrPauseClick:(UIButton *)sender {
    if ([QYplayer sharePlayer].isplaying) {
        [[QYplayer sharePlayer]songPause];
         _timer.fireDate=[NSDate  distantFuture];
        [_timer fire];
        [_playBtn setTitle:@"播放" forState:UIControlStateNormal];
    }else{
        [[QYplayer sharePlayer]songPlay];
        _timer.fireDate=[NSDate date];
        [_playBtn setTitle:@"暂停" forState:UIControlStateNormal];
    }
}



-(void)updateCell{
    NSLog(@"======1111");
   
    //当前歌词在哪一行上
    _currentLine=-1;
    for (int i=0;i<[QYplayer sharePlayer].arrTime.count;i++) {
        float nextLineTime=[[QYplayer sharePlayer].arrTime[i] floatValue];
        if ([QYplayer sharePlayer].CurrentTime-nextLineTime>=0) {
            _currentLine++;
        }
    }
    _timer.fireDate=[NSDate date];

    [self scrollTableCell];

}


#pragma mark 播放进度
- (IBAction)ValueChangeSilder:(UISlider *)sender {
    
    
   
    
    [QYplayer sharePlayer].CurrentTime=sender.value;
    //取消updateCell响应
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateCell) object:nil];
    [self performSelector:@selector(updateCell) withObject:nil afterDelay:.3];
    if (_timer.valid) {
        _timer.fireDate=[NSDate distantFuture];
        [_timer fire];
    }
}

#pragma mark TableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //歌词的条数
    return  [QYplayer sharePlayer].arrLrc.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identify=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Identify];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identify];
        
    }
    //歌词的详细
    cell.textLabel.text=[QYplayer sharePlayer].arrLrc[indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:15];
    cell.textLabel.textColor=[UIColor blackColor];
    return cell;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
