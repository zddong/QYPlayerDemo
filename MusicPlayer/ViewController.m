//
//  ViewController.m
//  MusicPlayer
//
//  Created by qingyun on 15/10/26.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "ViewController.h"
#import "QYplayer.h"
#import "QYsongMode.h"
#import "SongViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ViewController
- (void)viewDidLoad {
    UITableView *tableView=[[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [QYplayer sharePlayer].songsList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    
    QYsongMode *mode=[QYplayer sharePlayer].songsList[indexPath.row];
    cell.textLabel.text=mode.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SongViewController *songeViewController=[[SongViewController alloc] init];
    [QYplayer sharePlayer].currentNuber=indexPath.row;
    [self.navigationController   pushViewController:songeViewController animated:YES];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
