//
//  TLIconView.m
//  Pods
//
//  Created by Andrew on 16/5/21.
//
//

#import "TLIconView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TLIconView

+(void)load{
    [self.appearance setBorderWidth:2.0];
    [self.appearance setLineWidth:2.0];
}
- (UIBezierPath *)path {
    return nil;
}

-(CAShapeLayer *)shapeLayer{
    return (CAShapeLayer *)self.layer;
}

+ (Class)layerClass {
    return CAShapeLayer.class;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initView];
    }
    return self;
}

-(void)initView{
    [self shapeLayer].fillColor = [UIColor clearColor].CGColor;
    
    [self tintColorDidChange];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self shapeLayer].path = self.path.CGPath;
}

-(void)tintColorDidChange{
    [super tintColorDidChange];
    UIColor *tintColor = self.tintColor;
    self.layer.borderColor = tintColor.CGColor;
    [self shapeLayer].strokeColor = tintColor.CGColor;
}

-(void)setFrame:(CGRect)frame{
    super.frame = frame;
    self.layer.cornerRadius = frame.size.width/2.0;
}


#pragma mark Properties
-(CGFloat)borderWidth{
    return self.layer.borderWidth;
}

-(void)setBorderWidth:(CGFloat)borderWidth{
    self.layer.borderWidth = borderWidth;
}

-(CGFloat)lineWidth{
    return [self shapeLayer].lineWidth;
}
-(void)setLineWidth:(CGFloat)lineWidth{
    [self shapeLayer].lineWidth=lineWidth;
}


@end

@implementation TLCheckMarkIconView

-(void)initView{
    [super initView];
}

-(UIBezierPath *)path{
    UIBezierPath *bezierPath = [UIBezierPath new];
    CGRect bounds = self.bounds;
    
    [bezierPath moveToPoint:CGPointMake(bounds.size.width*0.2, bounds.size.height*0.55)];
    [bezierPath addLineToPoint:CGPointMake(bounds.size.width*0.325, bounds.size.height*0.7)];
    [bezierPath addLineToPoint:CGPointMake(bounds.size.width*0.75, bounds.size.height*0.3)];
    
    return bezierPath;
    
}

@end




@implementation TLCrossIconView

-(void)initView{
    [super initView];
}


-(UIBezierPath *)path{
    UIBezierPath *path = [UIBezierPath new];
    const double padding = 0.25;
    
    CGSize size = self.bounds.size;
    double min = padding;
    double max = 1-padding;
    
    [path moveToPoint:CGPointMake(size.width*min, size.height*min)];
    [path addLineToPoint:CGPointMake(size.width*max, size.height*max)];
    
    [path moveToPoint:CGPointMake(size.width*min, size.height*max)];
    [path addLineToPoint:CGPointMake(size.width*max, size.height*min)];
    
    return path;
}
@end














