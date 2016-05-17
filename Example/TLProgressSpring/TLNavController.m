//
//  TLNavController.m
//  TLProgressSpring
//
//  Created by Andrew on 16/5/17.
//  Copyright © 2016年 Andrew. All rights reserved.
//

#import "TLNavController.h"
#import <TLProgressSpring/TLNavBarProgressView.h>
@interface TLNavController ()
@property float progress;
@end

@implementation TLNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self initView];
}

-(void)initView{
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 40)];
    [btn setTitle:@"开始请求" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [btn addTarget:self action:@selector(go:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UILabel *tipLb=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(btn.frame)+10, SCREEN_WIDTH, 20)];
    tipLb.textColor=[UIColor blueColor];
    tipLb.textAlignment=NSTextAlignmentCenter;
    tipLb.text=@"每点击一次，进度条增加20%";
    [self.view addSubview:tipLb];
    
    
}

-(void)go:(id)sender{
    TLNavBarProgressView *progressView = [TLNavBarProgressView progressViewforNavigationController:self.navigationController];
    progressView.progressTintColor=[UIColor redColor];
    
    _progress+= 0.2;
    
    if(_progress>=1){
        _progress=0;
    }
    
    [progressView setProgress:_progress animated:YES];
}

@end
