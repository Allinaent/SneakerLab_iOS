//
//  ShoppingCartView.m
//  caowei
//
//  Created by Jason cao on 2016/9/14.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "ShoppingCartView.h"
#import "ShoppingCartCell.h"
#import "PayView.h"
#import "EditAddressView.h"
#import "EditPayInfoView.h"
#import "RootViewController.h"
#import "ShoppingCartModel.h"
#import "ShoppingTotalModel.h"
#import "UIView+YZTCView.h"
#import "OrderConfirmController.h"
#import "PayModel.h"
//#import "AddressInfoView.h"
//购物车没有的情况下是没有的状态
//应该是另一个样子
#pragma mark -- 修改购物车的模块
@interface ShoppingCartView ()<UITableViewDelegate,UITableViewDataSource>
{
    UIImageView * _imageView;
    AddressModel * _addressModel;
    PayModel *_payModel;
    
}
@property (nonatomic , copy) NSMutableArray *dataSource;
@end

@implementation ShoppingCartView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {   self.backgroundColor = [UIColor whiteColor];
        // [self createUI];
        [self refreshUI];

           }
    return self;
}

- (void)createUI
{
    // 透明的背景视图
    
    _clearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    _clearView.backgroundColor = [UIColor lightGrayColor];
    _clearView.alpha = 0.7;
   _imageView = [FactoryUI createImageViewWithFrame:CGRectMake(SCREEN_W/2, 20, 20, 20) imageName:@"错"];
    [_clearView addSubview:_imageView];
    UILabel *label = [FactoryUI createLabelWithFrame:CGRectMake(0, 50, SCREEN_W, 30) text:@"CONTINUE SHOPPING" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:20]];
    label.textAlignment = NSTextAlignmentCenter;
    
    [_clearView addSubview:label];
    //点击黑色透明视图choseView会消失
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [_clearView addGestureRecognizer:tap];
    [self addSubview:_clearView];
    // 购物车中无项目时的视图
    _noItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_W, SCREEN_H - 100)];
    _noItemView.backgroundColor = [UIColor whiteColor];
    UIButton *continueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    continueBtn.frame = CGRectMake(20, 240, SCREEN_W - 40, 60);
    continueBtn.backgroundColor = [UIColor colorWithHexString:@"#de4635"];
    continueBtn.layer.cornerRadius = 5;
    [continueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [continueBtn setTitle:@"CONTINUE SHOPPING" forState:UIControlStateNormal];
    [continueBtn addTarget:self action:@selector(continueShopping) forControlEvents:UIControlEventTouchUpInside];
    UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, SCREEN_W - 40, 40)];
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.text = @"You Cart Is Empty";
    [_noItemView addSubview:emptyLabel];
    [_noItemView addSubview:continueBtn];
    
    // 购物车列表视图
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(0 ,100, SCREEN_W, SCREEN_H-100)];
    _mainView.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120+70, SCREEN_W, SCREEN_H -340 ) style:UITableViewStylePlain];
    [_mainView addSubview:_tableView];
    //check out
