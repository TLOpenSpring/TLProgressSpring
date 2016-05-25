//
//  TLMethodCopyUtil.h
//  Pods
//
//  Created by Andrew on 16/5/25.
//
//

#import <Foundation/Foundation.h>

@interface TLMethodCopyUtil : NSObject


/**
 *  原始的类，将要把目标的方法拷贝到这个类中
 */
@property (nonatomic,strong)Class originClass;

/**
 *  目标的类
 */
@property (nonatomic,strong)Class targetClass;

+(instancetype)copierFromClass:(Class)originClass
                       toClass:(Class)targetClass;

-(void)copyInstanceMethod:(SEL)selector;

@end
