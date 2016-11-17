//
//  CustomLayer.m
//  myTest
//
//  Created by sunlang on 2016/11/16.
//  Copyright © 2016年 sunlang. All rights reserved.
//

#import "CustomLayer.h"

@implementation CustomLayer

- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"CustomLayer init");
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)setPosition:(CGPoint)position
{
    [super setPosition:position];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
}

- (void)addAnimation:(CAAnimation *)anim forKey:(NSString *)key
{
    NSLog(@"adding animation:%@", [anim debugDescription]);
    [super addAnimation:anim forKey:key];
}

@end
