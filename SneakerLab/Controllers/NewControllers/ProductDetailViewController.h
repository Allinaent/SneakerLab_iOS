//
//  ProductDetailViewController.h
//  SneakerLab
//
//  Created by 郭隆基 on 16/11/11.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailViewController : UIViewController
@property (nonatomic , strong) NSString *productID;
@property (nonatomic , strong) NSString *product_option_id;
@property (nonatomic , strong) NSString *product_option_value_id;

@end