//
//  SelectButton.h
//  SneakerLab
//
//  Created by 郭隆基 on 2016/12/6.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectButton : UIButton
@property (nonatomic, strong) UIImageView *head;
@property (nonatomic, strong) UIImageView *select;
@property (nonatomic, strong) UILabel *name;

- (instancetype)initWithImage:(NSString *)image andTitle:(NSString *)title;
@end
