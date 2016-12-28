//
//  ShopViewController.m
//  SneakerLab
//
//  Created by edz on 2016/10/26.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "ShopViewController.h"
#import "ShopView.h"
#import "ShoppingCartCell.h"
#import "ShoppingCartModel.h"
#import "Tatals.h"
#import "AddressModel.h"
#import "EditAddressView.h"
#import "EditPayInfoView.h"
#import "OrderViewController.h"
#import "OrderHistoryViewController.h"
#import "OrderPlacedViewController.h"
#import "PaymentMethodViewController.h"
//购买页面
@interface ShopViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{  
    AddressModel * _addressModel;
    PayModel *_payModel;
    Tatals *_talModel;
}
@property(nonatomic, strong)EditAddressView *addressView;

@property(nonatomic,strong)UILabel *label1;
@property(nonatomic,strong)UILabel *label2;
@property(nonatomic,strong)UILabel *item;
@property(nonatomic,strong)UILabel *Estima;
@property(nonatomic,strong)UILabel *Tax;
@property(nonatomic,strong)UILabel *shiping;
@property(nonatomic,strong)UILabel *order;
@property(nonatomic,strong)UILabel *adress1;
@property(nonatomic,strong)UIButton *editAddress;
@property(nonatomic,strong)UIButton *edit1;
@property(nonatomic,strong)UILabel *payment1;
@property(nonatomic,strong)UILabel *subtotal;
@property(nonatomic,strong)UILabel *shippingnum;
@property(nonatomic,strong)UILabel *taxnum;
@property(nonatomic,strong)UILabel *Total;
@property(nonatomic,strong)UILabel *credcard;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *checkOutButton;
@property(nonatomic,strong)UIView *shopView;
@property(nonatomic,strong)UIView *kongShop;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)NSMutableArray *tatalSource;
@property(nonatomic,strong)NSMutableArray *addressSource;
@property(nonatomic,strong)NSString *addressID;
@property(nonatomic,strong)NSDictionary *allDataDict;
@property(nonatomic,strong)UILabel *paypal;
@end


@implementation ShopViewController

- (NSDictionary *)allDataDict {
    if (!_allDataDict) {
        _allDataDict = [NSDictionary dictionary];
    }
    return _allDataDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SET_NAV_MIDDLE
    self.title = @"My ShoppingCart";
    self.view.backgroundColor = [UIColor whiteColor];
    _dataSource = [[NSMutableArray alloc]init];
    _tatalSource = [[NSMutableArray alloc]init];
    _addressSource = [[NSMutableArray alloc]init];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self LoadData];
}

