//
//  TLIconView.h
//  Pods
//
//  Created by Andrew on 16/5/21.
//
//

#import <UIKit/UIKit.h>

@interface TLIconView : UIView

-(UIBezierPath *)path;

@property CGFloat borderWidth;

@property CGFloat lineWidth;

@end

@interface TLCheckMarkIconView : TLIconView

@end

@interface TLCrossIconView : TLIconView

@end
