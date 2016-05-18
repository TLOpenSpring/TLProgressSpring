//
//  TLOverlayController.h
//  TLProgressSpring
//
//  Created by Andrew on 16/5/18.
//  Copyright © 2016年 Andrew. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProgressOverlayTableViewControllerDelegate <NSObject>

- (UIView *)viewForProgressOverlay;

@end


@interface TLOverlayController : UIViewController
@property (nonatomic, weak) id<ProgressOverlayTableViewControllerDelegate> delegate;
@end
