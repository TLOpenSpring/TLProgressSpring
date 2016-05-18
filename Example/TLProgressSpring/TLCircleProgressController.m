//
//  TLCircleProgressController.m
//  TLProgressSpring
//
//  Created by Andrew on 16/5/18.
//  Copyright © 2016年 Andrew. All rights reserved.
//

#import "TLCircleProgressController.h"
#import <TLProgressSpring/TLCircleProgressView.h>

@interface TLCircleProgressController()

@property float progress;

@property (nonatomic,strong)TLCircleProgressView *circleProgress;
@end

@implementation TLCircleProgressController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIBarButtonItem *showItem=[[UIBarButtonItem alloc]initWithTitle:@"开始" style:UIBarButtonItemStylePlain target:self action:@selector(showActivity:)];
    self.navigationItem.rightBarButtonItem = showItem;
    
    [self initView];
}


-(void)initView{
    _circleProgress=[[TLCircleProgressView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    _circleProgress.center=self.view.center;
    [self.view addSubview:_circleProgress];
    _circleProgress.animationDuration=1;
    [_circleProgress setProgress:0.9 animated:YES];
    
   // _circleProgress.progress=0.8;
}

-(void)showActivity:(id)sender{
    
    if(_progress==0){
        _progress=1;
    }else{
        _progress=0;
    }
    
    //_circleProgress.progress=_progress;
    
    [_circleProgress setProgress:_progress animated:YES];
    

}
@end
