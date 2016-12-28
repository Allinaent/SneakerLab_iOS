//
//  popViewController.h
//  弹框
//
//  Created by kr on 2016/10/31.
//  Copyright © 2016年 凯如科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^selectBlock)(NSString *str);
@interface popViewController : UIView
@property(nonatomic,copy)selectBlock block;
@end
