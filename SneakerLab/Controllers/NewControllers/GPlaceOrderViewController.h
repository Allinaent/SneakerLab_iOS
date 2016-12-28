//
//  GPlaceOrderViewController.h
//  SneakerLab
//
//  Created by 郭隆基 on 2016/12/7.
//  Copyright © 2016年 Jason cao. All rights reserved.
//


#import <UIKit/UIKit.h>
typedef enum _LASTCONTROLLER {
    EDITCART = 0,
    MENU
} LASTCONTROLLER;

@interface GPlaceOrderViewController : UIViewController

@property (nonatomic, assign) LASTCONTROLLER from;

@end
