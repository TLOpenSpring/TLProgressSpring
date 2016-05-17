//
//  TLProgressView.h
//  Pods
//
//  Created by Andrew on 16/5/17.
//
//

#import <UIKit/UIKit.h>

@interface TLProgressView : UIView

/**
 *  当前的进度
 */
//@property (nonatomic,assign)float progress;

/**
 *  动态的改变进度
 *
 *  @param progress 设置进图
 *  @param animated 是否动画显示
 */
-(void)setProgress:(float)progress animated:(BOOL)animated;

@end
