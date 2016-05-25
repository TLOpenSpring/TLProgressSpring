//
//  TLProgressView+AFNetworking.h
//  Pods
//
//  Created by Andrew on 16/5/25.
//
//

#import "TLProgressView.h"
#import "TLProgressView+AFNetworking.h"

@interface TLProgressView (AFNetworking)

/**
 *  绑定进度条在上传任务的时候
 *
 *  @param task 上传
 */
-(void)setProgressWithUploadProgressOfTask:(NSURLSessionUploadTask*)task
                                  animated:(BOOL)animated;

/**
 *  绑定进度条在下载任务的时候
 *
 *  @param task 下载任务
 */
-(void)setProgressWithDownloadProgressOfTask:(NSURLSessionDownloadTask *)task
                                    animated:(BOOL)animated;


@end
