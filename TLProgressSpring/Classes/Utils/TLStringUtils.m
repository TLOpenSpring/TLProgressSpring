//
//  TLStringUtils.m
//  Pods
//
//  Created by Andrew on 16/5/20.
//
//

#import "TLStringUtils.h"


@implementation TLStringUtils

+(NSAttributedString *)getAttibutesForTitle:(NSString *)title
                                      color:(UIColor *)tintColor{
//    UIColor *color=tintColor;
//    UIFont *font=[UIFont systemFontOfSize:15];
//    
//    NSDictionary *dict=@{NSForegroundColorAttributeName:color,
//                         NSFontAttributeName:font,
//                         NSKernAttributeName:@(1)};
//    
//    NSAttributedString *attriString=[[NSAttributedString alloc] initWithString:title attributes:dict];
    
    return [[self alloc]getAttibutesForTitle:title color:tintColor];
}

#pragma
#pragma mark getAttibutesForTitle

-(NSAttributedString *)getAttibutesForTitle:(NSString *)title
                                      color:(UIColor *)tintColor{
    
    if(title==nil)
        title=@"";
    
    UIColor *color=tintColor;
    UIFont *font=[UIFont systemFontOfSize:15];
    
    NSDictionary *dict=@{NSForegroundColorAttributeName:color,
                         NSFontAttributeName:font,
                         NSKernAttributeName:@(1)};
    
    NSAttributedString *attriString=[[NSAttributedString alloc] initWithString:title attributes:dict];
    return attriString;
}
@end
