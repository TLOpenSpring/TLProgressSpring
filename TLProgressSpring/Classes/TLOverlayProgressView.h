//
//  TLOverlayProgressView.h
//  Pods
//  带有覆盖物的进度条
//  Created by Andrew on 16/5/18.
//
//

#import <UIKit/UIKit.h>

@class TLOverlayProgressView;

typedef void(^TLStopOverlayBlock)(TLOverlayProgressView *progressView);

typedef  NS_ENUM(NSInteger,TLOverlayStyle){
    /**
     *  默认显示TLAcitivityIndicator,转轮
     */
     TLOverlayStyleIndeterminate,
    /**
     *  显示一个饼状的转轮，(TlCircleProgressView)
     */
    TLOverlayStyleDeterminateCircular,
    /**
     *  显示一个水平方向的进度条(UIProgressView)
     */
    TLOverlayStyleHorizontalBar,
    /**
     *  显示一个小尺寸的TLAcitivityIndicator
     */
    TLOverlayStyleIndeterminateSmall,
    
    /**
     *  显示苹果系统自带的UIActivityIndicator
     */
    TLOverlayStyleSystemUIActivity,
    /**
     *  显示一个对勾（正确）
     */
    TLOverlayStyleCheckmarkIcon,
    
    TLOverlayStyleCrossIcon,
    /**
     *  显示一个图标
     */
    TLOverlayStyleIcon,
    
    //显示一些提示文字
     TLOverlayStyleText,
    /**
     *  显示一个自定义的View
     */
    TLOverlayStyleCustom
};


@interface TLOverlayProgressView : UIView
/**
 *  在提供的View的基础上添加一个遮挡层
 *
 *  @param view     指定的View视图
 *  @param animated 是否动画显示
 *
 *  @return 一个创建遮挡的进度条
 */
+(instancetype)showOverlayAddTo:(UIView *)view
                       animated:(BOOL)animated;
/**
 *  在提供的View的基础上添加一个遮挡层,并且可以指定显示的模式，和显示标题，是否支持动画
 *
 *  @param view     指定的View视图
 *  @param title    指定标题
 *  @param style    显示模式
 *  @param animated 是否动画显示
 *
 *  @return 一个带有遮挡层的进度条
 */
+(instancetype)showOverlayAddTo:(UIView *)view
                          title:(NSString*)title
                          style:(TLOverlayStyle)style
                       animated:(BOOL)animated;

/**
 *  在提供的View的基础上添加一个遮挡层,并且可以指定显示的模式，和显示标题，是否支持动画
 *
 *  @param view     指定的View视图
 *  @param title    指定标题
 *  @param style    显示模式
 *  @param animated 是否动画显示
 *  @param stopBlock 当点击停止的block回调处理
 *  @return 一个带有遮挡层的进度条
 */
+(instancetype)showOverlayAddTo:(UIView *)view
                          title:(NSString*)title
                          style:(TLOverlayStyle)style
                       animated:(BOOL)animated
                      stopBlock:(TLStopOverlayBlock)stopBlock;

+(BOOL)dismissOverlayForView:(UIView *)view
                    animated:(BOOL)animated;
/**
 *  隐藏遮挡层在指定的View视图上
 *
 *  @param view       指定的视图
 *  @param animated   是否支持动画
 *  @param completion 当完成后的回调函数
 *
 *  @return 是否隐藏成功
 */

+(BOOL)dismissOverlayForView:(UIView *)view
                    animated:(BOOL)animated
                  completion:(void(^)())completion;
/**
 *  隐藏指定View上的所有遮挡层
 *
 *  @param view     指定的View
 *  @param animated 是否支持动画
 *
 *  @return the number of overlays found and removed.
 */
+(NSInteger)dismissAllOverlayForView:(UIView *)view
                            animated:(BOOL)animated;
/**
 *  隐藏指定View上的所有遮挡层
 *
 *  @param view            指定的View
 *  @param animated        是否支持动画
 *  @param completionBlock 完成的回调函数
 *
 *  @return the number of overlays found and removed.
 */
+(NSInteger)dismissAllOverlayForView:(UIView *)view
                            animated:(BOOL)animated
                           comletion:(void(^)())completionBlock;

/**
 *  找出指定View上的最顶层的遮挡层
 *
 *  @param view 指定的View
 *
 *  @return 找出指定View上的最顶层的遮挡层
 */
+(instancetype)overlayForView:(UIView *)view;

/**
 *  找出指定View的所有的遮挡层
 *
 *  @param view 指定的View
 *
 *  @return 所有的遮挡层
 */
+(NSArray *)findAllOverlayForView:(UIView *)view;

/**
 *  创建一个模糊效果的视图
 *
 *  @return <#return value description#>
 */
+(UIView *)createBlueView;

@property (nonatomic,assign)TLOverlayStyle overlayStyle;

/**
 *  进度条的值
 */
@property float progress;

/**
 *  显示的值，默认是 Loading...
 */
@property (nonatomic,strong)NSString *titlelbText;
@property (nonatomic,strong)UILabel *titlelb;

/**
 *  如果是UIProgress进度条，设置显示百分比
 */
@property BOOL isShowPercent;

@property (nonatomic,strong)TLStopOverlayBlock tlStopOverlayBlock;

/**
 *  <#Description#>
 */
@property (nonatomic, strong) UIView *modeView;

-(void)setTintColor:(UIColor *)tintColor;

-(void)setProgress:(float)progress animated:(BOOL)animated;

#pragma mark --显示进度条--
/**
 *  显示进度条
 *
 *  @param animated 是否支持动画
 */
-(void)showAnimated:(BOOL)animated;
/**
 *  隐藏进度条
 *
 *  @param animated <#animated description#>
 */
-(void)hideAnimated:(BOOL)animated;

/**
 *  隐藏进度条，当完成之后从视图层级中移除
 *
 *  @param animated <#animated description#>
 */
-(void)dismiss:(BOOL)animated;

/**
 *  隐藏进度条，当完成之后从视图层级中移除
 *
 *  @param animated        是否支持动画
 *  @param completionBlock 完成后的回调函数
 */
-(void)dismiss:(BOOL)animated
    completion:(void(^)())completionBlock;

@end






