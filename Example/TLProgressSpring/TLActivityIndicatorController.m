//
//  TLActivityIndicatorController.m
//  TLProgressSpring
//
//  Created by Andrew on 16/5/17.
//  Copyright © 2016年 Andrew. All rights reserved.
//

#import "TLActivityIndicatorController.h"
#import <TLProgressSpring/TLActivityIndicatorView.h>

@interface TLActivityIndicatorController()
@property (nonatomic,strong)TLActivityIndicatorView *activityIndicatorView;
@end

@implementation TLActivityIndicatorController


-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView];
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIBarButtonItem *showItem=[[UIBarButtonItem alloc]initWithTitle:@"显示" style:UIBarButtonItemStylePlain target:self action:@selector(showActivity:)];
    self.navigationItem.rightBarButtonItem = showItem;
}

-(void)initView{
    _activityIndicatorView = [[TLActivityIndicatorView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:_activityIndicatorView];
    _activityIndicatorView.animatorDuration = 0.8;
   //_activityIndicatorView.tintColor=[UIColor groupTableViewBackgroundColor];
    [_activityIndicatorView startAnimating];
    
    UILabel *tiplb=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_activityIndicatorView.frame)+30, SCREEN_WIDTH, 20)];
    tiplb.text=@"点击中间的按钮消失";
    tiplb.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:tiplb];
    
    
}

-(void)showActivity:(id)sender{
    if(_activityIndicatorView){
        [_activityIndicatorView startAnimating];
    }
}


@end



