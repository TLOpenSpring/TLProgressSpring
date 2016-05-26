//
//  TLOverlayProgressView+AFNetworking.m
//  Pods
//
//  Created by Andrew on 16/5/25.
//
//

#import "TLOverlayProgressView+AFNetworking.h"
#import "TLOverlayProgressView.h"
#import <AFNetworking/AFNetworking.h>
#import <objc/runtime.h>
#import "TLProgressView+AFNetworking.h"
#import "AFURLSessionManager.h"
#import "TLActivityIndicatorView+AFNetworking.h"


static void * TLTaskCountOfBytesSentContext     = &TLTaskCountOfBytesSentContext;
static void * TLTaskCountOfBytesReceivedContext = &TLTaskCountOfBytesReceivedContext;


@interface TLOverlayProgressView()
@property (nonatomic,strong)NSURLSessionTask *sessionTask;
@property (nonatomic,strong)AFURLConnectionOperation *operation;

@end

@implementation TLOverlayProgressView (AFNetworking)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //交换方法
        SEL originalSelector = @selector(observeValueForKeyPath:ofObject:change:context:);
        SEL swizzledSelector = @selector(tl_observeValueForKeyPath:ofObject:change:context:);
        
        
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        
        BOOL success = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if(success){
            //交换方法
            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }else{
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
    });
}


-(void)setModeAndProgressWithStateOfTask:(NSURLSessionTask *)task{
    self.sessionTask = task;
    [self tl_unregisterObserver];
    
    if(task){
        if(task.state != NSURLSessionTaskStateCompleted){
            if(task.state==NSURLSessionTaskStateRunning){
                if(self.hidden){
                    [self showAnimated:YES];
                }
            }else{
                [self dismiss:YES];
            }
            
            //observe state
            NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
            [notiCenter addObserver:self selector:@selector(tl_show:) name:AFNetworkingTaskDidResumeNotification object:task];
            [notiCenter addObserver:self selector:@selector(tl_hide:) name:AFNetworkingTaskDidSuspendNotification object:task];
            [notiCenter addObserver:self selector:@selector(tl_hide:) name:AFNetworkingTaskDidCompleteNotification object:task];
            
            //对进度条进行监听
            [task addObserver:self forKeyPath:NSStringFromSelector(@selector(countOfBytesSent)) options:0 context:TLTaskCountOfBytesSentContext];
            [task addObserver:self forKeyPath:NSStringFromSelector(@selector(countOfBytesReceived)) options:0 context:TLTaskCountOfBytesReceivedContext];
        }
        else{
            [self dismiss:YES];
        }
    }
}


-(void)tl_unregisterObserver{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:AFNetworkingTaskDidResumeNotification object:nil];
    [center removeObserver:self name:AFNetworkingTaskDidSuspendNotification object:nil];
    [center removeObserver:self name:AFNetworkingTaskDidCompleteNotification object:nil];
    
    @try {
        
        [self.sessionTask removeObserver:self forKeyPath:NSStringFromSelector(@selector(countOfBytesSent))];
        
        [self.sessionTask removeObserver:self forKeyPath:NSStringFromSelector(@selector(countOfBytesReceived))];
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
}

-(void)setStopBlockForTask:(__weak NSURLSessionTask *)task{
    if(task){
        self.tlStopOverlayBlock = ^(TLOverlayProgressView *self){
            [self tl_unregisterObserver];
            [self dismiss:YES];
            [task cancel];
        };
    }else{
        self.tlStopOverlayBlock = nil;
    }
}

#pragma mark
#pragma mark -- Getter And Setter properties
-(void)setSessionTask:(NSURLSessionTask *)sessionTask{
    objc_setAssociatedObject(self, @selector(sessionTask), sessionTask, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}
-(NSURLSessionTask*)sessionTask{
    return objc_getAssociatedObject(self, @selector(sessionTask));
}

#pragma mark
#pragma mark 调用显示出动画视图
-(void)tl_show:(NSNotification *)noti{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.hidden){
            [self showAnimated:YES];
        }
    });
}
-(void)tl_hide:(NSNotification *)noti{
    dispatch_async(dispatch_get_main_queue(), ^{
        //注销监听
        [self tl_unregisterObserver];
        
        if(self.sessionTask.error || noti.userInfo[AFNetworkingTaskDidCompleteErrorKey]){
          self.titlelb.text=@"服务器出现错误~";
            self.overlayStyle = TLOverlayStyleCrossIcon;
        }else{
         self.titlelb.text=@"Success";
            self.overlayStyle = TLOverlayStyleCheckmarkIcon;
        }
        //延迟一会关闭
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismiss:YES];
        });
    });
}

#pragma mark
#pragma mark -- 自定义的键值观察
-(void)tl_observeValueForKeyPath:(NSString *)keyPath
                        ofObject:(id)object
                          change:(NSDictionary *)change
                         context:(void *)context{
    if(context == TLTaskCountOfBytesSentContext || context == TLTaskCountOfBytesReceivedContext){
     
        if([keyPath isEqualToString:NSStringFromSelector(@selector(countOfBytesSent))]){
            if([object countOfBytesExpectedToSend]>0){
                [self tl_showUploading];
                
                @try {
                    [object removeObserver:self forKeyPath:NSStringFromSelector(@selector(countOfBytesSent))];
                    
                } @catch (NSException *exception) {
                    
                }
            }
        }else if([keyPath isEqualToString:NSStringFromSelector(@selector(countOfBytesReceived))]){
            if([object countOfBytesExpectedToReceive]>0){
                [self tl_showDownloading];
               
                
                @try {
                    [object removeObserver:self forKeyPath:NSStringFromSelector(@selector(countOfBytesReceived))];
                } @catch (NSException *exception) {
                    
                } @finally {
                    
                }
            }
        }
        
        return;
    }
    //调动自己
    [self tl_observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}


#pragma mark
#pragma mark -- Help private methods

-(void)tl_showUploading{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.titlelb.text=@"uploading...";
        
        if(self.overlayStyle !=TLOverlayStyleDeterminateCircular &&
           self.overlayStyle != TLOverlayStyleHorizontalBar){
            self.overlayStyle = TLOverlayStyleDeterminateCircular;
        }
        
        [(TLProgressView*)self.modeView setProgressWithUploadProgressOfTask:(NSURLSessionUploadTask*)self.sessionTask animated:YES];
    });
}

-(void)tl_showDownloading{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.titlelb.text=@"downloading...";
      
        if(self.overlayStyle !=TLOverlayStyleDeterminateCircular &&
           self.overlayStyle != TLOverlayStyleHorizontalBar){
           self.overlayStyle = TLOverlayStyleDeterminateCircular;
        }
        [(TLProgressView*)self.modeView setProgressWithDownloadProgressOfTask:(NSURLSessionDownloadTask*)self.sessionTask animated:YES];
    });
}


@end









