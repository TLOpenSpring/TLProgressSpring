//
//  TLMethodCopyUtil.m
//  Pods
//
//  Created by Andrew on 16/5/25.
//
//

#import "TLMethodCopyUtil.h"
#import <objc/runtime.h>

@implementation TLMethodCopyUtil
+(instancetype)copierFromClass:(Class)originClass
                       toClass:(Class)targetClass{
    
    TLMethodCopyUtil *copy = [self new];
    copy.originClass=originClass;
    copy.targetClass=targetClass;
    return copy;
    

}

-(void)copyInstanceMethod:(SEL)selector{
    Method originMethod = class_getInstanceMethod(self.originClass, selector);
    IMP originImplemetion =method_getImplementation(originMethod);
    
  
    NSAssert(originImplemetion!=NULL, @"在原始类:%@ 中 没有发现这个方法: %@",self.originClass,  NSStringFromSelector(selector));
    
    const char *methodTypes = method_getTypeEncoding(originMethod);
    
    BOOL success = class_addMethod(self.targetClass, selector, originImplemetion, methodTypes);
    
    
    NSAssert(success, @"从原始类:%@ 中拷贝方法:%@ 到目标类:%@ 失败了",self.originClass,NSStringFromSelector(selector),_targetClass);
    
    
    
    
}
@end
