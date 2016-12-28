//
//  LJButton.h
//  SneakerLab
//
//  Created by 郭隆基 on 16/11/10.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ButtonBlock)(UIButton *btn);

@interface LJButton : UIButton
@property(nonatomic,copy)ButtonBlock block;
- (void)addTapBlock:(ButtonBlock)block;
@end
