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
#import "TLStringUtils.h"
#import "MRBlurView.h"

#import "TLPaddingModel.h"
#import "TLIconView.h"

#define TLSmallIndicatorHeight 35
#define TLTitleLbHeight 20
#define TLHorizontalBarHeight 60

#define TLTextTipHeight 60

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
@property (nonatomic,strong)NSNumberFormatter *numberFormatter;
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
    overlayView.titlelb.attributedText=[TLStringUtils getAttibutesForTitle:title color:[UIColor blackColor]];
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
    overlayView.titlelb.attributedText=[TLStringUtils getAttibutesForTitle:title color:[UIColor blackColor]];
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
    self.blurView = [self createBlurView];
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
    self.titlelb.attributedText=[TLStringUtils getAttibutesForTitle:@"Loading..." color:self.tintColor];
    self.titlelb.textAlignment = NSTextAlignmentCenter;
    self.titlelb.numberOfLines=0;
    self.titlelb.lineBreakMode = NSLineBreakByCharWrapping;
    [dialogView addSubview:self.titlelb];
    
    
    [self createNumberFormatter];
    
    //创建模型View
    [self createModeView];
 
    [self tintColorDidChange];
}


-(void)createNumberFormatter{
    NSNumberFormatter *numberFormatter= [NSNumberFormatter new];
    self.numberFormatter = numberFormatter;
    numberFormatter.numberStyle = NSNumberFormatterPercentStyle;
    numberFormatter.locale = NSLocale.currentLocale;
}


#pragma mark create subView
-(UIView *)createBlurView{
    const CGFloat corderRadius = TLProgressOverlayViewCornerRadius;
    //如果当前系统支持模糊API
    if(TL_ISSupportUIEffectView){
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        //创建一个模糊视图
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        
        //创建盲板
        UIView *maskView = [[UIView alloc]init];
        maskView.backgroundColor = [UIColor redColor];
        maskView.layer.cornerRadius=corderRadius;
        //设置成自己的模板
        self.blurMaskView=maskView;
        effectView.maskView=maskView;
        
        return effectView;
        
    }else{
        printf("不支持模糊效果");
        UIView *blurView = [MRBlurView new];
        blurView.alpha = 0.98;
        blurView.layer.cornerRadius = corderRadius;
        [self addSubview:blurView];
        return blurView;
    }
}

