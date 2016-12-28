//
//  OrderRatedCell.m
//  caowei
//
//  Created by Jason cao on 2016/10/9.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "OrderRatedCell.h"

@implementation OrderRatedCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithHexString:@"#ffffff"].CGColor;
    _imageView = [FactoryUI createImageViewWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width) imageName:nil];
    [self.contentView addSubview:_imageView];
}

- (void)refreshUI:(OrderRatedModel *)model
{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
}
@end
