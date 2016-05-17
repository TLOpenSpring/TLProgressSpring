//
//  TLNavBarProgressView.h
//  Pods
//
//  Created by Andrew on 16/5/17.
//
//

#import <UIKit/UIKit.h>
#import "TLProgressView.h"

/**
 *  自定义的进度条控件，在导航栏的底部显示
 */
@interface TLNavBarProgressView : TLProgressView

/**
 *  设置进图条的颜色
 */
@property (nonatomic,strong)UIColor *progressTintColor;

@property (nonatomic,assign)float progress;

/**
 *  根据导航控制器得到一个进图条的实例
 *
 *  @param navigationController 导航控制器
 *
 *  @return 进度条
 */
+(instancetype)progressViewforNavigationController:(UINavigationController*)navigationController;

@end







