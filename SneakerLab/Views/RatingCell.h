//
//  RatingCell.h
//  caowei
//
//  Created by Jason cao on 2016/9/29.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingModel.h"
@class MyStarView;
@interface RatingCell : UITableViewCell
@property (nonatomic , strong) MyStarView *starView;
@property (nonatomic , strong) UILabel *mainLabel;
@property (nonatomic , strong) UILabel *nameLabel;
@property (nonatomic , strong) UILabel *timeLabel;
@property (nonatomic , strong) UIImageView *headerView;

- (void)refreshUI:(RatingModel *)model;
@end
