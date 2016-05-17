//
//  TLNavBarProgressView.m
//  Pods
//
//  Created by Andrew on 16/5/17.
//
//

#import "TLNavBarProgressView.h"
#import <objc/runtime.h>

static NSString *const TL_UINavigationControllerDidShowViewControllerNotification = @"UINavigationControllerDidShowViewControllerNotification";
static NSString *const TL_UINavigationControllerLastVisibleViewController = @"UINavigationControllerLastVisibleViewController";


@interface UINavigationController (NavigationBarProgressView_Private)

@property (nonatomic,weak)TLNavBarProgressView *progressView;

@end

@implementation UINavigationController (NavigationBarProgressView_Private)

-(void)setProgressView:(TLNavBarProgressView *)progressView{
    objc_setAssociatedObject(self, @selector(progressView), progressView, OBJC_ASSOCIATION_ASSIGN);
}

-(TLNavBarProgressView*)progressView{
    return objc_getAssociatedObject(self, @selector(progressView));
}

@end


@interface TLNavBarProgressView()


@property (nonatomic,strong)UIView *progressView;
@property (nonatomic,strong)UIViewController *viewController;
@property (nonatomic,strong)UIView *barView;

@end

@implementation TLNavBarProgressView

static NSNumberFormatter *progressNumberForMatter;

+(void)initialize{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    numberFormatter.numberStyle = NSNumberFormatterPercentStyle;
    numberFormatter.locale = NSLocale.currentLocale;
    progressNumberForMatter = numberFormatter;
}


+(instancetype)progressViewforNavigationController:(UINavigationController *)navigationController{
 //去尝试得到一个已经存在的
    TLNavBarProgressView *progressView = navigationController.progressView;
    if(progressView){
        return progressView;
    }
    
    //创建一个新的bar
    UINavigationBar *navigationBar = navigationController.navigationBar;
    progressView = [[TLNavBarProgressView alloc]init];
    progressView.barView = navigationBar;
    
    
    UIColor *tintColor= navigationBar.tintColor?navigationBar.tintColor:UIApplication.sharedApplication.delegate.window.tintColor;
    
    progressView.progressTintColor = tintColor;
    
    navigationController.progressView = progressView;
    [navigationController.navigationBar addSubview:progressView];
    
    
    //开始监听
    progressView.viewController = navigationController.topViewController;
    [progressView registerObserverForNavigationController:navigationController];
    
    return progressView;
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame: frame];
    if(self){
        [self initView];
    }
    return self;
}
//
//-(id)init{
//    self =[super init];
//    if(self){
//        [self initView];
//    }
//    return self;
//}

-(void)dealloc{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

-(void)setBarView:(UIView *)barView{
    _barView = barView;
    [self layoutSubviews];
}
/**
 *  监听导航控制器
 *
 *  @param navigationController
 */
-(void)registerObserverForNavigationController:(UINavigationController *)navigationController{

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(navigationControllerDisShowViewController:) name:TL_UINavigationControllerDidShowViewControllerNotification object:navigationController];

}

-(void)navigationControllerDisShowViewController:(NSNotification *)noti{
    UINavigationController *navigationController = noti.object;
    UIViewController *lastVisibleVC = [noti.userInfo objectForKey:TL_UINavigationControllerLastVisibleViewController];
    
    
    //检查我们的控制器是不是topViewController或者是被poped
    if(lastVisibleVC == self.viewController){
      //注销监听
        [self unregisterObserverForNavigationController:navigationController];
        navigationController.progressView = nil;
        [self removeFromSuperview];
    }
}

/**
 *  注销监听导航控制器
 *
 *  @param navigationController
 */
-(void)unregisterObserverForNavigationController:(UINavigationController *)navigationController{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}


-(void)initView{
    self.isAccessibilityElement = YES;
    self.accessibilityLabel = @"Accessibility label for navigation bar progress view";
    self.accessibilityTraits = UIAccessibilityTraitUpdatesFrequently;
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.opaque = NO;
    
    UIView *progressView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, self.bounds.size.height)];
    progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    
    progressView.backgroundColor = self.tintColor;
    [self addSubview:progressView];
    
    self.progressView = progressView;
    self.progress=0;
    [self tintColorDidChange];
    
}


#pragma mark
#pragma mark -- Layout 重新布局
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect barFrame = self.barView.frame;
    const CGFloat progressBarHeight = 2;
    
    CGRect frame = CGRectMake(barFrame.origin.x, 0, barFrame.size.width, progressBarHeight);
    
    if([self.barView isKindOfClass:UINavigationBar.class]){
        const CGFloat barBorderHeight = 0.5;
        frame.origin.y = barFrame.size.height - progressBarHeight+barBorderHeight;
    }
    
    if(!CGRectEqualToRect(self.frame, frame)){
        self.frame = frame;
    }
    
    [self layoutProgressView];
}

-(void)layoutProgressView{
    self.progressView.frame = CGRectMake(0, 0, self.frame.size.width*self.progress, self.frame.size.height);
}

#pragma mark  - GET And Set TInt Color
-(void)setProgressTintColor:(UIColor *)progressTintColor{
    self.progressView.backgroundColor=progressTintColor;
}
-(UIColor *)progressTintColor{
    return self.progressView.tintColor;
}

#pragma mark - 进度条
-(void)setProgress:(float)progress{
    NSParameterAssert(progress>=0 && progress<=1);
    _progress = progress;
    [self progressDidChange];
    
}

-(void)progressDidChange{
    self.progressView.alpha = self.progress >=1 ? 0 : 1;
    [self layoutProgressView];
    
    self.accessibilityValue = [progressNumberForMatter stringFromNumber:@(self.progress)];
  
    NSLog(@"self.accessibilityValue:%@",self.accessibilityValue);
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self);
}
/**
 *  动画改变进度条
 *
 *  @param progress <#progress description#>
 *  @param animated <#animated description#>
 */
-(void)setProgress:(float)progress animated:(BOOL)animated{

    if(animated){
        if(progress > 0  && progress<1 &&self.progressView.alpha <= CGFLOAT_MIN){
            self.progressView.alpha=1;
        }
        
        void(^completion)(BOOL) = ^(BOOL finished){
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.progressView.alpha = self.progress >= 1?0:1;
            } completion:^(BOOL finished) {
                
            }];
        };
        
        if(progress>self.progress || self.progress>=1){
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self setProgress:progress];
            } completion:completion];
        }else{
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:0 animations:^{
                [self setProgress:progress];
            } completion:completion];
        }
    }else{
        self.progress=progress;
    }
}


@end

























