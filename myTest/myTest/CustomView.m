//
//  CustomView.m
//  myTest
//
//  Created by sunlang on 2016/11/16.
//  Copyright © 2016年 sunlang. All rights reserved.
//

#import "CustomView.h"
#import "CustomLayer.h"

@implementation CustomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"CustomView init");
    }
    return self;
}

+ (Class)layerClass
{
    return [CustomLayer class];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)setCenter:(CGPoint)center
{
    [super setCenter:center];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
