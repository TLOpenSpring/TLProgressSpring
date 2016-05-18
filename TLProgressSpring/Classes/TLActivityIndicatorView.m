//
//  TLActivityIndicatorView.m
//  Pods
//
//  Created by Andrew on 16/5/17.
//
//

#import "TLActivityIndicatorView.h"


static NSString *const TLActivityIndicatorViewSpinAnimationKey = @"TLActivityIndicatorViewSpinAnimationKey";

@interface TLActivityIndicatorView()
@property (nonatomic,strong)CAShapeLayer *shapeLayer;
@property BOOL isAnimator;
@end


@implementation TLActivityIndicatorView

@synthesize animatorDuration = _animatorDuration;
/**
 *  调用NSObject的load方法
 */
+(void)load{
    [self.appearance setLineWidth:2.0];
}

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        [self initView];
    }
    return self;
}

-(void)initView{
    self.isAccessibilityElement = YES;
    self.accessibilityLabel = @"Accessibility label for activity indicator view";
    self.hidesWhenStopped = YES;
    
    
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc]init];
    shapeLayer.borderColor=0;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:shapeLayer];
    
    self.shapeLayer = shapeLayer;
    
    
    __weak __typeof(self)weakSelf = self;
    //stopButton
    _stopButton = [[TLStopButton alloc]initWithCompletionBlock:^(BOOL flag) {
        [weakSelf stopAnimating];
    }];
    [self addSubview:_stopButton];
    self.mayStop = YES;
    
    
    [self tintColorDidChange];
}

-(void)tintColorDidChange{
    [super tintColorDidChange];
    self.shapeLayer.strokeColor = self.tintColor.CGColor;
    self.stopButton.tintColor = self.tintColor;
}

-(void)setLineWidth:(CGFloat)lineWidth{
    self.shapeLayer.lineWidth = lineWidth;
}

-(CGFloat)lineWidth{
    return self.shapeLayer.lineWidth;
}

#pragma mark StopView implemention

-(void)setMayStop:(BOOL)mayStop{
    self.stopButton.hidden = !mayStop;
}
-(BOOL)mayStop{
    return self.stopButton.hidden;
}




#pragma mark -- 动画

-(void)startAnimating{
    //如果正在进行动画，则不执行
    if(_isAnimator){
        return;
    }
    
    _isAnimator = YES;
    
    [self registerForNotification];
    [self addAnimation];
    
    if(self.hidesWhenStopped){
        self.hidden = NO;
    }
}

-(void)stopAnimating{
    //动画本来就没有进行，则直接回滚
    if(!_isAnimator){
        return;
    }
    
    _isAnimator = NO;
    
    [self unregisterForNotification];
    [self removeAnimation];
    
    if(self.hidesWhenStopped){
        self.hidden=YES;
    }
}

-(BOOL)isAnimating{
    return _isAnimator;
}

#pragma mark - Notifications
-(void)registerForNotification{

    NSNotificationCenter *center = NSNotificationCenter.defaultCenter;
    //当程序进入后台的时候
    [center addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    //当程序进入前台的时候
    [center addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
}

-(void)unregisterForNotification{
    NSNotificationCenter *center = NSNotificationCenter.defaultCenter;
    [center removeObserver:self];
}

-(void)applicationWillEnterForeground:(NSNotification *)noti{
    if(self.isAnimating){
        [self addAnimation];
    }
}

-(void)applicationDidEnterBackground:(NSNotification *)noti{
    [self removeAnimation];
}

#pragma mark 
#pragma mark  -- 重新布局
-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect frame = self.bounds;
    if(ABS(frame.size.width - frame.size.height)<CGFLOAT_MIN){
        //确保是个正方形
        CGFloat s = MIN(frame.size.width, frame.size.height);
        frame.size.width=s;
        frame.size.height=s;
    }
    
    self.shapeLayer.frame = frame;
    self.shapeLayer.path = [self layoutPath].CGPath;
    
    
    //stopButton
    self.stopButton.frame=[self.stopButton frameThatFits:self.bounds];
    
}
/**
 *  获取贝塞尔曲线路径
 *
 *  @return
 */
-(UIBezierPath *)layoutPath{
    const double TWO_PI = 2.0*M_PI;
    double startAngle = 0.1*TWO_PI;
    double endAngle = startAngle + TWO_PI*0.92;
    
    CGFloat width = self.bounds.size.width;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2, width/2) radius:width/2 startAngle:startAngle endAngle:endAngle clockwise:YES];
    return path;
}


#pragma mark 
#pragma mark -- 添加/删除动画
-(void)addAnimation{
    CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    //目标是360°,正好转一圈
    spinAnimation.toValue = @(2*M_PI);
    //设置转速，平均速度
    spinAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];//这是匀速
    //设置动画时间
    spinAnimation.duration=self.animatorDuration;
    //无穷次
    spinAnimation.repeatCount = INFINITY;
    [self.shapeLayer addAnimation:spinAnimation forKey:TLActivityIndicatorViewSpinAnimationKey];
    
}

-(void)removeAnimation{
    [self.shapeLayer removeAnimationForKey:TLActivityIndicatorViewSpinAnimationKey];
}


-(NSTimeInterval)animatorDuration{
    if(_animatorDuration==0){
        _animatorDuration = 1;
    }
    return _animatorDuration;
}

-(void)setAnimatorDuration:(NSTimeInterval)animatorDuration{
    _animatorDuration = animatorDuration;
}












@end
