//
//  ViewController.m
//  myTest
//
//  Created by sunlang on 2016/11/16.
//  Copyright © 2016年 sunlang. All rights reserved.
//

#import "ViewController.h"
#import "UIView+ParentController.h"
#import "CustomView.h"
#import "UIView+CustomBlockAnimations.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CustomView *cv = [[CustomView alloc] initWithFrame:(CGRect){200, 200, 50, 100}];
    cv.tag = 999;
    cv.backgroundColor = [UIColor redColor];
    [self.view addSubview:cv];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)logvc:(id)sender {
    
    CustomView *cv = [self.view viewWithTag:999];
    [UIView sl_popAnimationWithDuration:1 animations:^{
        CGRect rect = cv.frame;
        rect.origin.x = 50;
        cv.frame = rect;
        cv.alpha = 0.0;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
