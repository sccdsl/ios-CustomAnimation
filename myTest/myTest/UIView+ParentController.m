//
//  UIView+ParentController.m
//  myTest
//
//  Created by sunlang on 2016/11/16.
//  Copyright © 2016年 sunlang. All rights reserved.
//

#import "UIView+ParentController.h"

@implementation UIView (ParentController)

//获取View管理它的viewController
- (UIViewController *)parentController
{
    //获取View上一个响应对象, 这整个响应链中,一个节点的上一个
    UIResponder *responder = [self nextResponder];
    while (responder) {
        //如果是controller
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    
    return nil;
}
@end
