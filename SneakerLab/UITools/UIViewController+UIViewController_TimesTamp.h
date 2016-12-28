//
//  UIViewController+UIViewController_TimesTamp.h
//  caowei
//
//  Created by Jason cao on 2016/9/19.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (UIViewController_TimesTamp)

// 获取时间戳
- (NSString*)getCurrentTimestamp;
+ (id)controllerWithStoryBoardName:(NSString *)name andIdentifier:(NSString *)identifier;
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view;
@end
