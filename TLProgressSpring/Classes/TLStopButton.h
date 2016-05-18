//
//  TLStopButton.h
//  Pods
//
//  Created by Andrew on 16/5/18.
//
//

#import <UIKit/UIKit.h>

typedef void(^CompletionBlock)(BOOL flag);

@interface TLStopButton : UIButton

/**
 *  按钮在父亲View的比例，介于(0-1)之间
 */
@property (nonatomic)CGFloat sizeRatio;

/**
 *  点击中间shapelayer按钮的放大比例，(0-1)之间，值越大，放大的比例越大
 */
@property (nonatomic)CGFloat scaleRatio;

/**
 *  计算返回合适的尺寸
 *
 *  @param parentSize <#parentSize description#>
 *
 *  @return <#return value description#>
 */
-(CGRect)frameThatFits:(CGRect)parentSize;

@property (nonatomic,strong)CompletionBlock callback;

-(instancetype)initWithCompletionBlock:(CompletionBlock)block;

@end
