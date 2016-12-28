//
//  GProductDetailViewController.h
//  SneakerLab
//
//  Created by 郭隆基 on 2016/12/8.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GProductDetailViewController : UIViewController
@property (nonatomic , strong) NSString *productID;
@property (nonatomic , strong) NSString *product_option_id;
@property (nonatomic , strong) NSString *product_option_value_id;

//为了小红点
//cart
@property (nonatomic, strong) UIButton *cart;
@property (nonatomic, assign) NSUInteger cartnum;
@end