-(void)CreatUI{
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    _shopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_W, (SCREEN_H-64)/3)];
    _shopView.backgroundColor = [UIColor whiteColor];
    _label1 = [FactoryUI createLabelWithFrame:CGRectMake(10, 20, 60, 20) text:@"Ship To:" textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:14]];
    [_shopView addSubview:_label1];
    _label2 =[FactoryUI createLabelWithFrame:CGRectMake(10, 70, 60, 20) text:@"Bill To:" textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:14]];
    [_shopView addSubview:_label2];
    _item = [FactoryUI createLabelWithFrame:CGRectMake(10, 110, 120, 20) text:@"Item Total" textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:14]];
    [_shopView addSubview:_item];
    _Estima = [FactoryUI createLabelWithFrame:CGRectMake(10, 130, 150, 20) text:@"Estimated Shipping" textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:14]];
    [_shopView addSubview:_Estima];
    
    _Tax = [FactoryUI createLabelWithFrame:CGRectMake(10, 150, 150, 20) text:@"Tax" textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:14]];
    [_shopView addSubview:_Tax];
    
    _order =[FactoryUI createLabelWithFrame:CGRectMake(10, 170 , 100, 20) text:@"Order Total" textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:14]];
    [_shopView addSubview:_order];
    
    _editAddress = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W -85, 30, 120, 30)];
    _editAddress.zhw_ignoreEvent = NO;
    _editAddress.zhw_acceptEventInterval = 3;
    _editAddress.backgroundColor = [UIColor whiteColor];
    [_editAddress.titleLabel setTextColor:COLOR_9];
    [self addressView];
    [_editAddress addTarget:self action:@selector(editAddressInfo) forControlEvents:UIControlEventTouchUpInside];
    [_shopView addSubview:_editAddress];
    _editAddress.titleLabel.font = [UIFont systemFontOfSize:14];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"Edit"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [_editAddress setAttributedTitle:str forState:UIControlStateNormal];
    
    _credcard = [FactoryUI createLabelWithFrame:CGRectMake(SCREEN_W -200, 70, 190, 20) text:@"Credit Card"textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14]];
    _credcard.textAlignment = NSTextAlignmentRight;
    [_shopView addSubview:_credcard];

    _edit1 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W -85, 80, 120, 30)];
    _edit1.zhw_ignoreEvent = NO;
    _edit1.zhw_acceptEventInterval = 3;
    [_edit1 addTarget:self action:@selector(editCardInfo) forControlEvents:UIControlEventTouchUpInside];
    [_edit1.titleLabel setTextColor:COLOR_9];
    [_edit1 setAttributedTitle:str forState:UIControlStateNormal];
    _edit1.titleLabel.font = [UIFont systemFontOfSize:14];
    [_shopView addSubview:_edit1];
    [self.view addSubview:_shopView];
    
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 200, SCREEN_W, SCREEN_H-200-64-50) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView registerClass:[ShoppingCartCell class] forCellReuseIdentifier:@"shopcell"];
    _checkOutButton = [FactoryUI createButtonWithFrame:CGRectMake(10, SCREEN_H-64-40-10, SCREEN_W - 20, 40)  title:@"CheckOut" titleColor:[UIColor whiteColor] imageName:nil backgroundImageName:nil target:self selector:@selector(checkOutt1)];
    _checkOutButton.layer.cornerRadius = 4;
    _checkOutButton.backgroundColor = [UIColor colorWithHexString:@"#de4536"];
    [self.view addSubview:_checkOutButton];
    
    //2016-12-06 10:03:06，版本迭代
    UIButton *paymethod = [[UIButton alloc] initWithFrame:CGRectMake(0, 70, SCREEN_W, 40)];
    [_shopView addSubview:paymethod];
    paymethod.backgroundColor = [UIColor whiteColor];
    UIImageView *pay = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 17, 13)];
    pay.image = [UIImage imageNamed:@"安全码"];
    [paymethod addSubview:pay];
    UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake(46.5, 12, 120, 16.5)];
    payLabel.textAlignment = 0;
    payLabel.font = FONT_14;
    payLabel.textColor = COLOR_9;
    payLabel.text = @"Payment method";
    [paymethod addSubview:payLabel];
    UIImageView *right = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W-25.5, 6, 10.5, 17.5)];
    right.contentMode = UIViewContentModeCenter;
    right.image = [UIImage imageNamed:@"向右箭头"];
    [paymethod addSubview:right];
    self.paypal = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W-34.5-43.5, 6, 43.5, 16.5)];
    _paypal.textColor = COLOR_3;
    _paypal.font = FONT_14;
    [paymethod addSubview:_paypal];
    [paymethod addTarget:self action:@selector(paymethodAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)paymethodAction {
    PaymentMethodViewController *vc = [[PaymentMethodViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)createHeaderView:(NSDictionary *)address payment:(NSDictionary *)card_number tatal:(NSArray *)array
{
   if (address[@"address_1"] == nil) {
       _adress1 = [FactoryUI createLabelWithFrame:CGRectMake(SCREEN_W -250, 20, 240, 20) text:@"Please add address" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14]];
       _adress1.textAlignment = NSTextAlignmentRight;
       [_shopView addSubview:_adress1];
   }else{
       _adress1 =[FactoryUI createLabelWithFrame:CGRectMake(SCREEN_W -250, 20, 240, 20) text:[NSString stringWithFormat:@"%@ %@",address[@"city"],address[@"address_1"]] textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14]];
       _adress1.textAlignment = NSTextAlignmentRight;
       [_shopView addSubview:_adress1];
   }
    NSDictionary *data = [self.allDataDict valueForKey:@"data"];
    NSDictionary *shiping = [data valueForKey:@"shiping"];
    NSString *shiptext = [shiping valueForKey:@"text"];
    
    _subtotal = [FactoryUI createLabelWithFrame:CGRectMake(SCREEN_W -130, 110, 120, 20) text:@"" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14]];
    _subtotal.textAlignment = NSTextAlignmentRight;
    
    [_shopView addSubview:_subtotal];
    _shippingnum = [FactoryUI createLabelWithFrame:CGRectMake(SCREEN_W -130, 130, 120, 20) text:@"$0.00" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14]];
    _shippingnum.textAlignment = NSTextAlignmentRight;
    [_shopView addSubview:_shippingnum];
    _shippingnum.text = shiptext;
    
    _taxnum = [FactoryUI createLabelWithFrame:CGRectMake(SCREEN_W -130, 150, 120, 20) text:@"$0.00" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14]];
    _taxnum.textAlignment = NSTextAlignmentRight;
    [_shopView addSubview:_taxnum];
    
    _Total = [FactoryUI createLabelWithFrame:CGRectMake(SCREEN_W -130, 170, 120, 20) text:@""  textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14]];
    _Total.textAlignment = NSTextAlignmentRight;
    [_shopView addSubview:_Total];
    
    NSArray *totals = [data valueForKey:@"totals"];
    for (NSDictionary *dict in totals) {
        if ([[dict valueForKey:@"title"] isEqualToString:@"Sub-Total"]) {
            _subtotal.text = [dict valueForKey:@"text"];
        }
        if ([[dict valueForKey:@"title"] isEqualToString:@"Total"]) {
            _Total.text = [dict valueForKey:@"text"];
        }
        if ([[dict valueForKey:@"title"] isEqualToString:@"Tax"]) {
            _taxnum.text = [dict valueForKey:@"text"];
        }
    }
}

