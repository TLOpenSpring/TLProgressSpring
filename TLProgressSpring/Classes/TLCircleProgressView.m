//
//  TLCircleProgressView.m
//  Pods
//
//  Created by Andrew on 16/5/18.
//
//

#import "TLCircleProgressView.h"
static NSString *const TLCircularProgressViewProgressAnimationKey = @"TLCircularProgressViewProgressAnimationKey";


@interface TLCircleProgressView()

@property (nonatomic,strong)NSNumberFormatter *numberFormatter;
@property (nonatomic,strong)NSTimer *updateTImer;
@property (nonatomic,strong)CAShapeLayer *shapeLayer;

@property int valueLabelProgressPercentDifference;

@end

@implementation TLCircleProgressView

+(void)load
{
    [self.appearance setAnimationDuration:0.3];
    [self.appearance setBorderWidth:2.0];
    [self.appearance setLineWidth:1.0];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        [self initView];
    }
    return self;
}

-(void)initView{
    self.isAccessibilityElement = YES;
    self.accessibilityLabel = @"Determinate Progress";
    self.accessibilityTraits = UIAccessibilityTraitUpdatesFrequently;
    
    NSNumberFormatter *numberFormatter= [NSNumberFormatter new];
    self.numberFormatter = numberFormatter;
    numberFormatter.numberStyle = NSNumberFormatterPercentStyle;
    numberFormatter.locale = NSLocale.currentLocale;
    
    
    self.shapeLayer = [[CAShapeLayer alloc]init];
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:self.shapeLayer];
    
    UILabel *valueLb=[[UILabel alloc]init];
    self.valuelb=valueLb;
    valueLb.font=[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    valueLb.textColor = [UIColor blackColor];
    valueLb.textAlignment=NSTextAlignmentCenter;
    [self addSubview:valueLb];
    
    self.stopButton = [[TLStopButton alloc]initWithCompletionBlock:^(BOOL flag) {
        [self stopAnimation];
    }];
    self.mayStop = NO;
    self.progress = 0;
    
    [self addSubview:self.stopButton];
    [self tintColorDidChange];
    
    
}



#pragma mark - tintColorDidChange
-(void)tintColorDidChange{
    [super tintColorDidChange];
    UIColor *tintColor = self.tintColor;
    self.shapeLayer.strokeColor = tintColor.CGColor;
    self.layer.borderColor=tintColor.CGColor;
    self.valuelb.textColor=tintColor;
    self.stopButton.tintColor = tintColor;
}

#pragma mark TLStopProtocol 
-(void)setMayStop:(BOOL)mayStop{
    self.stopButton.hidden = !mayStop;
    self.valuelb.hidden = mayStop;
}
-(BOOL)mayStop{
    return !self.stopButton.hidden;
}

#pragma mark
#pragma mark - Properties

-(void)setBorderWidth:(CGFloat)borderWidth{
    self.shapeLayer.borderWidth=borderWidth;
}

-(CGFloat)borderWidth{
    return self.shapeLayer.borderWidth;
}

-(void)setLineWidth:(CGFloat)lineWidth{
    self.shapeLayer.lineWidth = lineWidth;
}

-(CGFloat)lineWidth{
    return self.shapeLayer.lineWidth;
}


#pragma mark 
#pragma mark -- 控制进度条

-(void)setProgress:(float)progress{
    NSParameterAssert(progress>=0 && progress<=1);
    [self stopAnimation];
    
    _progress = progress;
    [self updateProgress];
}
#pragma mark -- 设置动画进度条
-(void)setProgress:(float)progress animated:(BOOL)animated{
 
    
    if(animated){
        if(ABS(self.progress - progress)<CGFLOAT_MIN){
            return;
        }
        
        [self animatedToPress:progress];
    }else{
        _progress = progress;
    }
    
    
    
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self);
}

-(void)updateProgress{
    [self updatePath];
    [self updateValueLb:self.progress];
}

-(void)updatePath{
    self.shapeLayer.strokeEnd = self.progress;
}

-(void)updateValueLb:(float)progress{
    self.valuelb.text=[self.numberFormatter stringFromNumber:@(progress)];
    self.accessibilityLabel=self.valuelb.text;
}

#pragma mark 动画
-(void)stopAnimation{
    [self.layer removeAnimationForKey:TLCircularProgressViewProgressAnimationKey];
    //stop timer
    [self.updateTImer invalidate];
    self.updateTImer=nil;
}

-(void)animatedToPress:(float)progress{
    [self stopAnimation];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = self.animationDuration;
    animation.fromValue = @(self.progress);
    animation.toValue = @(progress);
    animation.delegate = self;
    animation.removedOnCompletion = NO;
    animation.fillMode=kCAFillModeForwards;
    [self.shapeLayer addAnimation:animation forKey:TLCircularProgressViewProgressAnimationKey];
    
    //增加timer更新value的标签的值
    _valueLabelProgressPercentDifference = (progress-self.progress)*100;
    
    CFTimeInterval timeInterval = self.animationDuration / ABS(_valueLabelProgressPercentDifference);
    
    self.updateTImer = [NSTimer
                        scheduledTimerWithTimeInterval:timeInterval
                        target:self
                        selector:@selector(updateShowValue:)
                        userInfo:nil
                        repeats:YES];
    
    _progress = progress;
}

-(void)updateShowValue:(NSTimer *)timer{
    if (_valueLabelProgressPercentDifference > 0){
        _valueLabelProgressPercentDifference -- ;
    }else{
        _valueLabelProgressPercentDifference++;
    }
    
    [self updateValueLb:self.progress - (_valueLabelProgressPercentDifference/100)];

}

#pragma mark Layout
-(void)layoutSubviews{
    [super layoutSubviews];
    const CGFloat offset = 4;
    CGRect valueLabelRect = self.bounds;
    valueLabelRect.origin.x += offset;
    
    valueLabelRect.size.width -= 2*offset;
    self.valuelb.frame = valueLabelRect;
    
    self.layer.cornerRadius = self.frame.size.width/2;
    self.shapeLayer.path = [self layoutPath].CGPath;
    
    self.stopButton.frame = [self.stopButton frameThatFits:self.bounds];
    
}

-(UIBezierPath *)layoutPath{
    const double TWO_PI = 2*M_PI;
    const double startAngle = 0.75 * TWO_PI;
    const double endAngle = startAngle + TWO_PI;
    
    CGFloat width = self.frame.size.width;
    CGFloat borderWidth = self.borderWidth;
    CGFloat lineWidth = self.lineWidth;
    
    
    CGFloat radius=(width-lineWidth-borderWidth)/2.0;
    
    return [UIBezierPath
            bezierPathWithArcCenter:CGPointMake(width/2, width/2)
            radius:radius
            startAngle:startAngle
            endAngle:endAngle
            clockwise:YES];
}
@end





















