//
//  RatingCell.m
//  caowei
//
//  Created by Jason cao on 2016/9/29.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "RatingCell.h"
#import "MyStarView.h"

@implementation RatingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    _starView = [[MyStarView alloc] initWithFrame:CGRectMake(SCREEN_W - 100, 10, 87.5, 12)];
    _headerView = [FactoryUI createImageViewWithFrame:CGRectMake(10, 10, 60, 60) imageName:@"头像_product rating"];
    _nameLabel = [FactoryUI createLabelWithFrame:CGRectMake(80, 10, SCREEN_W - 160, 20) text:@"name" textColor:[UIColor blackColor] font:[UIFont boldSystemFontOfSize:18]];
    _timeLabel = [FactoryUI createLabelWithFrame:CGRectMake(80, 30, 100, 20) text:@"time" textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:14]];
    _mainLabel = [FactoryUI createLabelWithFrame:CGRectMake(80, 40, SCREEN_W - 85, 60) text:nil textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:13]];
    _mainLabel.numberOfLines = 0;
    [self.contentView addSubview:_starView];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_headerView];
    [self.contentView addSubview:_mainLabel];
    [self.contentView addSubview:_timeLabel];
}

- (void)refreshUI:(RatingModel *)model
{
    _nameLabel.text = model.author;
    _mainLabel.text = model.text;
    _timeLabel.text = model.data_added;
    [_starView withStar:[model.rating floatValue] :87.5 :12];
    [_mainLabel sizeToFit];
    self.frame = CGRectMake(0, 0, SCREEN_W, 40+_mainLabel.frame.size.height);
}

@end
