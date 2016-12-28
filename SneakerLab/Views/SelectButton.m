//
//  SelectButton.m
//  SneakerLab
//
//  Created by 郭隆基 on 2016/12/6.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "SelectButton.h"

@implementation SelectButton

- (instancetype)initWithImage:(NSString *)image andTitle:(NSString *)title {
    self = [super init];
    self.head = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13.5, 23, 23)];
    self.head.image = [UIImage imageNamed:image];
    [self addSubview:_head];
    self.select = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20.5, 20.5)];
    self.select.image = [UIImage imageNamed:@"xuanzhong"];
    self.name = [[UILabel alloc] initWithFrame:CGRectMake(48, 17.5, 100, 15.5)];
    _name.textAlignment = 0;
    _name.font = FONT_13;
    _name.textColor = COLOR_3;
    _name.text = title;
    [self addSubview:_name];
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        _head.frame = CGRectMake(50, 13.5, 23, 23);
        _name.frame = CGRectMake(83, 17.5, 100, 15.5);
        [self addSubview:_select];
    }else{
        _head.frame = CGRectMake(15, 15, 20.5, 20.5);
        _name.frame = CGRectMake(48, 17.5, 100, 15.5);
        [_select removeFromSuperview];
    }
}

@end
