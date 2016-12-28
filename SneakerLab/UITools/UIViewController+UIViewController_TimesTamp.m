//
//  UIViewController+UIViewController_TimesTamp.m
//  caowei
//
//  Created by Jason cao on 2016/9/19.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "UIViewController+UIViewController_TimesTamp.h"

@implementation UIViewController (UIViewController_TimesTamp)

// 获取时间戳
- (NSString*)getCurrentTimestamp
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];
    return timeString;
}

+ (id)controllerWithStoryBoardName:(NSString *)name andIdentifier:(NSString *)identifier {
    id vc = [[UIStoryboard storyboardWithName:name bundle:nil] instantiateViewControllerWithIdentifier:identifier];
    return vc;
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

@end