-(UIView *)createModeView{
    UIView *modelView = [self createViewForStyle:self.overlayStyle];
    
    self.modeView = modelView;
    
    modelView.tintColor = self.tintColor;
    if([modelView conformsToProtocol:@protocol(TLStopProtocol)] &&
       [modelView respondsToSelector:@selector(stopButton)]){
        UIButton *stopButton = [((id<TLStopProtocol>)modelView) stopButton];
        [stopButton addTarget:self action:@selector(modeViewStopButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return modelView;
}

-(void)modeViewStopButtonClick:(UIButton *)btn{
    
    if(self.tlStopOverlayBlock){
        self.tlStopOverlayBlock(self);
    }
}

-(void)setModeView:(UIView *)modeView{
    _modeView=modeView;
    [self.dialogView addSubview:modeView];
}


#pragma mark
#pragma mark Mode 设置进度条的样式

-(void)setOverlayStyle:(TLOverlayStyle)overlayStyle{
    [self hideModeView:self.modeView];
    
    _overlayStyle = overlayStyle;
    
    [self showModeView:[self createModeView]];
    
    if(!self.hidden){
        [self manualLayoutSubviews];
    }
}
-(void)showModeView:(UIView *)view{
    view.hidden = NO;
    if ([view respondsToSelector:@selector(startAnimating)]) {
        [view performSelector:@selector(startAnimating)];
    }
}

-(void)hideModeView:(UIView *)view{
    view.hidden = YES;
    if ([view respondsToSelector:@selector(stopAnimating)]) {
        [view performSelector:@selector(stopAnimating)];
    }
}




-(UIView *)createViewForStyle:(TLOverlayStyle)style{
    UIView *progress=nil;
    switch (style) {
        case TLOverlayStyleIndeterminate:
        {
           progress= [self createActivityIndicatorView];
        }
            break;
        case TLOverlayStyleIcon:
            break;
        case TLOverlayStyleCheckmarkIcon:
        {
            progress = [self createCheckmarkView];
        }
            break;
            
        case TLOverlayStyleCrossIcon:
        {
          progress = [self createCrossIcon];
        }
            break;
        case TLOverlayStyleHorizontalBar:
        {
            progress = [self createHorizontalProgressView];
        }
            break;
        case TLOverlayStyleIndeterminateSmall:
        {
            progress = [self createSmallActivityView];
        }
            break;
        case TLOverlayStyleSystemUIActivity:
        {
            progress = [self createSmallDefaultActivityIndicatorView];
        }
            break;
        case TLOverlayStyleDeterminateCircular:
        {
            progress = [self createCircleProgressView];
        }
            break;
        case TLOverlayStyleText:
        {
            progress = [self createTextStyle];
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
#pragma mark
#pragma mark 设置progress的值
-(void)setProgress:(float)progress{
    [self setProgress:progress animated:NO];
}

-(void)setProgress:(float)progress animated:(BOOL)animated{
    NSParameterAssert(progress>=0 && progress <=1);
    _progress = progress;
    
    if(self.isShowPercent){
        self.titlelb.text=[self.numberFormatter stringFromNumber:@(progress)];
    }
    if(_progress==1){
      self.titlelb.text=@"";
    }
    
    [self applyProgressAnimated:animated];
}

-(void)applyProgressAnimated:(BOOL)animated{
    if([self.modeView respondsToSelector:@selector(setProgress:animated:)]){
        [((id)self.modeView) setProgress:self.progress animated:animated];
    }else if([self.modeView respondsToSelector:@selector(setProgress:)]){
        [((id)self.modeView) setProgress:self.progress];
    }else{
        
        NSAssert(self.overlayStyle == TLOverlayStyleDeterminateCircular ||
                 self.overlayStyle == TLOverlayStyleHorizontalBar,@"overlayStyle必须支持%@,不然程序崩溃",NSStringFromSelector(@selector(setProgress:animated:)));
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
    
    [self manualLayoutSubviews];
    
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
 [self hideAnimated:animated completion:^{
     [self removeFromSuperview];
     if(completionBlock){
         completionBlock();
     }
 }];
}

-(void)hideAnimated:(BOOL)animated{
    [self hideAnimated:animated completion:nil];
}
-(void)hideAnimated:(BOOL)animated completion:(void(^)())completionBlock{
    [self setSubviewTransform:CGAffineTransformIdentity alpha:1];
    
    void (^animBlock)()=^{
        [self setSubviewTransform:CGAffineTransformMakeScale(0.6, 0.6) alpha:0];
        self.backgroundColor = [UIColor clearColor];
    };
    
    void (^animCompletionBlock)(BOOL) = ^(BOOL finished){
        self.hidden =YES;
        [self hideModeView:self.modeView];
        
        if(completionBlock){
            completionBlock();
        }
    };
    
    if(animated){
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:animBlock
                         completion:animCompletionBlock];
    }else{
        animBlock();
        animCompletionBlock(YES);
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
    TLActivityIndicatorView *smallActivityView = [[TLActivityIndicatorView alloc]initWithFrame:CGRectMake(100, 100, 40, 40)];
    smallActivityView.hidesWhenStopped = YES;
    return smallActivityView;
}

-(TLIconView *)createCheckmarkView{
    TLCheckMarkIconView *checkMark = [[TLCheckMarkIconView alloc]init];
    return checkMark;
}

-(TLIconView *)createCrossIcon{
    TLCrossIconView *crossIcon = [[TLCrossIconView alloc]init];
    return crossIcon;
}

/**
 *  创建系统默认的转轮
 *
 *  @return
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

-(UIView *)createTextStyle{
    return [UIView new];
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



#pragma mark
#pragma mark Layout 手动重新布局
/**
 *  不要覆盖layoutSubviews，因为会引起动画效果的问题 在隐藏的时候
 */
-(void)manualLayoutSubviews{
    
    CGRect bounds = self.superview.bounds;
    UIEdgeInsets insets = UIEdgeInsetsZero;
   
    if([self.superview isKindOfClass:[UIScrollView class]]){
        UIScrollView *scrollView = (UIScrollView*)self.superview;
        insets = scrollView.contentInset;
    }
    
    self.center = CGPointMake((bounds.size.width - insets.left - insets.right) / 2.0f,
                              (bounds.size.height - insets.top - insets.bottom) / 2.0f);
    
    
    if([self.superview isKindOfClass:[UIWindow class]] && UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation)){
       self.bounds  = (CGRect){CGPointZero, {bounds.size.height, bounds.size.width}};
    }else{
       self.bounds = (CGRect){CGPointZero, bounds.size};
    }

    
    TLPaddingModel *paddingModel=[[TLPaddingModel alloc]initWithDialogPadding:15
                                                                  modePadding:30
                                                                 dialogMargin:10
                                                               dialogMinWidth:150
                                                                ];
    
    if(self.overlayStyle == TLOverlayStyleIndeterminateSmall){
        [self layoutSmallIndicator:paddingModel];
    }else if(self.overlayStyle == TLOverlayStyleIndeterminate){
        [self LayoutIndeterminate:paddingModel];
    }else if(self.overlayStyle == TLOverlayStyleHorizontalBar){
        [self layoutHorizontalBar:paddingModel];
    }else if(self.overlayStyle == TLOverlayStyleDeterminateCircular){
        [self layoutDeterminateCircular:paddingModel];
    }else if(self.overlayStyle == TLOverlayStyleSystemUIActivity){
        [self layoutSmallIndicator:paddingModel];
    }else if(self.overlayStyle == TLOverlayStyleCheckmarkIcon||
             self.overlayStyle == TLOverlayStyleCrossIcon){
        [self layoutIconView:paddingModel];
    }else if(self.overlayStyle == TLOverlayStyleText){//如果是文字提示
       [self layoutTextView:paddingModel];
    }
    else if(self.overlayStyle == TLOverlayStyleCustom){
        [self layoutStyleCustom:paddingModel];
    }
    
    if(!CGRectEqualToRect(self.blurView.frame, self.dialogView.frame)){
        self.blurView.frame = self.dialogView.frame;
        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 8
        self.blurMaskView.frame = self.dialogView.frame;
        self.blurView.maskView = self.blurMaskView;
         #endif
    }
}





-(void)layoutStyleCustom:(TLPaddingModel *)paddingModel{
      CGFloat  dialogWidth = self.modeView.frame.size.width + 2*paddingModel.modePadding;
}

/**
 *  手动布局带有百分比的圆环进度条
 *
 *  @param paddingModel 布局对象
 */
-(void)layoutDeterminateCircular:(TLPaddingModel *)paddingModel{
    [self LayoutIndeterminate:paddingModel];
}

/**
 *  手动布局小个头的自定义转轮效果
 *
 *  @param paddingModel 布局对象
 */
-(void)layoutSmallIndicator:(TLPaddingModel *)paddingModel{
    CGFloat height = (TLSmallIndicatorHeight-7*2);
    CGFloat  y = TLSmallIndicatorHeight/2-height/2;
    
    //1.设置dialogView
    CGRect innerRect;
    CGSize innerSize = CGSizeMake(paddingModel.dialogMinWidth, TLSmallIndicatorHeight);
    innerRect=TLCenterCGSizeInCGRect(innerSize, self.bounds);
    self.dialogView.frame = innerRect;
    
    //2.设置modeView
    CGRect modeViewFrame = CGRectMake(15, y, height, height);
    self.modeView.frame=modeViewFrame;
    
    //3.设置标题
    if(self.titlelb.text.length>0){
        CGFloat originY=self.dialogView.frame.size.height/2 - TLTitleLbHeight/2;
        self.titlelb.frame = CGRectMake(CGRectGetMaxX(self.modeView.frame), originY,self.dialogView.frame.size.width-height-modeViewFrame.origin.x, TLTitleLbHeight);
    }else{
      //如果没有标题，则重新布局，让dialogView尺寸变小，让modeView尺寸变小
        //重置dialogView尺寸
        CGRect smallFrame=self.dialogView.frame;
        smallFrame.size=CGSizeMake(TLSmallIndicatorHeight, TLSmallIndicatorHeight);
        CGFloat originX=self.superview.frame.size.width/2 -smallFrame.size.width/2;
        smallFrame.origin.x=originX;
        self.dialogView.frame=smallFrame;
        
        //重置modeView尺寸
        smallFrame=self.modeView.frame;
         originX=self.dialogView.frame.size.width/2 - smallFrame.size.width/2;
        smallFrame.origin.x=originX;
        self.modeView.frame=smallFrame;
    }
}
/**
 *  手动布局icon，比如checkMark,CrossIcon
    如果想自定义布局，可以修改这个类，目前是引用Indeterminate的布局
 *
 *  @param paddingModel 布局对象
 */
-(void)layoutIconView:(TLPaddingModel *)paddingModel{
    [self LayoutIndeterminate:paddingModel];
}
/**
 *  手动布局自定义转轮效果
 *
 *  @param paddingModel 布局对象
 */
-(void)LayoutIndeterminate:(TLPaddingModel *)paddingModel{
    //1.设置dialogView
    CGRect innerRect;
    CGSize innerSize = CGSizeMake(paddingModel.dialogMinWidth, paddingModel.dialogMinWidth);
    innerRect=TLCenterCGSizeInCGRect(innerSize, self.bounds);
    self.dialogView.frame = innerRect;
    
    //2.设置modeView
    const CGFloat innerViewWidth = paddingModel.dialogMinWidth - 2*paddingModel.modePadding;
    CGFloat  y = paddingModel.dialogMinWidth/2-innerViewWidth/2;
    CGRect modeViewFrame = CGRectMake(paddingModel.modePadding, y, innerViewWidth, innerViewWidth);
    self.modeView.frame=modeViewFrame;
    
    //3.设置标题
    if(self.titlelb.text.length>0){
        self.modeView.frame = CGRectOffset(self.modeView.frame, 0, 10);
        self.titlelb.frame=CGRectMake(0, 10, self.dialogView.frame.size.width, 20);
    }
}


/**
 *  手动布局系统默认进度条UIProgressView
 *
 *  @param paddingModel 布局对象
 */
-(void)layoutHorizontalBar:(TLPaddingModel*)paddingModel{
    //1.设置dialogView
    CGRect innerRect;
    CGSize innerSize = CGSizeMake(paddingModel.dialogMinWidth,TLHorizontalBarHeight);
    innerRect=TLCenterCGSizeInCGRect(innerSize, self.bounds);
    self.dialogView.frame = innerRect;
    
    //2.设置modeView
    const CGFloat innerViewWidth = paddingModel.dialogMinWidth - 2*paddingModel.modePadding;
    CGFloat  y = paddingModel.dialogMinWidth/2-innerViewWidth/2;
    self.modeView.frame = CGRectMake(10, y, paddingModel.dialogMinWidth-20, 5);
    
    self.modeView.backgroundColor=[UIColor redColor];
    
    //3.设置标题
    if(self.titlelb.text.length>0){
        self.modeView.frame = CGRectOffset(self.modeView.frame, 0, 10);
        self.titlelb.frame=CGRectMake(0, 10, self.dialogView.frame.size.width, 20);
    }
}
/**
 *  手动布局文字提示
 *
 *  @param paddingModel 布局对象
 */
-(void)layoutTextView:(TLPaddingModel*)paddingModel{
    //1.设置dialogView
    CGRect innerRect;
    CGSize innerSize = CGSizeMake(paddingModel.dialogMinWidth,TLTextTipHeight);
    innerRect=TLCenterCGSizeInCGRect(innerSize, self.bounds);
    self.dialogView.frame = innerRect;
    
    //2.设置modeView
    self.modeView.frame=self.dialogView.bounds;
    
    //3.设置标题
    if(self.titlelb.text.length>0){
        CGFloat gap=10;
        CGFloat originY=0;
        
        self.titlelb.frame=CGRectMake(gap, gap, innerRect.size.width-gap*2, innerRect.size.height-gap*2);
        [self.titlelb sizeToFit];
        
        originY=self.superview.frame.size.height/2 - (self.titlelb.frame.size.height+gap*2)/2;
        
        self.dialogView.frame=CGRectMake(self.dialogView.frame.origin.x, originY, self.titlelb.frame.size.width+gap*2, self.titlelb.frame.size.height+gap*2);
        self.modeView.frame=self.dialogView.bounds;
    }
}

#pragma Utils

static inline CGRect TLCenterCGSizeInCGRect(CGSize innerRectSize, CGRect outerRect) {
    CGRect innerRect;
    innerRect.size = innerRectSize;
    innerRect.origin.x = outerRect.origin.x + (outerRect.size.width  - innerRectSize.width)  / 2.0f;
    innerRect.origin.y = outerRect.origin.y + (outerRect.size.height - innerRectSize.height) / 2.0f;
    return innerRect;
}

@end










