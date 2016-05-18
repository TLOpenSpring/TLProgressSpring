//
//  TLOverlayProgressView.m
//  Pods
//
//  Created by Andrew on 16/5/18.
//
//

#import "TLOverlayProgressView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "TLCircleProgressView.h"
#import "TLActivityIndicatorView.h"
#import <UIKit/UIKit.h>

//ios8之后才支持模糊视图的UIVisualEffectView，所以要判断一下
#if defined(TL_EnableUIVisualEffectView)
    #define TL_UIEffectViewIsEnabled 1
#else
    #define TL_UIEffectViewIsEnabled 0
#endif

#define TL_ISALLOWUIEffectView (TL_UIEffectViewIsEnabled && __IPHONE_OS_VERSION_MAX_ALLOWED >= 8)

/**
 * 当前系统版本 是否支持 模糊API ->UIVisualEffectView
 *
 *  @param @"UIVisualEffectView" UIVisualEffectView
 *
 *  @return 是否支持模糊API
 */
#define TL_ISSupportUIEffectView (TL_ISALLOWUIEffectView && NSClassFromString(@"UIVisualEffectView") != nil)

static const CGFloat TLProgressOverlayViewCornerRadius = 7;
static const CGFloat TLProgressOverlayViewMotionEffectExtent = 10;

@interface TLOverlayProgressView ()

@property (nonatomic,strong)UIView *dialogView;
@property (nonatomic,strong)UIView *blurView;
@property (nonatomic,strong)UIView *blurMaskView;

@property (nonatomic,strong)NSDictionary *savedAttributes;
@end

@implementation TLOverlayProgressView

static void *TLProgressOverlayViewObservationContext = &TLProgressOverlayViewObservationContext;

#pragma mark
#pragma mark -- 类方法

+(instancetype)showOverlayAddTo:(UIView *)view
                       animated:(BOOL)animated{

    
    
    TLOverlayProgressView *overlayView = [self new];
    [view addSubview:overlayView];
    [overlayView showAnimated:animated];
    return overlayView;
}

+(instancetype)showOverlayAddTo:(UIView *)view
                          title:(NSString *)title
                          style:(TLOverlayStyle)style
                       animated:(BOOL)animated
{
    TLOverlayProgressView *overlayView = [self new];
    overlayView.overlayStyle=style;
    overlayView.titlelb.text=title;
    [view addSubview:overlayView];
    [overlayView showAnimated:animated];
    return overlayView;
  
}

+(instancetype)showOverlayAddTo:(UIView *)view
                          title:(NSString *)title
                          style:(TLOverlayStyle)style
                       animated:(BOOL)animated
                      stopBlock:(TLStopOverlayBlock)stopBlock{
    TLOverlayProgressView *overlayView = [self new];
    overlayView.overlayStyle=style;
    overlayView.titlelb.text=title;
    overlayView.tlStopOverlayBlock = stopBlock;
    [view addSubview:overlayView];
    [overlayView showAnimated:animated];
    return overlayView;
}


#pragma mark
#pragma mark 隐藏遮挡层

+(BOOL)dismissOverlayForView:(UIView *)view animated:(BOOL)animated{
    [self dismissOverlayForView:view animated:animated completion:nil];
}

+(BOOL)dismissOverlayForView:(UIView *)view
                    animated:(BOOL)animated
                  completion:(void (^)())completion{
    TLOverlayProgressView *overlayView = [self overlayForView:view];
    if(overlayView){
        [overlayView dismiss:animated completion:completion];
        return YES;
    }else{
        return NO;
    }
}

+(NSInteger)dismissAllOverlayForView:(UIView *)view
                            animated:(BOOL)animated{
    return [self dismissOverlayForView:view animated:animated completion:nil];
}

+(NSInteger)dismissAllOverlayForView:(UIView *)view
                            animated:(BOOL)animated comletion:(void (^)())completionBlock{
    //找出视图上所有的遮盖层
    NSArray *views = [self findAllOverlayForView:view];
    for (TLOverlayProgressView *overlayView in views) {
        [overlayView dismiss:animated completion:completionBlock];
    }
    return views.count;
}

+(instancetype)overlayForView:(UIView *)view{
    //获取翻转顺序的遍历器
    NSEnumerator *subViewsEnum = view.subviews.reverseObjectEnumerator;
    
    for (UIView *subview in subViewsEnum) {
        if([subview isKindOfClass:self]){
            return (TLOverlayProgressView*)subview;
        }
    }
    return nil;
}

