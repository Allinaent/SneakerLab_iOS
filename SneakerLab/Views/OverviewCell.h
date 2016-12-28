//
//  OverviewCellTableViewCell.h
//  caowei
//
//  Created by Jason cao on 2016/9/30.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverviewModel.h"
@interface OverviewCell : UITableViewCell
@property (nonatomic , strong) UIImageView *starView;
@property (nonatomic , strong) UILabel *nameLabel;
@property (nonatomic , strong) UILabel *mainLabel;

- (void)refreshUI:(OverviewModel *)model;

@end
