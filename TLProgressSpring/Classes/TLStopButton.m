//
//  TLStopButton.m
//  Pods
//
//  Created by Andrew on 16/5/18.
//
//

#import "TLStopButton.h"

static CGFloat const TLStopButtonSize = 44.0;




@interface TLStopButton()
@property (nonatomic,strong)CAShapeLayer *shapeLayer;
@end

@implementation TLStopButton
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        [self initView];
    }
    return self;
}

-(instancetype)initWithCompletionBlock:(CompletionBlock)block{
    self = [super init];
    if(self){
        _callback=block;
        [self initView];
    }
    return self;
}


-(void)initView{
    self.accessibilityLabel=@"Stop";
    self.accessibilityHint=@"Stop the activity";
    self.accessibilityTraits=UIAccessibilityTraitButton;
    
    self.sizeRatio = 0.3;
    self.scaleRatio = 0.3;
    
    CAShapeLayer *shapeLayer = [CAShapeLayer new];
    [self.layer addSublayer:shapeLayer];
    self.shapeLayer = shapeLayer;
    
    
    [self addTarget:self action:@selector(didTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(didTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)didTouchDown:(UIButton *)btn{

    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [self layoutSubviews];
        
    } completion:nil];
}

-(void)didTouchUpInside:(UIButton *)btn{
   [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
       [self layoutSubviews];
       
       if(_callback){
           _callback(YES);
       }
   } completion:nil];
}

-(CGRect)frameThatFits:(CGRect)parentSize{
    CGFloat sizeValue = MIN(parentSize.size.width, parentSize.size.height);
    CGSize viewSize = CGSizeMake(sizeValue, sizeValue);
    const CGFloat insetSizeRatio = (1-self.sizeRatio) / 2;
    
    
    CGFloat originx=parentSize.origin.x + (parentSize.size.width  - viewSize.width)  / 2.0f;
    CGFloat originY=parentSize.origin.y + (parentSize.size.height  - viewSize.height)  / 2.0f;
    
    
    NSLog(@"sizeValue*insetSizeRatio:%d",sizeValue*insetSizeRatio);
    
    return CGRectInset(CGRectMake(0, 0, viewSize.width, viewSize.height),
                       sizeValue*insetSizeRatio,
                       sizeValue*insetSizeRatio);
}

#pragma mark -- 重新布局
-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect frame = self.bounds;
    if(self.tracking && self.touchInside){
        const CGFloat insetSizeRatio = self.scaleRatio;
        /**
         *  以第一个参数为中心，进行放大后者缩小
           如果是正数，就是进行缩小
           如果是负数，就是进行扩大
         *
         *  @param frame 以这个坐标为中心
         *  @param -10   在X轴扩大
         *  @param -10   在Y周扩大
         *
         *  @return 一个扩大或者缩小的frame
         */
        frame = CGRectInset(frame,
                            -frame.size.width * insetSizeRatio,
                            -frame.size.height * insetSizeRatio);
    }
    
    self.shapeLayer.frame = frame;
    
}

-(void)tintColorDidChange{
    [super tintColorDidChange];
    self.shapeLayer.backgroundColor=self.tintColor.CGColor;
}
@end

















