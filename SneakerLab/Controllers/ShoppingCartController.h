//
//  ShoppingCartController.h
//  caowei
//
//  Created by Jason cao on 16/9/2.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCartController : UIViewController
@property (nonatomic , strong) UIView *clearView;
@property (nonatomic , strong) UIView *noItemView;
@property (nonatomic , strong) UITableView *mainView;
@property (nonatomic , copy) NSMutableArray *dataSource;

- (void)showShoppingCart;


@end
