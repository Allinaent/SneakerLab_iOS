//
//  ShippingViewController.m
//  SneakerLab
//
//  Created by 郭隆基 on 2016/11/20.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "ShippingViewController.h"
#import "Shipping.h"
@interface ShippingViewController ()

@end

@implementation ShippingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Details";
    self.view.backgroundColor = [UIColor whiteColor];
    Shipping *view = [[Shipping alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
