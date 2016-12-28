//
//  ShoppingCartController.m
//  caowei
//
//  Created by Jason cao on 16/9/2.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "ShoppingCartController.h"
#import "ShoppingCartView.h"
#import "SignInController.h"
@interface ShoppingCartController ()<ShopCartDelegate>

@end

@implementation ShoppingCartController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"My ShoppingCart";
    self.view.backgroundColor = [UIColor whiteColor];
    
}

#pragma mark ----弹出购物车
- (void)showShoppingCart
{
    ShoppingCartView *shoppingView = [[ShoppingCartView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    shoppingView.shopDelegate = self;
    [shoppingView.clearView removeFromSuperview];
    shoppingView.noItemView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    shoppingView.mainView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    shoppingView.tableView.frame = CGRectMake(0, 300, SCREEN_W, SCREEN_H - 270);
    shoppingView.checkOutBtn.frame = CGRectMake(10, SCREEN_H - 120, SCREEN_W - 20 , 40);
    [shoppingView.mainView addSubview:shoppingView.tableView];
    [shoppingView.mainView addSubview:shoppingView.checkOutBtn];
    [shoppingView refreshUI];
    [self.view addSubview:shoppingView];
    [UIView animateWithDuration: 0.35 animations: ^{
        shoppingView.center = self.view.center;
        shoppingView.frame =CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    } completion: nil];
}

-(void)shoppingNotLogin {
    SignInController *vc = [[SignInController alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
}

-(void)shopModel:(AddressModel *)model{

    
}

@end
