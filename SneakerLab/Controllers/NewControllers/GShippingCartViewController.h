//
//  GShippingCartViewController.h
//  SneakerLab
//
//  Created by 郭隆基 on 2016/12/7.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReloadBlock)();
@interface GShippingCartViewController : UIViewController
@property (nonatomic, copy) ReloadBlock reloadBlock;
- (void)requestdatas;
@end