#pragma mark - 获取购物车信息，包括信用卡信息和收货地址信息
-(void)LoadData{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"signInSuccessful"] boolValue] == YES){
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
       [[CWAPIClient sharedClient] POSTRequest:SHOPPINGCART_URL parameters:parameters progress:^(NSProgress *uploadProgress) {
        
       } success:^(NSURLSessionDataTask *task, id responseObject)
       {
           [_dataSource removeAllObjects];
           self.allDataDict = responseObject;
           [self CreatUI];
           [MBManager hideAlert];
           NSDictionary *dic = responseObject[@"data"];
           NSArray *productsArr = dic[@"products"];
           for (NSDictionary *dic in productsArr)
           {
            ShoppingCartModel *model = [[ShoppingCartModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataSource addObject:model];
           }
           NSArray *total = dic[@"totals"];
           _talModel = [[Tatals alloc]init];
           for (NSDictionary *dic in total) {
            [_talModel setValuesForKeysWithDictionary:dic];
            [_tatalSource addObject:_talModel];
           }
           NSDictionary *address = dic[@"address"];
           _addressModel = [[AddressModel alloc]init];
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
           [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"address"];
           [[NSUserDefaults standardUserDefaults]synchronize];
           [[NSUserDefaults standardUserDefaults] setObject:address[@"address_id"] forKey:@"address_id"];
           [[NSUserDefaults standardUserDefaults]synchronize];
           NSDictionary *payment = dic[@"payment"];
           _payModel = [[PayModel alloc]init];
           _payModel.customer_id = payment[@"customer_id"];
           _payModel.card_number = payment[@"card_number"];
           _credcard.text = payment[@"card_number"];
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
           [self createHeaderView:address payment:payment tatal:total];
           if(self.dataSource.count == 0) {
              
              [self kongShop];
           }
           [_tableView reloadData];
       } failure:^(NSURLSessionDataTask *task, NSError *error){
         
       }];
   }
   else
   {
       //Do nothing
   }
}

