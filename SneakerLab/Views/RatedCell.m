//
//  RatedCell.m
//  caowei
//
//  Created by Jason cao on 2016/9/20.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "RatedCell.h"

@implementation RatedCell
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
//    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"邮戳"]];
    _imageView1 = [FactoryUI createImageViewWithFrame:CGRectMake(15, 15, (self.frame.size.width - 30) / 2, (self.frame.size.width - 30) / 2) imageName:nil];
    _imageView2 = [FactoryUI createImageViewWithFrame:CGRectMake((self.frame.size.width - 30) / 2 + 15, 15, (self.frame.size.width - 30) / 2, (self.frame.size.width - 30) / 2) imageName:nil];
     _imageView3 = [FactoryUI createImageViewWithFrame:CGRectMake(15,(self.frame.size.width - 30) / 2 + 15, (self.frame.size.width - 30) / 2, (self.frame.size.width - 30) / 2) imageName:nil];
    _imageView4 = [FactoryUI createImageViewWithFrame:CGRectMake((self.frame.size.width - 30) / 2 +15,(self.frame.size.width - 30) / 2 + 15, (self.frame.size.width - 30) / 2, (self.frame.size.width - 30) / 2) imageName:nil];
    _imageView4.backgroundColor = [UIColor redColor];
    _imageView3.backgroundColor = [UIColor whiteColor];
    _imageView2.backgroundColor = [UIColor greenColor];
    _imageView1.backgroundColor = [UIColor yellowColor];
    
    [self.contentView addSubview:_imageView4];
    [self.contentView addSubview:_imageView3];
    [self.contentView addSubview:_imageView2];
    [self.contentView addSubview:_imageView1];
}
@end
