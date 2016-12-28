//
//  ProductRatingHeaderView.m
//  SneakerLab
//
//  Created by 郭隆基 on 16/11/7.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "ProductRatingHeaderView.h"
#import "RatingHeadModel.h"
#import "MyStarView.h"

@interface ProductRatingHeaderView ()
{
    
}
@property (nonatomic, strong) UIImageView *productImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *boughtNumLabel;
@property (nonatomic, strong) UILabel *saveNumLabel;
@property (nonatomic, strong) MyStarView *starView;
@property (nonatomic, strong) UILabel *ratingLabel;
@end


@implementation ProductRatingHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.model = [[RatingHeadModel alloc] init];
        _productImageView   = [[UIImageView alloc] init];
        _titleLabel         = [[UILabel alloc] init];
        _boughtNumLabel     = [[UILabel alloc] init];
        _saveNumLabel       = [[UILabel alloc] init];
        _starView           = [[MyStarView alloc] init];
        _ratingLabel        = [[UILabel alloc] init];
        [self addSubview:_productImageView];
        [self addSubview:_titleLabel];
        [self addSubview:_boughtNumLabel];
        [self addSubview:_saveNumLabel];
        [self addSubview:_starView];
        [self addSubview:_ratingLabel];
    }
    return self;
}

- (void)refreshUI
{
    
    [_productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(15);
        make.left.equalTo(self.mas_left).with.offset(7);
        make.size.mas_equalTo(CGSizeMake(64, 64));
    }];
    [_productImageView sd_setImageWithURL:[NSURL URLWithString:self.model.imageUrl]];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(13.5);
        make.left.equalTo(_productImageView.mas_right).with.offset(10);
    }];
    
    _titleLabel.text = self.model.name;
    _titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:16];
    _titleLabel.textColor = COLOR_3;
    
    [_boughtNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(4.5);
        make.left.equalTo(_titleLabel.mas_left);
    }];
    _boughtNumLabel.font = [UIFont fontWithName:DEFAULT_FONT size:14];
    _boughtNumLabel.textColor = COLOR_9;
    _boughtNumLabel.text = [NSString stringWithFormat:@"Bought By:%@ people", self.model.boughtNum];
    
    [_saveNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_boughtNumLabel.mas_bottom).with.offset(4.5);
        make.left.equalTo(_titleLabel.mas_left);
    }];
    _saveNumLabel.font = [UIFont fontWithName:DEFAULT_FONT size:14];
    _saveNumLabel.textColor = COLOR_9;
    _saveNumLabel.text = [NSString stringWithFormat:@"Save By:%@ people", @"0"];
    [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(6.5);
        make.top.equalTo(_productImageView.mas_bottom).with.offset(8);
        make.size.mas_equalTo(CGSizeMake(87.5, 12));
    }];
    [self.starView withStar:self.model.starNum :87.5 :12];
    [_ratingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(8.5);
        make.top.equalTo(_starView.mas_bottom).with.offset(5);
    }];
    _ratingLabel.font = [UIFont fontWithName:DEFAULT_FONT size:13];
    _ratingLabel.textColor = COLOR_9;
    _ratingLabel.text = [NSString stringWithFormat:@"(%@ ratings)", self.model.ratingNum];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}



@end
