//
//  MenuController.h
//  caowei
//
//  Created by Jason cao on 16/8/30.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuController : UIViewController
@property (nonatomic,copy)  void (^exitLeftSideblock)();
@property (nonatomic ,copy) void (^myblock)(NSInteger index);
@property(nonatomic,copy)NSString *userName;

- (void)logoutAction;

@end
