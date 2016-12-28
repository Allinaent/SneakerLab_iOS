//
//  UIBarButtonItem+Extension.h
//  SneakerLab
//
//  Created by 郭隆基 on 2016/11/26.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

@end