+(NSArray *)findAllOverlayForView:(UIView *)view{
    NSMutableArray *overlays = [NSMutableArray new];
    NSArray *subviews=view.subviews;
    for (UIView *view in subviews) {
        if([view isKindOfClass:self]){
            [overlays addObject:view];
        }
    }
    return overlays;
}


#pragma mark
#pragma mark Initialization

-(id)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if(self){
        [self initView];
    }
    return self;
}

-(void)initView{
    //支持VoiceOver
    self.accessibilityViewIsModal = YES;
    self.hidden = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    const CGFloat cornerRadius = TLProgressOverlayViewCornerRadius;
    
    
    
    //创建一个模糊视图
    self.blurView = [self createBlueView];
    //创建一个容器
    UIView *dialogView = [UIView new];
    [self addSubview:dialogView];
    
    self.dialogView = dialogView;
    //添加动态效果
    [self applyMotionEffects];
    
    //设置dialog
    dialogView.backgroundColor = [UIColor clearColor];
    dialogView.layer.cornerRadius=cornerRadius;
    dialogView.layer.shadowRadius = cornerRadius +5;
    dialogView.layer.shadowOpacity = 0.1f;
    dialogView.layer.shadowOffset = CGSizeMake(-(cornerRadius+5)/2.0f, -(cornerRadius+5)/2.0f);
    
    //创建titlelb
    UILabel *titlelb=[[UILabel alloc]init];
    self.titlelb=titlelb;
    self.titlelb.attributedText=[self getAttibutesForTitle:@"Loading..."];
    self.titlelb.textAlignment = NSTextAlignmentCenter;
    self.titlelb.numberOfLines=0;
    self.titlelb.lineBreakMode = NSLineBreakByCharWrapping;
    [dialogView addSubview:self.titlelb];
    
    
    //创建模型View
    [self createModeView];
 
    [self tintColorDidChange];
}



#pragma mark create subView
-(UIView *)createBlueView{
    const CGFloat corderRadius = TLProgressOverlayViewCornerRadius;
    //如果当前系统支持模糊API
    if(__IPHONE_OS_VERSION_MAX_ALLOWED >= 8){
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        //创建一个模糊视图
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        
        //创建盲板
        UIView *maskView = [[UIView alloc]init];
        maskView.backgroundColor = [UIColor whiteColor];
        maskView.layer.cornerRadius=corderRadius;
        //设置成自己的模板
        self.blurMaskView=maskView;
        effectView.maskView=maskView;
        
        return effectView;
        
    }else{
        printf("不支持模糊效果");
    }
}

-(UIView *)createModeView{
    UIView *modelView = [self createViewForStyle:self.overlayStyle];
    
    self.modeView = modelView;
    
    modelView.tintColor = self.tintColor;
    
    return modelView;
}

-(void)setModeView:(UIView *)modeView{
    _modeView=modeView;
    [self.dialogView addSubview:modeView];
}


-(UIView *)createViewForStyle:(TLOverlayStyle)style{
    UIView *progress=nil;
    switch (style) {
        case TLOverlayStyleIndeterminate:
        {
           progress= [self createActivityIndicatorView];
        }
            break;
            
        default:
            break;
    }
    
    return progress;
}

#pragma mark - Title label text
-(NSDictionary *)titleTextAttributesToCopy{
    if(self.titlelb.text.length == 0){
        return @{};
    }else{
        return [self.titlelb.attributedText attributesAtIndex:0 effectiveRange:NULL];
    }
}



#pragma mark - Key-Value-Observing

-(void)registerForKVO{
    for (NSString *keyPath in self.observeKeyPaths) {
        [self addObserver:self
               forKeyPath:keyPath
                  options:NSKeyValueObservingOptionPrior
                  context:TLProgressOverlayViewObservationContext];
        
    }
}
-(void)unregisterFromKVO{
    for (NSString *keyPath in self.observeKeyPaths) {
        [self removeObserver:self forKeyPath:keyPath];
        
    }
}

