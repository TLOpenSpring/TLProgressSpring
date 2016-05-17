//
//  TLStopProtocol.h
//  Pods
//
//  Created by Andrew on 16/5/17.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TLStopProtocol <NSObject>

/**
 *  控制当前的进度条是否支持停止
    如果mayStop为NO，则停止按钮不显示
    如果为YES，则显示停止按钮，点击调用按钮的点击事件
 */
@property (nonatomic) BOOL mayStop;
/**
 *  一个按钮，如果mayStop为YES，则这个按钮坐标设置在控件的中间
 */
@property (nonatomic,strong)UIButton *stopButton;
@end
