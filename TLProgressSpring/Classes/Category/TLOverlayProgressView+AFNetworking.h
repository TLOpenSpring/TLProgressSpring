//
//  TLOverlayProgressView+AFNetworking.h
//  Pods
//
//  Created by Andrew on 16/5/25.
//
//

#import "TLOverlayProgressView+AFNetworking.h"
#import "TLOverlayProgressView.h"


@class AFURLConnectionOperation;

@interface TLOverlayProgressView (AFNetworking)

/**
 根据指定的任务绑定进度条的各个样式状态
 *
 *  @param task <#task description#>
 */
-(void)setModeAndProgressWithStateOfTask:(NSURLSessionTask *)task;


/**
 *  设置停止任务的回调函数
 *
 *  @param task 任务
 */
-(void)setStopBlockForTask:(NSURLSessionTask *)task;
@end
