//
//  ReturnPolicyController.m
//  caowei
//
//  Created by Jason cao on 2016/9/27.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "ReturnPolicyController.h"

@interface ReturnPolicyController ()

@end

@implementation ReturnPolicyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SET_NAV_MIDDLE
    self.title = @"Return Policy";
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
    imageView.image = returnPolicyImg;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    
}


@end
