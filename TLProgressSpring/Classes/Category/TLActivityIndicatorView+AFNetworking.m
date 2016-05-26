//
//  TLActivityIndicatorView+AFNetworking.m
//  Pods
//
//  Created by Andrew on 16/5/25.
//
//

#import "TLActivityIndicatorView+AFNetworking.h"
#import <objc/runtime.h>

@interface AFActivityIndicatorViewNotificationObserver : NSObject
@property (nonatomic,weak,readonly)UIActivityIndicatorView *activityIndicatorView;

-(id)initWithActivityIndicatorView:(UIActivityIndicatorView*)activityIndicatorView;

-(void)setAnimatingWithStateOfTask:(NSURLSessionTask *)task;

@end


@implementation TLActivityIndicatorView (AFNetworking)


-(AFActivityIndicatorViewNotificationObserver *)TL_notificationObserver{

    AFActivityIndicatorViewNotificationObserver *observer = objc_getAssociatedObject(self, @selector(TL_notificationObserver));
    if(observer == nil){
        observer = [[AFActivityIndicatorViewNotificationObserver alloc]initWithActivityIndicatorView:(UIActivityIndicatorView*)self];
        objc_setAssociatedObject(self, @selector(TL_notificationObserver), observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return observer;
}

- (void)setAnimatingWithStateOfTask:(NSURLSessionTask *)task{
    [[self TL_notificationObserver] setAnimatingWithStateOfTask:task];
}

@end
