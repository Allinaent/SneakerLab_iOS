//
//  EditCardTableViewCell.h
//  SneakerLab
//
//  Created by 郭隆基 on 2016/12/6.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditCardTableViewCell : UITableViewCell
@property(nonatomic, strong) NSString *customer_id;
@property(nonatomic, strong) NSString *card_number;
@property(nonatomic, strong) NSString *card_month;
@property(nonatomic, strong) NSString *card_year;
@property(nonatomic, strong) NSString *card_cvv;
@property(nonatomic, strong) NSString *zip_code;
@property(nonatomic, strong) NSString *is_default;
@property(nonatomic, strong) NSString *credit_id;

@property(nonatomic, strong) UIButton *del;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
