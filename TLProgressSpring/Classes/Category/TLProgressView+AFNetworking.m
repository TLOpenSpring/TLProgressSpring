//
//  TLProgressView+AFNetworking.m
//  Pods
//
//  Created by Andrew on 16/5/25.
//
//

#import "TLMethodCopyUtil.h"
#import <UIKit/UIKit.h>
#import "TLProgressView.h"

@implementation TLProgressView (AFNetworking)
/**
 *  在NSObject加载的时候
 */
+(void)load{

    
    //创建拷贝工具类
    TLMethodCopyUtil *copyUtil = [TLMethodCopyUtil copierFromClass:[UIProgressView class] toClass:self];
    [copyUtil copyInstanceMethod:@selector(setProgressWithUploadProgressOfTask:animated:)];
    
    [copyUtil copyInstanceMethod:@selector(setProgressWithDownloadProgressOfTask:animated:)];
    
    
    //内部方法
    [copyUtil copyInstanceMethod:NSSelectorFromString(@"af_uploadProgressAnimated")];
    [copyUtil copyInstanceMethod:NSSelectorFromString(@"af_setUploadProgressAnimated:")];
    [copyUtil copyInstanceMethod:NSSelectorFromString(@"af_downloadProgressAnimated")];
    [copyUtil copyInstanceMethod:NSSelectorFromString(@"af_setDownloadProgressAnimated:")];
    [copyUtil copyInstanceMethod:@selector(observeValueForKeyPath:ofObject:change:context:)];
    
}



@end
