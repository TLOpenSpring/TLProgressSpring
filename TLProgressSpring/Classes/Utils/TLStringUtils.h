//
//  TLStringUtils.h
//  Pods
//
//  Created by Andrew on 16/5/20.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TLStringUtils : NSObject
+(NSAttributedString *)getAttibutesForTitle:(NSString *)title
                                      color:(UIColor *)tintColor;
@end
