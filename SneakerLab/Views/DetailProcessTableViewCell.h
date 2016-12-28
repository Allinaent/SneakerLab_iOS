//
//  DetailProcessTableViewCell.h
//  SneakerLab
//
//  Created by edz on 2016/11/7.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderProduct.h"
@interface DetailProcessTableViewCell : UITableViewCell
@property (nonatomic , strong) UIImageView *ImageView;
@property (nonatomic , strong) UILabel *nameLabel;
@property (nonatomic , strong) UILabel *sizeLabel;
@property (nonatomic , strong) UILabel *quantityLabel;
@property (nonatomic , strong) UILabel *priceLabel;
@property (nonatomic , strong) UILabel *label ;
@property (nonatomic , strong) UILabel *quantityLabel1;
@property (nonatomic , strong) UILabel *sizelabel1;
@property (nonatomic , strong) OrderProduct *model ;
@end
