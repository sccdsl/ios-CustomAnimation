//
//  UIView+CustomBlockAnimations.m
//  myTest
//
//  Created by sunlang on 2016/11/16.
//  Copyright © 2016年 sunlang. All rights reserved.
//

#import "UIView+CustomBlockAnimations.h"
#import <objc/runtime.h>

@interface SLSavedPopAnimationState : NSObject

@property (strong) CALayer  *layer;
@property (copy)   NSString *keyPath;
@property (strong) id        oldValue;

+ (instancetype)savedStateWithLayer:(CALayer *)layer
                            keyPath:(NSString *)keyPath;

@end

@implementation SLSavedPopAnimationState

+ (instancetype)savedStateWithLayer:(CALayer *)layer
                            keyPath:(NSString *)keyPath
{
    SLSavedPopAnimationState *savedState = [SLSavedPopAnimationState new];
    savedState.layer    = layer;
    savedState.keyPath  = keyPath;
    savedState.oldValue = [layer valueForKeyPath:keyPath];
    return savedState;
}

@end

static void *sl_currentAnimationContext = NULL;
static void *sl_popAnimationContext = &sl_popAnimationContext;

@implementation UIView (CustomBlockAnimations)

+ (void) load
{
    SEL originalSelector = @selector(actionForLayer:forKey:);
    SEL newSelector = @selector(sl_actionForLayer:forKey:);
    
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method newMethod = class_getInstanceMethod(self, newSelector);
    
    NSAssert(originalMethod, @"没有 actionForLayer:forKey:");
    NSAssert(newMethod, @"没有 sl_actionForLayer:forKey:");
    
    if (class_addMethod(self, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(self, newSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, newMethod);
    }
}

+ (NSMutableArray *)sl_savedPopAnimationStates
{
    static NSMutableArray *arr;
    if (!arr)
    {
        arr = [NSMutableArray array];
    }
    return arr;
}

//先调用的这个协议
- (id<CAAction>) sl_actionForLayer:(CALayer *)layer forKey:(NSString *)event
{
    if (sl_currentAnimationContext == sl_popAnimationContext) {
        
        [[UIView sl_savedPopAnimationStates] addObject:[SLSavedPopAnimationState savedStateWithLayer:layer
                                                                                             keyPath:event]];
        return (id<CAAction>)[NSNull null];
    }
    
    return [self sl_actionForLayer:layer forKey:event];
    
}

+ (void)sl_popAnimationWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations
{
    sl_currentAnimationContext = sl_popAnimationContext;
    
    //首先获取数据
    animations();
    
    //执行动画
    //如果多个动画组合,并行获取并执行
    [[self sl_savedPopAnimationStates] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SLSavedPopAnimationState *savedState   = (SLSavedPopAnimationState *)obj;
        CALayer *layer    = savedState.layer;
        NSString *keyPath = savedState.keyPath;
        id oldValue       = savedState.oldValue;
        id newValue       = [layer valueForKeyPath:keyPath];
        
        //创建 帧动画
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:keyPath];
        
        CGFloat easing = 0.2;
        CAMediaTimingFunction *easeIn  = [CAMediaTimingFunction functionWithControlPoints:1.0 :0.0 :(1.0-easing) :1.0];
        CAMediaTimingFunction *easeOut = [CAMediaTimingFunction functionWithControlPoints:easing :0.0 :0.0 :1.0];
        
        anim.duration = duration;
        anim.keyTimes = @[@0, @(0.35), @1];
        anim.values = @[oldValue, newValue, oldValue];
        anim.timingFunctions = @[easeIn, easeOut];
        
        // 不带动画地返回原来的值
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [layer setValue:oldValue forKeyPath:keyPath];
        [CATransaction commit];
        
        // 添加 "pop" 动画
        [layer addAnimation:anim forKey:keyPath];
        
    }];
    
    // 扫除工作 (移除所有存储的状态)
    [[self sl_savedPopAnimationStates] removeAllObjects];
    
    sl_currentAnimationContext = NULL;
}
@end
