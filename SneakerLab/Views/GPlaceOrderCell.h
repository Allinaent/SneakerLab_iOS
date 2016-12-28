//
//  GPlaceOrderCell.h
//  SneakerLab
//
//  Created by 郭隆基 on 2016/12/7.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPlaceOrderCell : UITableViewCell
@property (nonatomic, strong) NSString *head;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *lowprice;
@property (nonatomic, strong) NSString *highprice;
@property (nonatomic, strong) NSString *num;

@property (nonatomic, strong) UILabel *sizeL;
@property (nonatomic, strong) UILabel *colorL;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
