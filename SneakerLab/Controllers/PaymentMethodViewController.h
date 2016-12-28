//
//  PaymentMethodViewController.h
//  SneakerLab
//
//  Created by 郭隆基 on 2016/12/6.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentMethodViewController : UIViewController
//如果选择的信用卡，需要传过来
@property (nonatomic, strong) NSString *card_id;
- (void)requestdatas;
@end
