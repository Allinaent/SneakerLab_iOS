//
//  UIBarButtonItem+Extension.m
//  SneakerLab
//
//  Created by 郭隆基 on 2016/11/26.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
        [button sizeToFit];
        button.imageView.contentMode = UIViewContentModeCenter;
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        return [[self alloc] initWithCustomView:button];
    }
}
@end
