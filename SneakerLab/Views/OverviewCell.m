//
//  OverviewCellTableViewCell.m
//  caowei
//
//  Created by Jason cao on 2016/9/30.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "OverviewCell.h"

@implementation OverviewCell
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
    _starView = [FactoryUI createImageViewWithFrame:CGRectMake(10, 10, 100, 20) imageName:nil];
    _nameLabel = [FactoryUI createLabelWithFrame:CGRectMake(10, self.frame.size.height - 25, 150, 15) text:nil textColor:[UIColor colorWithHexString:@"#999999"] font:[UIFont systemFontOfSize:12]];
    _mainLabel = [FactoryUI createLabelWithFrame:CGRectMake(10, 40, SCREEN_W - 20, 100) text:nil textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14]];
    [self.contentView addSubview:_starView];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_mainLabel];
}

- (void)refreshUI:(OverviewModel *)model
{
    _nameLabel.text = model.author;
    _mainLabel.text = model.text;
}

@end
