//
//  CollectCell.m
//  SneakerLab
//
//  Created by edz on 2016/10/21.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "CollectCell.h"

@implementation CollectCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame])
    {
        [self createUI];
    }
    return self;
}
- (void)createUI
{
    _imageView = [FactoryUI createImageViewWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width) imageName:nil];
    [self.contentView addSubview:_imageView];
    _nameLabel = [FactoryUI createLabelWithFrame:CGRectMake(20, CGRectGetMaxY(_imageView.frame), self.frame.size.width - 20, 25) text:@"name" textColor:[UIColor colorWithHexString:@"#333333"] font:[UIFont systemFontOfSize:11]];
    _nameLabel.numberOfLines = 0;
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_nameLabel];
    _priceLabel1 = [FactoryUI createLabelWithFrame:CGRectMake(20, CGRectGetMaxY(_nameLabel.frame), self.frame.size.width - 20, 15) text:@"price" textColor:[UIColor colorWithHexString:@"#333333"] font:[UIFont systemFontOfSize:11]];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_priceLabel1];
}
-(void)refreshUI:(CollectModel *)model{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    _nameLabel.text = model.name;
    _priceLabel1.text = [NSString stringWithFormat:@"$%@",model.price];
    
}
@end
