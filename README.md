# TLProgressSpring
<<<<<<< HEAD

[![CI Status](http://img.shields.io/travis/Andrew/TLProgressSpring.svg?style=flat)](https://travis-ci.org/Andrew/TLProgressSpring)
[![Version](https://img.shields.io/cocoapods/v/TLProgressSpring.svg?style=flat)](http://cocoapods.org/pods/TLProgressSpring)
[![License](https://img.shields.io/cocoapods/l/TLProgressSpring.svg?style=flat)](http://cocoapods.org/pods/TLProgressSpring)
[![Platform](https://img.shields.io/cocoapods/p/TLProgressSpring.svg?style=flat)](http://cocoapods.org/pods/TLProgressSpring)

## 示例图片
![1](http://7xkxhx.com1.z0.glb.clouddn.com/Simulator%20Screen%20Shot%202016%E5%B9%B45%E6%9C%8823%E6%97%A5%20%E4%B8%8A%E5%8D%888.53.37.png)

![2](http://7xkxhx.com1.z0.glb.clouddn.com/Simulator%20Screen%20Shot%202016%E5%B9%B45%E6%9C%8823%E6%97%A5%20%E4%B8%8A%E5%8D%888.52.27.png)

![3](http://7xkxhx.com1.z0.glb.clouddn.com/Simulator%20Screen%20Shot%202016%E5%B9%B45%E6%9C%8823%E6%97%A5%20%E4%B8%8A%E5%8D%888.53.13.png)

![4](http://7xkxhx.com1.z0.glb.clouddn.com/Simulator%20Screen%20Shot%202016%E5%B9%B45%E6%9C%8823%E6%97%A5%20%E4%B8%8A%E5%8D%888.53.27.png)

![5](http://7xkxhx.com1.z0.glb.clouddn.com/Simulator%20Screen%20Shot%202016%E5%B9%B45%E6%9C%8823%E6%97%A5%20%E4%B8%8A%E5%8D%888.53.22.png)

![6](http://7xkxhx.com1.z0.glb.clouddn.com/Simulator%20Screen%20Shot%202016%E5%B9%B45%E6%9C%8823%E6%97%A5%20%E4%B8%8A%E5%8D%888.53.44.png)

![7](http://7xkxhx.com1.z0.glb.clouddn.com/Simulator%20Screen%20Shot%202016%E5%B9%B45%E6%9C%8823%E6%97%A5%20%E4%B8%8A%E5%8D%888.53.41.png)

![8](http://7xkxhx.com1.z0.glb.clouddn.com/Simulator%20Screen%20Shot%202016%E5%B9%B45%E6%9C%8823%E6%97%A5%20%E4%B8%8A%E5%8D%888.53.30.png)

![9](http://7xkxhx.com1.z0.glb.clouddn.com/Simulator%20Screen%20Shot%202016%E5%B9%B45%E6%9C%8823%E6%97%A5%20%E4%B8%8A%E5%8D%888.53.33.png)

![10](http://7xkxhx.com1.z0.glb.clouddn.com/Simulator%20Screen%20Shot%202016%E5%B9%B45%E6%9C%8823%E6%97%A5%20%E4%B8%8A%E5%8D%888.53.16.png)

![11](http://7xkxhx.com1.z0.glb.clouddn.com/Simulator%20Screen%20Shot%202016%E5%B9%B45%E6%9C%8823%E6%97%A5%20%E4%B8%8A%E5%8D%888.53.25.png)

![12](http://7xkxhx.com1.z0.glb.clouddn.com/Simulator%20Screen%20Shot%202016%E5%B9%B45%E6%9C%8823%E6%97%A5%20%E4%B8%8A%E5%8D%888.53.48.png)



### How to use

1. 导航栏的进度条用法:

首先导入类库
`#import <TLProgressSpring/TLNavBarProgressView.h>`

键入代码:

```
 TLNavBarProgressView *progressView = [TLNavBarProgressView progressViewforNavigationController:self.navigationController];
    progressView.progressTintColor=[UIColor redColor];
    
    _progress+= 0.2;
    
    if(_progress>=1){
        _progress=0;
    }
    
    [progressView setProgress:_progress animated:YES];
```


2. 自定义转轮的用法

导入类库
`#import <TLProgressSpring/TLActivityIndicatorView.h>`

```
 _activityIndicatorView = [[TLActivityIndicatorView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:_activityIndicatorView];
    _activityIndicatorView.animatorDuration = 0.8;
    [_activityIndicatorView startAnimating];
    
    
 启动：
 
 -(void)showActivity:(id)sender{
    if(_activityIndicatorView){
        [_activityIndicatorView startAnimating];
    }
}
```

3. 带有遮罩效果的各种进度条使用

导入类库
`#import <TLProgressSpring/TLOverlayProgressView.h>`

首先利用Block定义一个延时关闭的方法:

```
- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}
```

* 默认转轮进度条用法

```
-(void)onShowProgress0{
    TLOverlayProgressView *overLayProgress = [TLOverlayProgressView
                                              showOverlayAddTo:[self rootView]
                                              title:nil
                                              style:TLOverlayStyleIndeterminate
                                              animated:YES stopBlock:^(TLOverlayProgressView *progressView) {
                                                  
                                                  [progressView hideAnimated:YES];
                                              }];
    [overLayProgress showAnimated:YES];
    [self performBlock:^{
        [overLayProgress dismiss:YES];
    } afterDelay:2.0];
}
```

* 显示失败的图标

```

-(void)onShowProgress1{
    TLOverlayProgressView *overlayProgress=[TLOverlayProgressView showOverlayAddTo:[self rootView] title:@"Failier" style:TLOverlayStyleCrossIcon animated:YES stopBlock:^(TLOverlayProgressView *progressView) {
        [progressView hideAnimated:YES];
    }];
    
    [overlayProgress showAnimated:YES];
    [self performBlock:^{
        [overlayProgress dismiss:YES];
    } afterDelay:2.0];
    
}
```

* 显示成功的图标

```
-(void)onShowProgress2{
    TLOverlayProgressView *overlayProgress=[TLOverlayProgressView showOverlayAddTo:[self rootView] title:@"Success" style:TLOverlayStyleCheckmarkIcon animated:YES stopBlock:^(TLOverlayProgressView *progressView) {
        [progressView hideAnimated:YES];
    }];
    
    [overlayProgress showAnimated:YES];
    [self performBlock:^{
        [overlayProgress dismiss:YES];
    } afterDelay:2.0];
    
}
```

* 显示百分比的水平方向的进度条

```
-(void)onShowProgress3{
    TLOverlayProgressView *overLayProgress = [TLOverlayProgressView
                                              showOverlayAddTo:self.view
                                              title:@"loading"
                                              style:TLOverlayStyleHorizontalBar
                                              animated:YES];
    overLayProgress.isShowPercent=YES;
    [overLayProgress showAnimated:YES];
    [self simulateProgress:overLayProgress];
    
}
```


* 显示小图标的进度条

```
-(void)onShowProgress4:(TLOverlayStyle )style{
    TLOverlayProgressView *progress = [TLOverlayProgressView showOverlayAddTo:self.view
                                                                        title:@"loading..."
                                                                        style:TLOverlayStyleIndeterminateSmall
                                                                     animated:YES stopBlock:^(TLOverlayProgressView *progressView) {
                                                                         
                                                                         [progressView dismiss:YES];
                                                                     }];
    [self performBlock:^{
        [progress dismiss:YES];
    } afterDelay:2.0];
}
```

* 显示圆环进度条

```
-(void)onShowProgress5{
    TLOverlayProgressView *overlayProgressView =[TLOverlayProgressView showOverlayAddTo:[self rootView] title:@"" style:TLOverlayStyleDeterminateCircular animated:YES stopBlock:^(TLOverlayProgressView *progressView) {
        [progressView hideAnimated:YES];
    }];
    [overlayProgressView showAnimated:YES];
    
    [self simulateProgress:overlayProgressView];
}
```

* 显示苹果系统自带的ActivityIndicator

```
-(void)onShowProgress7{
    TLOverlayProgressView *overLayProgress = [TLOverlayProgressView
                                              showOverlayAddTo:self.view
                                              title:@"Loading..."
                                              style:TLOverlayStyleSystemUIActivity
                                              animated:YES stopBlock:^(TLOverlayProgressView *progressView) {
                                                  [progressView hideAnimated:YES];
                                              }];
    [overLayProgress showAnimated:YES];
    [self performBlock:^{
        [overLayProgress dismiss:YES];
    } afterDelay:2.0];
}
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

TLProgressSpring is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TLProgressSpring"
```

## Author

Andrew, anluanlu123@163.com

## License

TLProgressSpring is available under the MIT license. See the LICENSE file for more info.
=======
一款进度条工具类，可以在导航栏上显示，也可以弹出一个转轮显示，用户随时可交互
>>>>>>> e7a0f294260c4687ab69a6d47ec40498dcee80bc
