//
//  AppDelegate.h
//  caowei
//
//  Created by Jason cao on 16/8/30.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSlideViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LeftSlideViewController *LeftSlideVC;
@property (strong, nonatomic) UINavigationController *mainNavigationController;
@end

