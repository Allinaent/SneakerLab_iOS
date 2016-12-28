//
//  ShopView.m
//  SneakerLab
//
//  Created by edz on 2016/10/26.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "ShopView.h"

@implementation ShopView

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }

    return self;

}
-(void)creatUI{
    _label1 = [FactoryUI createLabelWithFrame:CGRectMake(10, 20, 60, 20) text:@"Ship To:" textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:14]];
    [self addSubview:_label1];
    _label2 =[FactoryUI createLabelWithFrame:CGRectMake(10, 70, 60, 20) text:@"Bill To:" textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:14]];
    [self addSubview:_label2];
    _item = [FactoryUI createLabelWithFrame:CGRectMake(10, 140, 120, 20) text:@"Item Total" textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:14]];
    [self addSubview:_item];
    _Estima=[FactoryUI createLabelWithFrame:CGRectMake(10, 160, 150, 20) text:@"Estimated Shipping" textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:14]];
    [self addSubview:_Estima];
      _order =[FactoryUI createLabelWithFrame:CGRectMake(10,180 , 100, 20) text:@"Order Total" textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:14]];
    [self addSubview:_order];
    
    _adress1 =[FactoryUI createLabelWithFrame:CGRectMake(SCREEN_W -130, 10, 120, 20) text:nil textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14]];
    _adress1.textAlignment = NSTextAlignmentRight;
    [self addSubview:_adress1];

    _payment1 = [FactoryUI createLabelWithFrame:CGRectMake(SCREEN_W -130, 70, 120, 20) text:nil textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14]];
    _payment1.textAlignment = NSTextAlignmentRight;
    [self addSubview:_payment1];
    
    _subtotal = [FactoryUI createLabelWithFrame:CGRectMake(SCREEN_W -130, 100, 120, 20) text:nil textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14]];
    _subtotal.textAlignment = NSTextAlignmentRight;
    [self addSubview:_subtotal];
    _Total = [FactoryUI createLabelWithFrame:CGRectMake(SCREEN_W -130, 110, 120, 20) text:nil  textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14]];
    _Total.textAlignment = NSTextAlignmentRight;
    [self addSubview:_Total];
}

- (void)editCardInfo {
    
}

-(void)setModel:(AddressModel *)model{
    _adress1.text = [NSString stringWithFormat:@"%@ %@",model.city,model.address_1];
}

-(void)setModel1:(PayModel *)model1{
    
    _payment1.text = model1.card_number;
}


-(void)setModel2:(Tatals *)model2{
    _subtotal.text = model2.text;
    _Total.text = model2.text;
}

@end
