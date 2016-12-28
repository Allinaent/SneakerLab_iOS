//
//  OrderHistoryCell.h
//  caowei
//
//  Created by Jason cao on 2016/9/9.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderProduct.h"
@interface OrderHistoryCell : UITableViewCell

@property (nonatomic, strong) UIImageView *ImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UILabel *colorLabel;
@property (nonatomic, strong) UILabel *quantityLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *label ;
@property (nonatomic, strong) UILabel *quantityLabel1;
@property (nonatomic, strong) UILabel *colorLabel1;
@property (nonatomic, strong) UILabel *sizelabel1;
@property (nonatomic, strong) NSString *sizeName;
@property (nonatomic, strong) OrderProduct *model;//cell的model
@property (nonatomic, assign) CGFloat cellheight;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
