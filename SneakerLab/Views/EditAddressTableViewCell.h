//
//  EditAddressTableViewCell.h
//  SneakerLab
//
//  Created by 郭隆基 on 2016/12/8.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditAddressTableViewCell : UITableViewCell
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *phone;
@property(nonatomic, strong) NSString *street;
@property(nonatomic, strong) NSString *city;
@property(nonatomic, strong) NSString *country;
@property(nonatomic, strong) NSString *address_id;
@property(nonatomic, strong) NSNumber *set_default;
@property(nonatomic, strong) NSString *apt;
@property(nonatomic, strong) NSString *postcode;
@property(nonatomic, strong) NSString *country_id;
@property(nonatomic, strong) NSString *zone_id;

@property(nonatomic, strong) UIButton *del;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
