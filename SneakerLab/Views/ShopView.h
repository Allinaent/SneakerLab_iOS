//
//  ShopView.h
//  SneakerLab
//
//  Created by edz on 2016/10/26.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"
#import "PayModel.h"
#import "Tatals.h"
@interface ShopView : UIView
@property(nonatomic,strong)UILabel *label1;
@property(nonatomic,strong)UILabel *label2;
@property(nonatomic,strong)UILabel *item;
@property(nonatomic,strong)UILabel *Estima;
@property(nonatomic,strong)UILabel *order;
@property(nonatomic,strong)UILabel *adress1;
@property(nonatomic,strong)AddressModel  *model;
@property(nonatomic,strong)PayModel  *model1;
@property(nonatomic,strong)Tatals  *model2;
@property(nonatomic,strong)UIButton *edittttt;
@property(nonatomic,strong)UIButton *edit1;
@property(nonatomic,strong)UILabel *payment1;
@property(nonatomic,strong)UILabel *subtotal;
@property(nonatomic,strong)UILabel *Total;
@property(nonatomic,strong)UILabel *credcard;







@end