-(UIView *)kongShop
{
    if (_dataSource.count == 0)
    {
        _kongShop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
        _kongShop.backgroundColor  = [UIColor whiteColor];
        UIImageView *imageview = [FactoryUI createImageViewWithFrame:CGRectMake(SCREEN_W/2-50, 100, 80, 100) imageName:@"shopping-空"];
        UILabel *label = [FactoryUI createLabelWithFrame:CGRectMake(44, 180, SCREEN_W, 100) text:@"Your cart is empty Go pick some cool goods" textColor:[UIColor colorWithHexString:@"#999999"] font:[UIFont systemFontOfSize:16.0f]];
        label.numberOfLines = 1;
        [_kongShop addSubview:label];
        [_kongShop addSubview:imageview];
        [self.view addSubview:_kongShop];
    }else{
        [_kongShop removeFromSuperview];
    }
    return _kongShop;    
}

#pragma mark -- tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shopcell"];
    if (!cell)
    {
        cell = [[ShoppingCartCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shopcell"];
    }
    if (_dataSource){
        ShoppingCartModel *model = _dataSource[indexPath.row];
        [cell refreshUI:model];
    }
    if (!cell.deleteBlock) {
        __weak typeof(tableView) weakTableView = tableView;
        cell.deleteBlock = ^(ShoppingCartCell *currentCell){
            NSInteger row = [tableView indexPathForCell:currentCell].row;
            __strong typeof(tableView) strongTableView = weakTableView;
            [strongTableView beginUpdates];
            [strongTableView deleteRowsAtIndexPaths:@[[self removeDataAtIndex:row]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [strongTableView endUpdates];
            [self deleteCart1:currentCell.cartId];
        };
    }
    if (!cell.editBlock) {
        cell.editBlock = ^(ShoppingCartCell *currentCell, NSInteger quantity) {
            NSInteger row = [tableView indexPathForCell:currentCell].row;
            [self editProductWithCartId:currentCell.cartId Quantity:quantity Row:(NSUInteger)row];
        };
    }
    return cell;
}

- (void)editProductWithCartId:(NSString *)cartId Quantity:(NSUInteger)quantity Row:(NSUInteger)row {
    NSString *quantityStr = [NSString stringWithFormat:@"%ld", quantity];
    NSDictionary *dic = @{@"cart_id":cartId,@"quantity":quantityStr};
    [PHPNetwork PHPNetworkWithParam:dic andUrl:EDITSHOPPING_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
        ShoppingCartModel *model = _dataSource[row];
        model.quantity = quantityStr;
        float priceNum = 0;
        for (ShoppingCartModel *model in _dataSource) {
            priceNum = priceNum + [model.quantity floatValue] * [model.special_price floatValue];
        }
        [self LoadData];
        //_subtotal.text = [NSString stringWithFormat:@"$%.2f", priceNum];
        
        //_Total.text = [NSString stringWithFormat:@"$%.2f", priceNum];
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

-(NSIndexPath *)removeDataAtIndex:(NSInteger)row
{
    [_dataSource removeObjectAtIndex:row];
    NSIndexPath * path = [NSIndexPath indexPathForRow:row inSection:0];
    return path;
}

-(void)deleteCart1:(NSString *)cartId
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
    [[CWAPIClient sharedClient] POSTRequest:DELETESHOPPINGCART_URL parameters:parameters progress:^(NSProgress *uploadProgress) {
    
    } success:^(NSURLSessionDataTask *task, id responseObject)
    {
        
        float priceNum = 0;
        for (ShoppingCartModel *model in _dataSource) {
            priceNum = priceNum + [model.quantity floatValue] * [model.special_price floatValue];
        }
        //_subtotal.text = [NSString stringWithFormat:@"$%.2f", priceNum];
        //_Total.text = [NSString stringWithFormat:@"$%.2f", priceNum];
        [self LoadData];
        if (_dataSource.count == 0) {
            [self kongShop];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        NSLog(@"%@",error);
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (EditAddressView *)addressView {
    if (!_addressView) {
        _addressView = [[EditAddressView alloc] init];
    }
    return _addressView;
}

// 编辑收获地址
- (void)editAddressInfo
{
    _addressView.frame = CGRectMake(0, SCREEN_H, SCREEN_W, SCREEN_H);
    [self.view addSubview:_addressView];
    _addressView.model = _addressModel;
    [UIView animateWithDuration: 0.35 animations: ^{
        _addressView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    } completion: nil];
}

// 编辑信用卡信息
- (void)editCardInfo
{
    EditPayInfoView *payView1 = [[EditPayInfoView alloc] initWithFrame:CGRectMake(0, SCREEN_H, SCREEN_W, SCREEN_H)];
    [self.view addSubview:payView1];
    payView1.model = _payModel;
    [UIView animateWithDuration: 0.35 animations: ^{
        payView1.center = self.view.center;
        payView1.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    } completion: nil];
}

-(void)checkOutt1{
    if (![_adress1.text isEqualToString:@"Please add address"]&&![_credcard.text isEqualToString:@"Credit Card"]) {
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"signInSuccessful"] boolValue]==YES) {
            NSString *time = [self getCurrentTimestamp];
            NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"equipment_id",@"email",@"token"];
            NSDictionary *dic = @{@"appKey" : APPKEY,
                                  @"apiKey" : APIKEY,
                                  @"equipment_id" : MYDEVICEID,
                                  @"timestamp" : time,
                                  @"email" : CWEMAIL,
                                  @"token" : CWTOKEN
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
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json",@"text/html",@"application/json",@"text/plain",nil];
            [MBManager showPermanentAlert:@"Waiting"];
            [manager POST:CHECKOUT_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [MBManager hideAlert];
                /*
                OrderHistoryViewController *vc = [[OrderHistoryViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                 */
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                DebugLog(@"%@", dic);
                /*
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Order has been placed" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"View orders" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    OrderHistoryViewController *vc = [[OrderHistoryViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }];
                [alert addAction:action];
                UIAlertAction *homeAction = [UIAlertAction actionWithTitle:@"Continue shopping" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
                [alert addAction:homeAction];
                [self presentViewController:alert animated:YES completion:nil];
                 */
                if ([[dic valueForKey:@"status_code"] integerValue] == 0) {
                    [self kongshop2];
                    OrderPlacedViewController *vc = [[OrderPlacedViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[dic valueForKey:@"message"] message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                LJLog(@"%@",error);
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Something went wrong with your payment.Recheck and try it again pls" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }];
        }
        else{//未登录
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Something went wrong with your payment.Recheck and try it again pls" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }else{
        [MBManager showBriefAlert:@"Please edit your address and credit card first"];
    }
}

-(void)kongshop2{
    _kongShop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    _kongShop.backgroundColor  = [UIColor whiteColor];
    UIImageView *imageview = [FactoryUI createImageViewWithFrame:CGRectMake(SCREEN_W/2-50, 100, 80, 100) imageName:@"shopping-空"];
    UILabel *label = [FactoryUI createLabelWithFrame:CGRectMake(44, 180, SCREEN_W, 100) text:@"Your cart is empty Go pick some cool goods" textColor:[UIColor colorWithHexString:@"#999999"] font:[UIFont systemFontOfSize:16.0f]];
    label.numberOfLines = 1;
    [_kongShop addSubview:label];
    [_kongShop addSubview:imageview];
    [self.view addSubview:_kongShop];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
