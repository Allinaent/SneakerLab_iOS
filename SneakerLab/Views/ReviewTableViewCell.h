//
//  ReviewTableViewCell.h
//  SneakerLab
//
//  Created by 郭隆基 on 2016/11/24.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReviewModel;
@interface ReviewTableViewCell : UITableViewCell
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, strong) NSString *productID;
@property (nonatomic, strong) ReviewModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
