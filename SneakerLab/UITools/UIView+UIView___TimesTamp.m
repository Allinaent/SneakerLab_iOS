//
//  UIView+UIView___TimesTamp.m
//  caowei
//
//  Created by Jason cao on 2016/9/23.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "UIView+UIView___TimesTamp.h"

@implementation UIView (UIView___TimesTamp)

// 获取时间戳
- (NSString*)getCurrentTimestamp
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];
    return timeString;
}

@end
