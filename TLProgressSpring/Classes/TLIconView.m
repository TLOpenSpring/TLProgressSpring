//
//  TLIconView.m
//  Pods
//
//  Created by Andrew on 16/5/21.
//
//

#import "TLIconView.h"

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

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initView];
    }
    return self;
}

-(void)initView{
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    [self tintColorDidChange];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}
@end
