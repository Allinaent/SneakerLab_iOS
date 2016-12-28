//
//  UIView+Extension.h
//  caowei
//
//  Created by Jason cao on 2016/9/18.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
+ (void)showViewFrames:(UIView *)view;
- (UIViewController *)LJContentController;
+ (UIViewController *)currentViewController;
+ (UINavigationController *)currentNavigationController;
@end
