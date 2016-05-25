//
//  TLActivityIndicatorView+AFNetworking.h
//  Pods
//
//  Created by Andrew on 16/5/25.
//
//

#import <Foundation/Foundation.h>
#import "TLActivityIndicatorView+AFNetworking.h"
#import "TLActivityIndicatorView.h"

@interface TLActivityIndicatorView (AFNetworking)


/**
 *  绑定任务的状态显示不同的动画效果
 *
 *  @param task 任务
 */
-(void)setAnimatingWithStateOfTask:(NSURLSessionTask *)task;
@end
