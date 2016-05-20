//
//  TLPaddingModel.m
//  Pods
//
//  Created by Andrew on 16/5/20.
//
//

#import "TLPaddingModel.h"

@implementation TLPaddingModel
-(id)initWithDialogPadding:(CGFloat)dialogPadding
               modePadding:(CGFloat)modePadding
              dialogMargin:(CGFloat)dialogMargin
            dialogMinWidth:(CGFloat)dialogMinWidth{
    self=[super init];
    if(self){
        _dialogMargin=dialogMargin;
        _dialogPadding=dialogPadding;
        _dialogMinWidth=dialogMinWidth;
        _modePadding=modePadding;
    }
    return self;
}
@end