-(NSArray *)observeKeyPaths{
    return @[@"titlelb.text"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSString *,id> *)change
                      context:(void *)context{
    
    BOOL isChange=[change[NSKeyValueChangeNotificationIsPriorKey] boolValue];
    
    if(context == TLProgressOverlayViewObservationContext){
        if([keyPath isEqualToString:@"titlelb.text"]){
            if(isChange){
             
            }
        }
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark - Transitions

-(void)setSubviewTransform:(CGAffineTransform)transform
                     alpha:(CGFloat)alpha{
    self.blurView.transform = transform;
    self.dialogView.transform = transform;
    self.alpha = alpha;
}
-(void)showAnimated:(BOOL)animated{
    [self showModeView:self.modeView];
    
    if(animated){
        [self setSubviewTransform:CGAffineTransformMakeScale(1.3, 1.3) alpha:0.5];
        self.backgroundColor = [UIColor clearColor];
    }
    
    self.hidden = NO;
    
    void(^animatorBlock)()= ^{
        [self setSubviewTransform:CGAffineTransformIdentity alpha:1];
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4f];
    };
    
    if(animated){
        [UIView animateWithDuration:0.2 animations:animatorBlock];
    }else{
        animatorBlock();
    }
}

-(void)dismiss:(BOOL)animated{
    [self dismiss:animated completion:nil];
}
-(void)dismiss:(BOOL)animated completion:(void (^)())completionBlock{
 
}

-(void)showModeView:(UIView *)view{
    view.hidden = NO;
    if ([view respondsToSelector:@selector(startAnimating)]) {
        [view performSelector:@selector(startAnimating)];
    }
}

-(void)hideModeVie:(UIView *)view{
    view.hidden = YES;
    if ([view respondsToSelector:@selector(stopAnimating)]) {
        [view performSelector:@selector(stopAnimating)];
    }
}


#pragma mark - Helper to create UIMotionEffects

-(UIInterpolatingMotionEffect *)motionEffectWithKeyPath:(NSString *)keyPath
                                                   type:(UIInterpolatingMotionEffectType)type{
    
    UIInterpolatingMotionEffect *effect = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:keyPath type:type];
    
    effect.minimumRelativeValue = @(-TLProgressOverlayViewMotionEffectExtent);
    effect.maximumRelativeValue = @(TLProgressOverlayViewMotionEffectExtent);
    
    return effect;

}
//添加动态效果，比如倾斜手机，屏幕上的视图跟着动
-(void)applyMotionEffects{
    UIMotionEffectGroup *motionEffectGroup = [[UIMotionEffectGroup alloc]init];
    
    
    UIInterpolatingMotionEffect *xEffect=[self motionEffectWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    UIInterpolatingMotionEffect *yEffect =[self motionEffectWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    
    motionEffectGroup.motionEffects=@[xEffect,yEffect];
    [self.dialogView addMotionEffect:motionEffectGroup];
    [self.blurView addMotionEffect:motionEffectGroup];
}


#pragma mark 
#pragma mark 创建Mode View 的工厂

-(TLActivityIndicatorView *)createActivityIndicatorView{
    TLActivityIndicatorView *activityView = [[TLActivityIndicatorView alloc]init];
    return activityView;
}

-(TLActivityIndicatorView *)createSmallActivityView{
    TLActivityIndicatorView *smallActivityView = [[TLActivityIndicatorView alloc]init];
    smallActivityView.hidesWhenStopped = YES;
    return smallActivityView;
}

/**
 *  创建系统默认的转轮
 *
 *  @return <#return value description#>
 */
-(UIActivityIndicatorView *)createSmallDefaultActivityIndicatorView{
    UIActivityIndicatorView *activityView = [UIActivityIndicatorView new];
    activityView.hidesWhenStopped= YES;
    activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    return activityView;
}

-(TLCircleProgressView *)createCircleProgressView{
    TLCircleProgressView *circleProgress = [[TLCircleProgressView alloc]init];
    return circleProgress;
}
/**
 *  创建水平进度条
 *
 *  @return
 */
-(UIProgressView *)createHorizontalProgressView{
    UIProgressView *progress = [[UIProgressView alloc]init];
    return progress;
}

-(UIView *)createCustom{
    return [UIView new];
}

#pragma mark Tint Color
-(void)setTintColor:(UIColor *)tintColor{
    super.tintColor = tintColor;
}

-(void)tintColorDidChange{
    [super tintColorDidChange];
    self.modeView.tintColor = self.tintColor;
}

#pragma
#pragma mark getAttibutesForTitle

-(NSAttributedString *)getAttibutesForTitle:(NSString *)title{
    
    NSDictionary *dict=@{NSForegroundColorAttributeName:[UIColor blackColor],
                         NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline],
                         NSKernAttributeName:@(10)};
    
    NSAttributedString *attriString=[[NSAttributedString alloc] initWithString:title attributes:dict];
    return attriString;
}

@end









