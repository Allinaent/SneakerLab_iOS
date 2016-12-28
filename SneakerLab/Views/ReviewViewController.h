//
//  ReviewViewController.h
//  SneakerLab
//
//  Created by 郭隆基 on 2016/11/24.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderHistoryModel;
@interface ReviewViewController : UIViewController
@property (nonatomic, strong) NSString *productID;
@property (nonatomic, strong) OrderHistoryModel *model;

@end
