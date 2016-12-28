//
//  LJButton.m
//  SneakerLab
//
//  Created by 郭隆基 on 16/11/10.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "LJButton.h"

@implementation LJButton

- (void)addTapBlock:(ButtonBlock)block
{
    _block = block;
    [self addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)buttonAction:(UIButton *)button
{
    _block(button);
}
@end
