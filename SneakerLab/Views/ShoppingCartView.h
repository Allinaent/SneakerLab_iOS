//
//  ShoppingCartView.h
//  caowei
//
//  Created by Jason cao on 2016/9/14.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddressModel;
@protocol ShopCartDelegate <NSObject>

-(void)shoppingNotLogin;
-(void)shopModel:(AddressModel *)model;
@end


@interface ShoppingCartView : UIView
@property (nonatomic , strong) UIView *clearView;
@property (nonatomic , strong) UIView *noItemView;
@property (nonatomic , strong) UIView *mainView;
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) UIButton *checkOutBtn;
@property (nonatomic , strong) UILabel *cardNameLabel;
@property (nonatomic , strong) UILabel *cardNumberLabel;
@property (nonatomic , strong) UILabel *addressLabel;
@property (nonatomic , strong) UILabel *subTotalLabel;
@property (nonatomic , strong) UILabel *shippingLabel;
@property (nonatomic , strong) UILabel *taxLabel;
@property (nonatomic , strong) UILabel *totalLabel;
@property (nonatomic , strong) NSString *addressID;
@property (nonatomic , weak) id<ShopCartDelegate> shopDelegate;


-(void)refreshUI;


@end
