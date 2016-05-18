//
//  TLActivityIndicatorView.h
//  Pods
//
//  Created by Andrew on 16/5/17.
//
//

#import <UIKit/UIKit.h>
#import "TLStopProtocol.h"
#import "TLStopButton.h"

@interface TLActivityIndicatorView : UIView <TLStopProtocol>

/**
 *  圆圈的边框宽度，默认是 2.0
 */
@property (nonatomic) CGFloat lineWidth;
/**
 *  转子的时间设置，时间越短，速度越快
 */
@property NSTimeInterval animatorDuration;

@property (nonatomic) BOOL hidesWhenStopped;

@property (nonatomic,strong)TLStopButton *stopButton;

/**
 *  开始动画效果
 */
-(void)startAnimating;

/**
 *  停止动画效果
 */
-(void)stopAnimating;

/**
 *  判断当前进度条是否正在动画中
 *
 *  @return
 */
-(BOOL)isAnimating;

@end
