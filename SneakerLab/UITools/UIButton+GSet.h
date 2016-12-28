//
//  UIButton+GSet.h
//  SneakerLab
//
//  Created by 郭隆基 on 16/11/10.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (GSet)

@property (nonatomic, assign) NSTimeInterval zhw_acceptEventInterval;//添加点击事件的间隔时间
@property (nonatomic, assign) BOOL zhw_ignoreEvent;//是否忽略点击事件,不响应点击事件

- (void)setSelectedImage:(UIImage *)uImage andUnselectedImage:(UIImage *)sImage;
- (void)setSelectedImageStr:(NSString *)sStr andUnselectImageStr:(NSString *)uStr;
@end
