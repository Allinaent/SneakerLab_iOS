//
//  ShoppingCartCell.h
//  caowei
//
//  Created by Jason cao on 16/9/8.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingCartModel.h"
#import "MyStarView.h"
#import "EditView.h"
@interface ShoppingCartCell : UITableViewCell
@property (nonatomic , strong) UIImageView *ImageView;
@property (nonatomic , strong) MyStarView *starSView;
@property (nonatomic , strong) UILabel *nameLabel;
@property (nonatomic , strong) UILabel *sizeLabel;
@property (nonatomic , strong) UILabel *colorLabel;
@property (nonatomic , strong) UILabel *quantityLabel;
@property (nonatomic , strong) UILabel *shippingLabel;
@property (nonatomic , strong) UILabel *nowPriceLabel;
@property (nonatomic , strong) UILabel *oldPriceLabel;
@property (nonatomic , strong) UILabel *reviewedLabel;
@property (nonatomic , copy) NSString *cartId;
@property(nonatomic,copy )NSString *size;


@property (nonatomic , copy) void(^deleteBlock) (ShoppingCartCell *cell);
@property (nonatomic , copy) void(^editBlock) (ShoppingCartCell *cell, NSInteger quantity);

- (void)refreshUI:(ShoppingCartModel *)model;
@end
