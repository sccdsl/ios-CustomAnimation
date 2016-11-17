//
//  UIView+CustomBlockAnimations.h
//  myTest
//
//  Created by sunlang on 2016/11/16.
//  Copyright © 2016年 sunlang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CustomBlockAnimations)
+ (void)sl_popAnimationWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations;
@end
