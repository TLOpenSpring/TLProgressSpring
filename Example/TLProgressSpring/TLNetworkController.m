//
//  TLNetworkController.m
//  TLProgressSpring
//
//  Created by Andrew on 16/5/25.
//  Copyright © 2016年 Andrew. All rights reserved.
//

#import "TLNetworkController.h"
#import <AFNetworking.h>
#import <TLProgressSpring/TLActivityIndicatorView.h>
#import <TLProgressSpring/TLCircleProgressView.h>
#import <TLProgressSpring/TLNavBarProgressView.h>
#import <TLProgressSpring/TLOverlayProgressView.h>
#import <TLProgressSpring/TLOverlayProgressView+AFNetworking.h>
#import <TLProgressSpring/TLProgressView+AFNetworking.h>
#import <TLProgressSpring/TLActivityIndicatorView+AFNetworking.h>


@interface TLNetworkController()
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@property (nonatomic,strong) TLActivityIndicatorView *activityIndictorView;
@property (nonatomic,strong) TLCircleProgressView *circleProgressView;
@property (nonatomic,strong)TLNavBarProgressView *navBarProgressView;
@end

@implementation TLNetworkController

-(void)viewDidLoad{
    [super viewDidLoad];
     self.view.backgroundColor=[UIColor whiteColor];
    [self initView];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy=NSURLRequestReloadIgnoringCacheData;
    
    NSURL *URL=[NSURL URLWithString:@"https://httpbin.org/"];
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc]initWithBaseURL:URL sessionConfiguration:config];
    sessionManager.responseSerializer=[AFHTTPResponseSerializer serializer];
    self.sessionManager=sessionManager;
    
}

-(NSURLSessionDownloadTask *)bytesDownloadTask{
    
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:@"/bytes/1000000" relativeToURL:self.sessionManager.baseURL]];
    
    NSURLSessionDownloadTask *task = [self.sessionManager downloadTaskWithRequest:request progress:nil destination:nil completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"Task completed with error: %@", error);
    }];
    
    //启动
    [task resume];
    return task;
}

-(void)showActivityIndicator:(id)sender{
    CGRect rect=CGRectMake(10, SCREEN_HEIGHT-120, 100, 100);
    if(!_activityIndictorView){
        _activityIndictorView = [[TLActivityIndicatorView alloc]initWithFrame:rect];
        [self.view addSubview:_activityIndictorView];
    }
    
  NSURLSessionDataTask * task = [self.sessionManager
                                 GET:@"/delay/3"
                                 parameters:nil
                                 progress:nil
                                 success:nil
                                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      NSLog(@"Task %@ failed with error: %@", task, error);

  }];
    [self.activityIndictorView setAnimatingWithStateOfTask:task];
}



-(void)initView{
    
    CGRect rect =CGRectMake(10, 70, 250, 40);
    UIButton *btn1=[self createBtn:rect title:@"网络请求-导航栏进度条"];
    [btn1 addTarget:self action:@selector(showNavigationBarProgress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    rect =CGRectMake(10, CGRectGetMaxY(btn1.frame)+10, 250, 40);
    UIButton *btn2=[self createBtn:rect title:@"网络请求-转轮进度条"];
    [btn2 addTarget:self action:@selector(showActivityIndicator:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    rect =CGRectMake(10, CGRectGetMaxY(btn2.frame)+10, 250, 40);
    UIButton *btn3=[self createBtn:rect title:@"网络请求-圆环进度条"];
    [btn3 addTarget:self action:@selector(showCirlceProgress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    rect =CGRectMake(10, CGRectGetMaxY(btn3.frame)+10, 250, 40);
    UIButton *btn4=[self createBtn:rect title:@"网络请求-遮罩层进度条-默认"];
    btn4.tag=0;
    [btn4 addTarget:self action:@selector(showOverlayProgress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];
    
    
    rect =CGRectMake(10, CGRectGetMaxY(btn4.frame)+10, 250, 40);
    UIButton *btn5=[self createBtn:rect title:@"网络请求-遮罩层进度条-圆环"];
    btn5.tag=1;
    [btn5 addTarget:self action:@selector(showOverlayProgress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn5];
    
    rect =CGRectMake(10, CGRectGetMaxY(btn5.frame)+10, 250, 40);
    UIButton *btn6=[self createBtn:rect title:@"网络请求-遮罩层进度条-水平"];
    btn6.tag=2;
    [btn6 addTarget:self action:@selector(showOverlayProgress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn6];
    
    
   
    
}

-(UIButton *)createBtn:(CGRect)rect
                 title:(NSString *)title{
    UIButton *btn=[[UIButton alloc]initWithFrame:rect];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:15];
    btn.backgroundColor=[UIColor groupTableViewBackgroundColor];
    btn.showsTouchWhenHighlighted=YES;
    return btn;
}

-(void)showNavigationBarProgress{
    NSURLSessionDownloadTask *task = [self bytesDownloadTask];
   self.navBarProgressView = [TLNavBarProgressView progressViewforNavigationController:self.navigationController];
    [_navBarProgressView setProgressWithDownloadProgressOfTask:task animated:YES];
    
}

-(void)showCirlceProgress{
    NSURLSessionDownloadTask *task = [self bytesDownloadTask];
    if(!_circleProgressView){
        _circleProgressView=[[TLCircleProgressView alloc]initWithFrame:CGRectMake(10, SCREEN_HEIGHT-120, 100, 100)];
        [self.view addSubview:_circleProgressView];
    }
    _circleProgressView.progress=0;
    
    [_circleProgressView setProgressWithDownloadProgressOfTask:task animated:YES];
}

-(void)showOverlayProgress:(UIButton*)btn
{
    TLOverlayStyle style=TLOverlayStyleIndeterminate;
    if(btn.tag==1){
        style = TLOverlayStyleDeterminateCircular;
    }else if(btn.tag == 2){
        style= TLOverlayStyleHorizontalBar;
    }
    
    
    NSURLSessionDownloadTask*task = [self bytesDownloadTask];
    
    TLOverlayProgressView *overlayView=[TLOverlayProgressView showOverlayAddTo:self.view title:@"loading..." style:style animated:YES];
    
    [overlayView setModeAndProgressWithStateOfTask:task];
    
    [overlayView setStopBlockForTask:task];
}

@end
