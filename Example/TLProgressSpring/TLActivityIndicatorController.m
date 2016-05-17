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
}

-(void)initView{
    _activityIndicatorView = [[TLActivityIndicatorView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:_activityIndicatorView];
    
    _activityIndicatorView.animatorDuration = 0.8;
    [_activityIndicatorView startAnimating];
}


@end
