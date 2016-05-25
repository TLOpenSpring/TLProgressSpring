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
    
  NSURLSessionDataTask * task = [self.sessionManager GET:@"/delay/3" parameters:nil progress:nil success:nil failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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
    
    
   
    
}

-(UIButton *)createBtn:(CGRect)rect
                 title:(NSString *)title{
    UIButton *btn=[[UIButton alloc]initWithFrame:rect];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor groupTableViewBackgroundColor];
    return btn;
}

-(void)showNavigationBarProgress{
    NSURLSessionDownloadTask *task = [self bytesDownloadTask];
   self.navBarProgressView = [TLNavBarProgressView progressViewforNavigationController:self.navigationController];
    [_navBarProgressView setProgressWithDownloadProgressOfTask:task animated:YES];
    
}

@end
