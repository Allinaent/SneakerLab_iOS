//
//  GSignInViewController.m
//  SneakerLab
//
//  Created by 郭隆基 on 2016/12/20.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "GSignInViewController.h"

@interface GSignInViewController ()

@end

@implementation GSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    back.image = [UIImage imageNamed:@"背景图2"];
    [self.navigationController.view addSubview:back];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
