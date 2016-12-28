//
//  LJDetailViewController.h
//  SneakerLab
//
//  Created by 郭隆基 on 16/11/10.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>

//不要用storyboard了

@interface LJDetailViewController : UIViewController
@property (nonatomic , strong) NSString *productID;
@property (nonatomic , strong) NSString *product_option_id;
@property (nonatomic , strong) NSString *product_option_value_id;

@end
