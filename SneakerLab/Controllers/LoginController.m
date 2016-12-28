//
//  LoginController.m
//  caowei
//
//  Created by Jason cao on 2016/9/12.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "LoginController.h"
#import "SignInController.h"
#import "RegisterController.h"
#import "RootViewController.h"
#import "AppDelegate.h"
#import "MenuController.h"
#import <Masonry.h>
@interface LoginController ()

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //UIImageView *bgImageView = [FactoryUI createImageViewWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) imageName:@"背景"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    bgImageView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    bgImageView.userInteractionEnabled = YES;
    bgImageView.image = backgroundImg;
    [self.view addSubview:bgImageView];
    
    UIView *centerView = [FactoryUI createViewWithFrame:CGRectMake(SCREEN_W/6, SCREEN_H/4, SCREEN_W - SCREEN_W/3, SCREEN_H/2)];
    centerView.backgroundColor = [UIColor whiteColor];
    centerView.userInteractionEnabled = YES;
    [bgImageView addSubview:centerView];
    //UIImageView *logoView = [FactoryUI createImageViewWithFrame:CGRectMake(centerView.frame.size.width / 2 - 50, 40, 100, 100) imageName:@"80x80"];
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(centerView.frame.size.width / 2 - 50, 40, 100, 100)];
    logoView.image = iconImg;
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    logoView.layer.cornerRadius = logoView.frame.size.width / 2;
    logoView.layer.masksToBounds = YES;
    logoView.backgroundColor = [UIColor cyanColor];
    [centerView addSubview:logoView];
    
    
    
    
    
    UIButton *skipBtn = [FactoryUI createButtonWithFrame:CGRectMake(centerView.frame.size.width - 45, centerView.frame.size.height - 20, 40, 15) title:@"skip" titleColor:[UIColor lightGrayColor] imageName:nil backgroundImageName:nil target:self selector:@selector(skipAction1)];
    [centerView addSubview:skipBtn];
    
    UIButton *loginBtn = [FactoryUI createButtonWithFrame:CGRectMake(10, skipBtn.frame.origin.y-50, centerView.frame.size.width - 20, 40) title:@"Login" titleColor:[UIColor whiteColor] imageName:nil backgroundImageName:nil target:self selector:@selector(loginAction)];
    loginBtn.layer.cornerRadius = 3;
    loginBtn.backgroundColor = [UIColor colorWithHexString:@"#da493c"];
    [centerView addSubview:loginBtn];
    
    UIButton *registerBtn = [FactoryUI createButtonWithFrame:CGRectMake(10, loginBtn.frame.origin.y-50, centerView.frame.size.width -20, 40) title:@"Create Account" titleColor:[UIColor whiteColor] imageName:nil backgroundImageName:nil target:self selector:@selector(registerAction)];
    registerBtn.layer.cornerRadius = 3;
    registerBtn.backgroundColor = [UIColor colorWithHexString:@"#da493c"];
    [centerView addSubview:registerBtn];
    
}

#pragma mark ---按钮点击事件
- (void)registerAction
{
    RegisterController *registerVC = [[RegisterController alloc] init];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)loginAction
{
    SignInController *signInVC = [[SignInController alloc] init];
    self.navigationController.navigationBarHidden = NO;
    if ([self.fromController isEqualToString:@"productDetail"]) {
        signInVC.fromController = self.fromController;
    }
    [self.navigationController pushViewController:signInVC animated:YES];
}

#pragma mark - 游客模式登录
- (void)skipAction1
{
    [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:@"signInSuccessful"];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    MenuController *leftVC = [[MenuController alloc] init];
    RootViewController *rootVC = [[RootViewController alloc] init];
    tempAppDelegate.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:rootVC];
    tempAppDelegate.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:tempAppDelegate.mainNavigationController];
    tempAppDelegate.window.rootViewController = tempAppDelegate.LeftSlideVC;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
     self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