#pragma mark -- check out
    _checkOutBtn = [FactoryUI createButtonWithFrame:CGRectMake(10, SCREEN_H - 150, SCREEN_W - 20, 40)  title:@"Check Out" titleColor:[UIColor whiteColor] imageName:nil backgroundImageName:nil target:self selector:@selector(checkOutt)];
    _checkOutBtn.layer.cornerRadius = 4;
    _checkOutBtn.backgroundColor = [UIColor colorWithHexString:@"#de4536"];
    [self addSubview:_checkOutBtn];
    [_clearView addSubview:_mainView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (UIView *)createHeaderView:(NSDictionary *)address payment:(NSDictionary *)card_number tatal:(NSArray *)array
{
    //180 + array.count * 30)
    UIView *view = [FactoryUI createViewWithFrame:CGRectMake(0, 0, SCREEN_W, 100)];
    view.backgroundColor = [UIColor clearColor];
    
    view.alpha = 0.75;
//    UIImageView *imageView = [FactoryUI createImageViewWithFrame:CGRectMake(SCREEN_W/2, 20, 20, 20) imageName:@"错"];
//    [self addSubview:imageView];
//    
//    UILabel *label = [FactoryUI createLabelWithFrame:CGRectMake(0, 50, SCREEN_W, 30) text:@"CONTINUE SHOPPING" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:20]];
//    label.textAlignment = NSTextAlignmentCenter;
//    
//    [self addSubview:label];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
//    [self addGestureRecognizer:tap];
    
    [self createUI];
    
#pragma mark ----增加一个地址和信用卡
    
    UILabel *label1 = [FactoryUI createLabelWithFrame:CGRectMake(10, 120, 60, 20) text:@"Ship To:" textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:14]];
   [self addSubview:label1];
    UILabel *label2 =[FactoryUI createLabelWithFrame:CGRectMake(10, 170, 60, 20) text:@"Bill To:" textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:14]];
    [self addSubview:label2];
    UILabel *item = [FactoryUI createLabelWithFrame:CGRectMake(10, 230, 120, 20) text:@"Item Total" textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:14]];
    [self addSubview:item];
    UILabel *Estima=[FactoryUI createLabelWithFrame:CGRectMake(10, 250, 150, 20) text:@"Estimated Shipping" textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:14]];
    [self addSubview:Estima];
    UILabel *order =[FactoryUI createLabelWithFrame:CGRectMake(10, 270, 100, 20) text:@"Order Total" textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:14]];
    [self addSubview:order];
    
    
    UILabel *adress1 =[FactoryUI createLabelWithFrame:CGRectMake(SCREEN_W -130, 110, 120, 20) text:[NSString stringWithFormat:@"%@ %@",address[@"city"],address[@"address_1"]] textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14]];
    
    adress1.textAlignment = NSTextAlignmentRight;
    [self addSubview:adress1];
    
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editAddress)];
//    UILabel *edit = [FactoryUI createLabelWithFrame:CGRectMake(SCREEN_W -130, 140, 120, 30) text:@"Edit"textColor: [UIColor lightGrayColor]font:[UIFont systemFontOfSize:14]];
//    
//    edit.textAlignment = NSTextAlignmentRight;
//    
//    edit.userInteractionEnabled = YES;
//
//    [edit addGestureRecognizer:tap1];
//    [view addSubview:edit];
//    UIButton *edit = [FactoryUI createButtonWithFrame:CGRectMake(SCREEN_W -85, 130, 120, 30) title:nil titleColor:[UIColor lightGrayColor] imageName:nil backgroundImageName:nil target:self selector:@selector(editAddress)];
    
    UIButton *edittttt = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W -85, 130, 120, 30)];
    edittttt.backgroundColor = [UIColor clearColor];
    [edittttt addTarget:self action:@selector(editAddress) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:edittttt];
    
    edittttt.titleLabel.font = [UIFont systemFontOfSize:14];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"Edit"];
    edittttt.titleLabel.textColor = COLOR_9;
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [edittttt setAttributedTitle:str forState:UIControlStateNormal];
//    [view addSubview:edittttt];
    UILabel *credcard = [FactoryUI createLabelWithFrame:CGRectMake(SCREEN_W -130, 165, 120, 20) text:@"Credit Card"textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14]];
    credcard.textAlignment = NSTextAlignmentRight;
    [self addSubview:credcard];
    
    UILabel *payment1 = [FactoryUI createLabelWithFrame:CGRectMake(SCREEN_W -130, 185, 120, 20) text:card_number[@"card_number"] textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14]];
     payment1.textAlignment = NSTextAlignmentRight;
    [self addSubview:payment1];
    
    UIButton *edit1 = [FactoryUI createButtonWithFrame:CGRectMake(SCREEN_W -85, 200, 120, 30) title:nil titleColor:[UIColor lightGrayColor] imageName:nil backgroundImageName:nil target:self selector:@selector(editCardInfo)];
    edit1.titleLabel.font = [UIFont systemFontOfSize:14];
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:@"Edit"];
    edit1.titleLabel.textColor = COLOR_9;
    NSRange strRange1 = {0,[str length]};
    [str1 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange1];
    [edit1 setAttributedTitle:str forState:UIControlStateNormal];
    [self addSubview:edit1];
    
    UILabel *subtotal = [FactoryUI createLabelWithFrame:CGRectMake(SCREEN_W -130, 230, 120, 20) text:array[0][@"text"] textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14]];
    subtotal.textAlignment = NSTextAlignmentRight;
    [self addSubview:subtotal];
    UILabel *Total = [FactoryUI createLabelWithFrame:CGRectMake(SCREEN_W -130, 270, 120, 20) text:array[0][@"text"]  textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14]];
    Total.textAlignment = NSTextAlignmentRight;
    [self addSubview:Total];

  /*  for (NSInteger i = 0; i < array.count; i++)
    {
        UILabel *label3 = [FactoryUI createLabelWithFrame:CGRectMake(10, 10 + i * 21.5, 100, 16.5) text:array[i][@"title"] textColor:[UIColor colorWithHexString:@"#999999"] font:[UIFont systemFontOfSize:14]];
        [view addSubview:label3];
         UILabel *subTotalLabel = [FactoryUI createLabelWithFrame:CGRectMake(SCREEN_W - 110, 10 + i * 21.5, 100, 16.5) text:array[i][@"text"] textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14]];
        subTotalLabel.textAlignment = NSTextAlignmentRight;
        [view addSubview:subTotalLabel];
    }*/
