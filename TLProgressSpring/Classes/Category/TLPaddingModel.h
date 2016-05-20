//
//  TLPaddingModel.h
//  Pods
//
//  Created by Andrew on 16/5/20.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TLPaddingModel : NSObject


@property CGFloat dialogPadding;
@property CGFloat modePadding;
@property CGFloat dialogMargin;
@property CGFloat dialogMinWidth;

@property CGFloat dialogWidth;

-(id)initWithDialogPadding:(CGFloat)dialogPadding
               modePadding:(CGFloat)modePadding
              dialogMargin:(CGFloat)dialogMargin
            dialogMinWidth:(CGFloat)dialogMinWidth;

@end
