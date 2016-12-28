//
//  GShippingAddressViewController.h
//  SneakerLab
//
//  Created by 郭隆基 on 2016/12/8.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GShippingAddressViewController : UIViewController
@property (nonatomic, strong) NSString *type;//billing
- (void)requestdatas;
@end