//    UIButton *editBtn1 = [FactoryUI createButtonWithFrame:CGRectMake(SCREEN_W - 60, 50, 60, 20) title:@"Edit" titleColor:[UIColor redColor] imageName:nil backgroundImageName:nil target:self selector:@selector(editCardInfo)];
//    editBtn1.titleLabel.font = [UIFont systemFontOfSize:12];
//    UIButton *editBtn2 = [FactoryUI createButtonWithFrame:CGRectMake(SCREEN_W - 60, 90, 60, 20) title:@"Edit" titleColor:[UIColor redColor] imageName:nil backgroundImageName:nil target:self selector:@selector(editAddress)];
//    editBtn2.titleLabel.font = [UIFont systemFontOfSize:12];
//    [view addSubview:editBtn1];
//    [view addSubview:editBtn2];
    return view;
}

#pragma mark ---- tableVeiw 协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shoppingCartCell"];
    if (!cell)
    {
        cell = [[ShoppingCartCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shoppingCartCell"];
    }
    if (_dataSource)
    {
        ShoppingCartModel *model = _dataSource[indexPath.row];
        [cell refreshUI:model];
    }
    if (!cell.deleteBlock) {
        __weak typeof(tableView) weakTableView = tableView;
        cell.deleteBlock = ^(ShoppingCartCell * currentCell){
            NSInteger row = [tableView indexPathForCell:currentCell].row;
            __strong typeof(tableView) strongTableView = weakTableView;
            [strongTableView beginUpdates];
            [strongTableView deleteRowsAtIndexPaths:@[[self removeDataAtIndex:row]]
                                   withRowAnimation:UITableViewRowAnimationAutomatic];
            [strongTableView endUpdates];
            [self deleteCart:currentCell.cartId];
        };
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSIndexPath *)removeDataAtIndex:(NSInteger)row
{
    [_dataSource removeObjectAtIndex:row];
    NSIndexPath * path = [NSIndexPath indexPathForRow:row inSection:0];
    return path;
}

#pragma mark ---显示什么视图
- (void)showMainOrNoItemView
{
    if (_dataSource.count == 0)
    {
        [self addSubview:_noItemView];
    }
    else
    {
      [self addSubview:_mainView];
    }
}

#pragma mark ---按钮点击checkout
-(void)checkOutt{
      _addressID = [[NSUserDefaults standardUserDefaults]objectForKey:@"address_id"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"signInSuccessful"]){
NSString *time = [self getCurrentTimestamp];
NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"equipment_id",@"email",@"address_id",@"card_number",@"card_month",@"card_year",@"card_cvv",@"token"];
NSDictionary *dic = @{@"appKey" : APPKEY,
                      @"apiKey" : APIKEY,
                      @"equipment_id" : MYDEVICEID,
                      @"timestamp" : time,
                      @"email" : CWEMAIL,
                      @"token" : CWTOKEN,
                      @"address_id" :self.addressID ,
                      @"card_number" : _payModel.card_number,
                      @"card_month" : _payModel.card_month,
                      @"card_year" : _payModel.card_year,
                      @"card_cvv" : _payModel.card_cvv
                      };
NSArray *sortedArray = [arr sortedArrayUsingSelector:@selector(compare:)];
NSMutableString *str = [[NSMutableString alloc] init];
for ( int i = 0; i < sortedArray.count; i++)
{
    [str appendString:sortedArray[i]];
    [str appendString:[dic objectForKey:sortedArray[i]]];
}
NSString *strMD5 = [str md5_32bit];
NSString *signature = [strMD5 sha1];

NSMutableDictionary *parameters = [dic mutableCopy];
[parameters setObject:signature forKey:@"signature"];

[[CWAPIClient sharedClient] POSTRequest:CHECKOUT_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
 {
     
     NSLog(@"%@",responseObject);
     
     NSLog(@"------");
     
     
 } failure:^(NSURLSessionDataTask *task, NSError *error)
 {
     NSLog(@"%@",error);
 }];}else{
 
     NSLog(@"fail");
     
 
 }
}
- (void)editCardInfo
{
    EditPayInfoView *addressView = [[EditPayInfoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    addressView.model = _payModel;
    [self addSubview:addressView];
    [UIView animateWithDuration: 0.35 animations: ^{
       addressView.center = _mainView.center;
        addressView.frame =CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    } completion: nil];
}

- (void)editAddress
{
    EditAddressView *addressView = [[EditAddressView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    addressView.model = _addressModel;
    [self addSubview:addressView];
    [UIView animateWithDuration: 0.35 animations: ^{
        addressView.center = _mainView.center;
       addressView.frame =CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    } completion: nil];
}

- (void)continueShopping
{
    RootViewController *vc = [[RootViewController alloc] init];
    [[self NavViewController] pushViewController:vc animated:YES];
}

// 点击透明背景视图消失
-(void)dismiss
{
    [UIView animateWithDuration: 0.35 animations: ^{
        self.frame =CGRectMake(0, SCREEN_H, SCREEN_W, SCREEN_H);
    } completion: nil];
    [self removeFromSuperview];
}

- (void)refreshUI
{   if ([[NSUserDefaults standardUserDefaults] objectForKey:@"signInSuccessful"]){
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"email",@"token",@"equipment_id"];
    NSDictionary *dic = @{@"email" : CWEMAIL,
                          @"token" : CWTOKEN,
                          @"appKey" : APPKEY,
                          @"apiKey" : APIKEY,
                          @"equipment_id" : MYDEVICEID,
                          @"timestamp" : time
                          };
    NSArray *sortedArray = [arr sortedArrayUsingSelector:@selector(compare:)];
    NSMutableString *str = [[NSMutableString alloc] init];
    for ( int i = 0; i < sortedArray.count; i++)
    {
        [str appendString:sortedArray[i]];
        [str appendString:[dic objectForKey:sortedArray[i]]];
    }
    NSString *strMD5 = [str md5_32bit];
    NSString *signature = [strMD5 sha1];
    
    NSMutableDictionary *parameters = [dic mutableCopy];
    [parameters setObject:signature forKey:@"signature"];
    
    [[CWAPIClient sharedClient] POSTRequest:SHOPPINGCART_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"%@",responseObject);
//         NSLog(@"------");
//         NSLog(@"------");
         
         NSDictionary *dic = responseObject[@"data"];
         NSArray *productsArr = dic[@"products"];
         for (NSDictionary *dic in productsArr)
         {
             ShoppingCartModel *model = [[ShoppingCartModel alloc] init];
             [model setValuesForKeysWithDictionary:dic];
             [self.dataSource addObject:model];
         }
         NSArray *total = dic[@"totals"];
         
         NSDictionary *address = dic[@"address"];
        
         _addressModel = [[AddressModel alloc]init];
         /*
          
          
          "address_1" = fghhfghhn;
          "address_id" = 35;
          city = fghbnfgnnn;
          company = "";
          country = Andorra;
          "country_id" = 5;
          fullname = sdfgfghhjm;
          phone = 123456;
          postcode = xvvbbnvbnn;
          suite = fghhjnfghjjn;
          zone = "Andorra la Vella";
          "zone_code" = ALV;
          "zone_id" = 122;
          
          
          
          
          */
         _addressModel.address_1 = address[@"address_1"];
         _addressModel.address_id = address[@"address_id"];
         _addressModel.city = address[@"city"];
         _addressModel.company = address[@"company"];
         _addressModel.country = address[@"country"];
         _addressModel.country_id = address[@"country_id"];
         _addressModel.fullname = address[@"fullname"];
         _addressModel.phone = address[@"phone"];
         _addressModel.postcode = address[@"postcode"];
         _addressModel.suite = address[@"suite"];
         _addressModel.zone = address[@"zone"];
         _addressModel.zone_code = address[@"zone_code"];
         _addressModel.zone_id = address[@"zone_id"];
         
//         if (_shopDelegate && [_shopDelegate respondsToSelector:@selector(shopModel:)]) {
//             [_shopDelegate shopModel:model];
//         }
         /*  id object = [self objectForKey:key];
          if ([object isKindOfClass:[NSNull class]]) {
          return nil;
          }
          return object;
          }*/
         
         //判断购物车address是否为空没有的就请求添加的地址
        // 有的话就请求编辑地址
         
         [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"address"];
         [[NSUserDefaults standardUserDefaults]synchronize];
         [[NSUserDefaults standardUserDefaults] setObject:address[@"address_id"] forKey:@"address_id"];
         [[NSUserDefaults standardUserDefaults]synchronize];
         
         /*
        
          
          "address_1" = fghhfghhn;
          "address_id" = 35;
          city = fghbnfgnnn;
          company = "";
          country = Andorra;
          "country_id" = 5;
          fullname = sdfgfghhjm;
          phone = 123456;
          postcode = xvvbbnvbnn;
          suite = fghhjnfghjjn;
          zone = "Andorra la Vella";
          "zone_code" = ALV;
          "zone_id" = 122;
          UITextField *_nameTF;
          //    UITextField *_addressTF;
          //    UITextField *_cityTF;
          //    UITextField *_codeTF;
          //    UITextField *_phoneTF;
          //    UITextField *_countryTF;
          //    UITextField *_stateTF;
          //    NSString *_countryID;
          //    NSString *_stateID;
          //    NSString *_addressID;
          
          
          */
         //AddressInfoView *view1 = [[AddressInfoView alloc]init];
       //  view1.nameTF.text = address[@"fullname"];
       //  view1.addressTF.text = address[@"address_1"];
       //  view1.aptTF.text = address[@"suite"];
        // view1.countryTF.text = address[@"country_id"];
        // view1.cityTF.text = address[@"city"];
       //  view1.codeTF.text = address[@"postcode"];
        // view1.phoneTF.text = address[@"phone"];
//         [[NSUserDefaults standardUserDefaults] setObject:address[@"fullname"] forKey:@"fullname"];
//         [[NSUserDefaults standardUserDefaults]synchronize];
//         [[NSUserDefaults standardUserDefaults] setObject:address[@"address_1"] forKey:@"address_1"];
//         [[NSUserDefaults standardUserDefaults]synchronize];
//         [[NSUserDefaults standardUserDefaults] setObject:address[@"suite"] forKey:@"suite"];
//         [[NSUserDefaults standardUserDefaults]synchronize];
//         [[NSUserDefaults standardUserDefaults] setObject:address[@"city"] forKey:@"city"];
//         [[NSUserDefaults standardUserDefaults]synchronize];
//         [[NSUserDefaults standardUserDefaults] setObject:address[@"postcode"] forKey:@"postcode"];
//         [[NSUserDefaults standardUserDefaults]synchronize];
//         [[NSUserDefaults standardUserDefaults] setObject:address[@"phone"] forKey:@"phone"];
       //  [[NSUserDefaults standardUserDefaults]synchronize];
         
//         AddressInfoView *infoView = [[AddressInfoView alloc]init];
//         infoView.address_id = address[@"address_id"];
//         NSLog(@"%@",address);
         NSDictionary *payment = dic[@"payment"];
         NSLog(@"%@",payment);
         _payModel = [[PayModel alloc]init];
         _payModel.customer_id = payment[@"customer_id"];
         _payModel.card_number = payment[@"card_number"];
         _payModel.card_cvv = payment[@"card_cvv"];
         _payModel.card_month = payment[@"card_month"];
         _payModel.zip_code = payment[@"zip_code"];
         _payModel.card_year = payment[@"card_year"];
         [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"payment"];
         [[NSUserDefaults standardUserDefaults]synchronize];
         
         [[NSUserDefaults standardUserDefaults] setObject:payment[@"card_number"]forKey:@"card_number"];
         [[NSUserDefaults standardUserDefaults]synchronize];
         [[NSUserDefaults standardUserDefaults] setObject:payment[@"card_month"]forKey:@"card_month"];
         [[NSUserDefaults standardUserDefaults]synchronize];
         [[NSUserDefaults standardUserDefaults] setObject:payment[@"card_year"]forKey:@"card_year"];
         [[NSUserDefaults standardUserDefaults]synchronize];
         [[NSUserDefaults standardUserDefaults] setObject:payment[@"card_cvv"]forKey:@"card_cvv"];
         [[NSUserDefaults standardUserDefaults]synchronize];
         
         
         [self showMainOrNoItemView];
         [_mainView addSubview:[self createHeaderView:address payment:payment tatal:total]];
         //[self createHeaderView:address payment:payment tatal:total];
         
         [_tableView reloadData];
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
       
     }];}
else
{
    if (_shopDelegate && [_shopDelegate respondsToSelector:@selector(shoppingNotLogin)]) {
        [_shopDelegate shoppingNotLogin];
    }
    
}

}

- (void)deleteCart:(NSString *)cartId
{
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"email",@"token",@"equipment_id",@"cart_id"];
    NSDictionary *dic = @{@"email" : CWEMAIL,
                          @"token" : CWTOKEN,
                          @"appKey" : APPKEY,
                          @"apiKey" : APIKEY,
                          @"equipment_id" : MYDEVICEID,
                          @"timestamp" : time,
                          @"cart_id" : cartId
                          };
    NSArray *sortedArray = [arr sortedArrayUsingSelector:@selector(compare:)];
    NSMutableString *str = [[NSMutableString alloc] init];
    for ( int i = 0; i < sortedArray.count; i++)
    {
        [str appendString:sortedArray[i]];
        [str appendString:[dic objectForKey:sortedArray[i]]];
    }
    NSString *strMD5 = [str md5_32bit];
    NSString *signature = [strMD5 sha1];
    
    NSMutableDictionary *parameters = [dic mutableCopy];
    [parameters setObject:signature forKey:@"signature"];
    
    [[CWAPIClient sharedClient] POSTRequest:DELETESHOPPINGCART_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"%@",error);
     }];
}

