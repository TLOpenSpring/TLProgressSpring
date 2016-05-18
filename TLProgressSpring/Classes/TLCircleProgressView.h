//
//  TLCircleProgressView.h
//  Pods
//
//  Created by Andrew on 16/5/18.
//
//

#import "TLCircleProgressView.h"
#import "TLStopButton.h"
#import "TLProgressView.h"
#import "TLStopProtocol.h"

@interface TLCircleProgressView : TLProgressView<TLStopProtocol>
/**
 *  显示百分比的label
 */
@property (nonatomic,strong)UILabel *valuelb;

@property (nonatomic) float progress;

@property (nonatomic,assign) CFTimeInterval animationDuration;
/**
 *  外部的圆环的边框
 */
@property (nonatomic)CGFloat borderWidth;

/**
 *  里面的那个显示百分比的线条
 */
@property (nonatomic)CGFloat lineWidth;

@property (nonatomic,strong)TLStopButton *stopButton;

-(void)setProgress:(float)progress animated:(BOOL)animated;

@end
