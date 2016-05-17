//
//  TLStopProtocol.h
//  Pods
//
//  Created by Andrew on 16/5/17.
//
//

#import <Foundation/Foundation.h>

@protocol TLStopProtocol <NSObject>

/**
 *  控制动画是否可以停止
 */
@property (nonatomic, assign) BOOL mayStop;



/**
 设置mayStop YES,则显示停止按钮
 设置mayStop NO, 则显示隐藏按钮
 */
@property (nonatomic, readonly, weak) UIButton *stopButton;
@end