#pragma mark ----得到上一层的navigationController
- (UINavigationController*)NavViewController {
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UINavigationController class]])
        {
            return (UINavigationController*)nextResponder;
        }
    }
    return nil;
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil)
    {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
//-(void)checkpay
//{
//    NSString *time = [self getCurrentTimestamp];
//    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"equipment_id",@"email",@"address_id",@"card_number",@"card_month",@"card_year",@"card_cvv",@"token"];
//    NSDictionary *dic = @{@"appKey" : APPKEY,
//                          @"apiKey" : APIKEY,
//                          @"equipment_id" : MYDEVICEID,
//                          @"timestamp" : time,
//                          @"email" : CWEMAIL,
//                          @"token" : CWTOKEN,
//                          @"address_id" : _addressID,
//                          @"card_number" : @"4514617622367813",
//                          @"card_month" : @"09",
//                          @"card_year" : @"2020",
//                          @"card_cvv" : @"144"
//                          };
//    NSArray *sortedArray = [arr sortedArrayUsingSelector:@selector(compare:)];
//    NSMutableString *str = [[NSMutableString alloc] init];
//    for ( int i = 0; i < sortedArray.count; i++)
//    {
//        [str appendString:sortedArray[i]];
//        [str appendString:[dic objectForKey:sortedArray[i]]];
//    }
//    NSString *strMD5 = [str md5_32bit];
//    NSString *signature = [strMD5 sha1];
//    
//    NSMutableDictionary *parameters = [dic mutableCopy];
//    [parameters setObject:signature forKey:@"signature"];
//    
//    [[CWAPIClient sharedClient] POSTRequest:CHECKOUT_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
//     {
//         NSLog(@"%@",responseObject);
//         
//     } failure:^(NSURLSessionDataTask *task, NSError *error)
//     {
//         NSLog(@"%@",error);
//     }];
//    
//}
@end

