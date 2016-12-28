//
//  GPlaceOrderViewController.m
//  SneakerLab
//
//  Created by 郭隆基 on 2016/12/7.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "GPlaceOrderViewController.h"
#import "GPlaceOrderCell.h"
#import "GShippingAddressViewController.h"
#import "PaymentMethodViewController.h"
#import <PayPal-iOS-SDK/PayPalMobile.h>
#import "OrderPlacedViewController.h"

@interface GPlaceOrderViewController ()<UITableViewDelegate, UITableViewDataSource,PayPalPaymentDelegate>
@property (nonatomic, strong) UITableView *tableview;
//section0
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *phone;
@property (nonatomic, strong) UILabel *address;
//section1
@property (nonatomic, strong) UILabel *method;
@property (nonatomic, strong) UILabel *bill;
//section3
@property (nonatomic, strong) UILabel *price1;
@property (nonatomic, strong) UILabel *price2;
@property (nonatomic, strong) UILabel *price3;
@property (nonatomic, strong) UILabel *price4;
@property (nonatomic, strong) UIView *bottom;
@property (nonatomic, strong) UILabel *total;

@property (nonatomic, strong) NSDictionary *all;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) NSDictionary *addressdic;
@property (nonatomic, strong) NSDictionary *paymentdic;
@property (nonatomic, strong) NSDictionary *billingdic;
@property (nonatomic, strong) NSDictionary *totaldic;
@property (nonatomic, strong) NSDictionary *shipingdic;
//
@property (nonatomic, assign) BOOL payway;
@property (nonatomic, strong) NSString *card_id;
//paypal
@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSNumber *subtotal;
@property (nonatomic, strong) NSNumber *tax;
@property (nonatomic, strong) NSNumber *shipping;

@property (nonatomic, strong) UIBarButtonItem *cancel;
@end

@implementation GPlaceOrderViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _payPalConfiguration = [[PayPalConfiguration alloc] init];
        
        _payPalConfiguration.acceptCreditCards = NO;
        _payPalConfiguration.payPalShippingAddressOption = PayPalShippingAddressOptionProvided;
        
    }
    return self;
}

- (void)payPalPaymentDidCancel:(nonnull PayPalPaymentViewController *)paymentViewController {
    [paymentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentViewController:(nonnull PayPalPaymentViewController *)paymentViewController
                 didCompletePayment:(nonnull PayPalPayment *)completedPayment{
    /*
    if (!completedPayment.processable) {
        [MBManager showBriefAlert:@"Paypal payment fail"];
        return;
    }
     */
    NSString *feedback = [NSString mapToJson:completedPayment.confirmation];
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"email",@"equipment_id",@"token",@"payment",@"address_id"];
    NSDictionary *dic = @{@"email" : CWEMAIL,
                          @"token" : CWTOKEN,
                          @"appKey" : APPKEY,
                          @"apiKey" : APIKEY,
                          @"equipment_id" : MYDEVICEID,
                          @"timestamp" : time,
                          @"payment":@"1",
                          @"address_id":[_addressdic valueForKey:@"address_id"],
                          @"client_data":feedback
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
    
    //测试方法
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json",@"text/html",@"application/json",@"text/plain",nil];
    [manager POST:PLACEORDER_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    [[CWAPIClient sharedClient] POSTRequest:PLACEORDER_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBManager showBriefAlert:@"Payment Success"];
        OrderPlacedViewController *vc = [[OrderPlacedViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        [paymentViewController dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBManager showBriefAlert:@"Payment failure, please try again later"];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Place Order";
    SET_NAV_MIDDLE
    self.cancel = [[UIBarButtonItem alloc] initWithTitle:@"cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelItemAction)];
    if (self.from == EDITCART) {
        [self.navigationItem setHidesBackButton:YES];
    }
    self.navigationItem.rightBarButtonItem = _cancel;
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64-49) style:UITableViewStylePlain];
    [self.view addSubview:_tableview];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.view.backgroundColor = COLOR_FA;
    self.tableview.backgroundColor = COLOR_FA;
    self.tableview.allowsSelection = NO;
    UIView *foot = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableview.tableFooterView = foot;
    [self.tableview registerClass:[GPlaceOrderCell class] forCellReuseIdentifier:@"cell"];
    
    _bottom = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H-64-49, SCREEN_W, 49)];
    [self.view addSubview:_bottom];
    UIButton *placeOrder = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W-129, 0, 129, 49)];
    [placeOrder setTitle:@"Place order" forState:UIControlStateNormal];
    placeOrder.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
    placeOrder.backgroundColor = COLOR_RED;
    [placeOrder addTarget:self action:@selector(placeorderButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_bottom addSubview:placeOrder];
    
    _total = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W-129-150-12, 14.5, 150, 19.5)];
    _total.font = FONT_17;
    _total.textColor = COLOR_RED;
    _total.textAlignment = 2;
    _bottom.backgroundColor = [UIColor whiteColor];
    [_bottom addSubview:_total];
}

- (void)cancelItemAction {
    if (self.from == EDITCART) {
        //连续返回两级
        NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-3] animated:YES];
        self.from = -1;
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _payway = [[NSUserDefaults standardUserDefaults] boolForKey:@"payway"];
    [self requestdatas];
#ifdef DEBUG
#warning paypal改环境
    //[PayPalMobile preconnectWithEnvironment:PayPalEnvironmentSandbox];
    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentProduction];
#else
    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentProduction];
#endif
}

- (void)requestdatas {
    [PHPNetwork PHPNetworkWithUrl:CHECKOUT_URL finish:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSDictionary dictionaryWithJsonString:responseObject];
        self.all = [result valueForKey:@"data"];
        self.products = [_all valueForKey:@"products"];
        self.addressdic = [_all valueForKey:@"address"];
        self.paymentdic = [_all valueForKey:@"payment"];
        self.billingdic = [_all valueForKey:@"shipping"];
        self.totaldic = [_all valueForKey:@"totals"];
        self.shipingdic = [_all valueForKey:@"shiping"];
        for (NSDictionary *dic in _totaldic) {
            if ([[dic valueForKey:@"title"] isEqualToString:@"Total"]) {
                _price4.text = [dic valueForKey:@"text"];
                _total.text = [dic valueForKey:@"text"];
                _amount = [dic valueForKey:@"value"];
            }
            if ([[dic valueForKey:@"title"] isEqualToString:@"Sub-Total"]) {
                _subtotal = [dic valueForKey:@"value"];
            }
            if ([[dic valueForKey:@"title"] isEqualToString:@"Tax"]) {
                _tax = [dic valueForKey:@"value"];
            }
            if ([[dic valueForKey:@"title"] isEqualToString:@"Shiping"]) {
                _shipping = [dic valueForKey:@"value"];
            }
        }
        _shipping = [_shipingdic valueForKey:@"cost"];
        [self.tableview reloadData];
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 125;
    }else if (indexPath.section == 1){
        return 137.5;
    }else if (indexPath.section == 2){
        return 141;
    }else{
        return 125;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }else if (section==1) {
        return 1;
    }else if (section==2) {
        return _products.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 125)];
        UIImageView *phone = [[UIImageView alloc] initWithFrame:CGRectMake(14.5, 15, 17, 17)];
        phone.image = [UIImage imageNamed:@"电话"];
        [cell addSubview:phone];
        _name = [[UILabel alloc] initWithFrame:CGRectMake(46.5, 17.5, 100, 16.5)];
        _name.textColor = [UIColor colorWithHexString:@"#FF8922"];
        _name.font = FONT_14;
        _name.text = [_addressdic valueForKey:@"fullname"];
        [_name sizeToFit];
        [cell addSubview:_name];
        _phone = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_name.frame)+15, 17.5, 100, 16.5)];
        _phone.textColor = [UIColor colorWithHexString:@"#FF8922"];
        _phone.font = FONT_14;
        _phone.text = [_addressdic valueForKey:@"phone"];
        [_phone sizeToFit];
        [cell addSubview:_phone];
        UIImageView *location = [[UIImageView alloc] initWithFrame:CGRectMake(15.5, 48.5, 15, 20)];
        location.image = [UIImage imageNamed:@"定位"];
        [cell addSubview:location];
        
        _address = [[UILabel alloc] initWithFrame:CGRectMake(46.5, 47, 200, 60)];
        _address.textAlignment = 0;
        _address.textColor = COLOR_3;
        _address.font = FONT_14;
        _address.numberOfLines = 0;
        if (_addressdic!=nil) {
            NSString *address_1 = [_addressdic valueForKey:@"address_1"];
            if (address_1.length!=0) {
                _address.text = [NSString stringWithFormat:@"%@\n%@\n%@", [_addressdic valueForKey:@"address_1"], [_addressdic valueForKey:@"city"], [_addressdic valueForKey:@"country"]];
            }
        }
        [cell addSubview:_address];
        UIImageView *right = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W-16-10.5, 51.5, 10.5, 17.5)];
        right.image = [UIImage imageNamed:@"向右箭头"];
        right.contentMode = UIViewContentModeCenter;
        [cell addSubview:right];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 125)];
        [button addTarget:self action:@selector(section1Action) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
        
        return cell;
    }else if (indexPath.section==1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 137.5)];
        UIImageView *card = [[UIImageView alloc] initWithFrame:CGRectMake(15, 18.5, 17, 13)];
        card.image = [UIImage imageNamed:@"安全码"];
        [cell addSubview:card];
        UILabel *method = [[UILabel alloc] initWithFrame:CGRectMake(46.5, 15, 120, 16.5)];
        method.text = @"Payment method";
        method.textColor = COLOR_9;
        method.font = FONT_14;
        [cell addSubview:method];
        _method = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W-36-150, 15, 150, 60)];
        _method.textAlignment = 2;
        _method.textColor = COLOR_3;
        _method.font = FONT_14;
        UIImageView *right = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W-16-10.5, 37.5, 10.5, 17.5)];
        NSDictionary *data = [_paymentdic valueForKey:@"data"];
        NSNumber *type = [_paymentdic valueForKey:@"type"];
        NSString *cardnum = [data valueForKey:@"card_number"];
        _card_id = [data valueForKey:@"credit_id"];
        NSString *str;
        if (cardnum.length>3) {
            NSRange ran = NSMakeRange(cardnum.length-4, 4);
            str = [cardnum substringWithRange:ran];
        }else{
            str = cardnum;
        }
        _method.numberOfLines = 0;
        _method.textColor = COLOR_3;
        if ([type integerValue]==1) {
            _method.text = @"Paypal";
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UD_PAY];
        }else if ([type integerValue]==0) {
            _method.text = @"perfect information";
            _method.textColor = COLOR_RED;
        }else{
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:UD_PAY];
            _method.text = [NSString stringWithFormat:@"Credit Card\n\n****%@", str];
            if (str.length==0) {
                _method.text = @"";
            }
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        [cell addSubview:_method];
        right.image = [UIImage imageNamed:@"向右箭头"];
        right.contentMode = UIViewContentModeCenter;
        [cell addSubview:right];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 89.5, SCREEN_W-15, 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [cell addSubview:line];
        
        UILabel *bil = [[UILabel alloc] initWithFrame:CGRectMake(14.5, 106, 100, 16.5)];
        bil.text = @"Billing address";
        bil.textColor = COLOR_9;
        bil.font = FONT_14;
        [bil sizeToFit];
        [cell addSubview:bil];
        
        _bill = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W-34.5-200, 103.5, 200, 20)];
        _bill.textColor = COLOR_3;
        _bill.font = FONT_14;
        _bill.textAlignment = 2;
        [cell addSubview:_bill];
        
        UIImageView *ri = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W-16-10.5, 105.5, 10.5, 17.5)];
        ri.image = [UIImage imageNamed:@"向右箭头"];
        ri.contentMode = UIViewContentModeCenter;
        [cell addSubview:ri];
        
        UIButton *section21 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 89)];
        [section21 addTarget:self action:@selector(section21Action) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:section21];
        
        UIButton *section22 = [[UIButton alloc] initWithFrame:CGRectMake(0, 89.5, SCREEN_W, 46)];
        [section22 addTarget:self action:@selector(section22Action) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:section22];
        return cell;
    }else if (indexPath.section==2) {
        GPlaceOrderCell *cell = [GPlaceOrderCell cellWithTableView:tableView];
        NSDictionary *dict = _products[indexPath.row];
        cell.head = [dict valueForKey:@"image"];
        cell.name = [dict valueForKey:@"name"];
        cell.sizeL.hidden = YES;
        cell.colorL.hidden = YES;
        NSArray *options = [dict valueForKey:@"options"];
        for (NSDictionary *dic in options) {
            if ([[dic valueForKey:@"name"] isEqualToString:@"size"]) {
                cell.size = [dic valueForKey:@"value"];
                cell.sizeL.hidden = NO;
            }
            if ([[dic valueForKey:@"name"] isEqualToString:@"color"]) {
                cell.color = [dic valueForKey:@"value"];
                cell.colorL.hidden = NO;
            }
        }
        cell.lowprice = [dict valueForKey:@"special_price"];
        cell.highprice = [dict valueForKey:@"original_price"];
        cell.num = [dict valueForKey:@"quantity"];
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 126)];
        UILabel *item = [[UILabel alloc] initWithFrame:CGRectMake(15, 19.5, 100, 16.5)];
        item.textAlignment = 0;
        item.font = FONT_14;
        item.textColor = COLOR_9;
        item.text = @"Items price";
        [cell addSubview:item];
        
        UILabel *item2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 42.5, 100, 16.5)];
        item2.textAlignment = 0;
        item2.font = FONT_14;
        item2.textColor = COLOR_9;
        item2.text = @"Shipping price";
        [cell addSubview:item2];
        
        UILabel *item3 = [[UILabel alloc] initWithFrame:CGRectMake(15, 66, 100, 16.5)];
        item3.textAlignment = 0;
        item3.font = FONT_14;
        item3.textColor = COLOR_9;
        item3.text = @"Tax price";
        [cell addSubview:item3];
        
        UILabel *item4 = [[UILabel alloc] initWithFrame:CGRectMake(15, 90, 100, 16.5)];
        item4.textAlignment = 0;
        item4.font = FONT_14;
        item4.textColor = COLOR_9;
        item4.text = @"Total price";
        [cell addSubview:item4];
        
        _price1 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W-15-80, 22, 80, 16.5)];
        _price1.textColor = COLOR_6;
        _price1.font = FONT_14;
        [cell addSubview:_price1];
        
        _price2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W-15-80, 44, 80, 16.5)];
        _price2.textColor = COLOR_6;
        _price2.font = FONT_14;
        [cell addSubview:_price2];
        
        _price3 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W-15-80, 66, 80, 16.5)];
        _price3.textColor = COLOR_6;
        _price3.font = FONT_14;
        _price3.text = @"$0.00";
        [cell addSubview:_price3];
        
        _price4 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W-15-80, 88, 80, 16.5)];
        _price4.textColor = COLOR_6;
        _price4.font = FONT_14;
        [cell addSubview:_price4];
        
        for (NSDictionary *dic in _totaldic) {
            if ([[dic valueForKey:@"title"] isEqualToString:@"Sub-Total"]) {
                _price1.text = [dic valueForKey:@"text"];
            }
            if ([[dic valueForKey:@"title"] isEqualToString:@"Shiping"]) {
                _price2.text = [dic valueForKey:@"text"];
            }
            if ([[dic valueForKey:@"title"] isEqualToString:@"Tax"]) {
                _price3.text = [dic valueForKey:@"text"];
            }
            if ([[dic valueForKey:@"title"] isEqualToString:@"Total"]) {
                _price4.text = [dic valueForKey:@"text"];
                _total.text = [dic valueForKey:@"text"];
                _amount = [dic valueForKey:@"value"];
            }
        }
        _price2.text = [_shipingdic valueForKey:@"text"];
        UILabel *crossed = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W-15-80-10-60, 44, 60, 16.5)];
        NSAttributedString *a = [[NSAttributedString alloc] initWithString:@"$20.00" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:14],
                                                                                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],
                                                                                                 NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                                                                                                  NSStrikethroughColorAttributeName:[UIColor colorWithHexString:@"#999999"]}];
        crossed.attributedText = a;
        [cell.contentView addSubview:crossed];
        
        UILabel *run = [[UILabel alloc] initWithFrame:CGRectMake(115, 42.5, 54.5, 17)];
        run.text = @"short run";
        run.textColor = [UIColor whiteColor];
        run.textAlignment = 1;
        run.font = FONT_11;
        run.backgroundColor = [UIColor colorWithHexString:@"#FF897D"];
        [cell.contentView addSubview:run];
        
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 10)];
    view.backgroundColor = COLOR_FA;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3) {
        return 0;
    }else{
        return 10;
    }
}

//跳转到shipping address
- (void)section1Action {
    GShippingAddressViewController *vc = [[GShippingAddressViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//跳转到payment method
- (void)section21Action {
    PaymentMethodViewController *vc = [[PaymentMethodViewController alloc] init];
    vc.card_id = self.card_id;
    [self.navigationController pushViewController:vc animated:YES];
}

//跳转到billing address
- (void)section22Action {
    GShippingAddressViewController *vc = [[GShippingAddressViewController alloc] init];
    vc.type = @"billing";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)placeorderButtonAction {
    if (_address.text.length==0||_method.text.length==0) {
        [MBManager showBriefAlert:@"Please fill your card and address first"];
        return;
    }
    if (_payway) {
        PayPalPayment *payment = [[PayPalPayment alloc] init];
        payment.currencyCode = @"USD";
        payment.amount = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%@", _amount]];
        payment.shortDescription = @"Founded Sole";
        payment.intent = PayPalPaymentIntentSale;
        
        NSDecimalNumber *subtotal = [NSDecimalNumber decimalNumberWithDecimal:_subtotal.decimalValue];
        NSDecimalNumber *shipping = [NSDecimalNumber decimalNumberWithDecimal:_shipping.decimalValue];
        NSDecimalNumber *tax = [NSDecimalNumber decimalNumberWithDecimal:_tax.decimalValue];
        payment.paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal withShipping:shipping withTax:tax];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dict in _products) {
            NSString *name = [dict valueForKey:@"name"];
            NSNumber *quantity = [dict valueForKey:@"quantity"];
            NSNumber *price = [dict valueForKey:@"special_price"];
            NSDecimalNumber *dePrice = [NSDecimalNumber decimalNumberWithDecimal:price.decimalValue];
            NSString *sku = [dict valueForKey:@"product_id"];
            PayPalItem *paypalitem = [PayPalItem itemWithName:name withQuantity:[quantity integerValue] withPrice:dePrice withCurrency:@"USD" withSku:sku];
            [arr addObject:paypalitem];
        }
        //payment.items = arr;
        payment.softDescriptor = @"Foundzilla";
        //payment.invoiceNumber = @"";
        //payment.custom = @"";
        //payment.payeeEmail = @"";
        //payment.bnCode = @"";
        PayPalShippingAddress *address = [PayPalShippingAddress shippingAddressWithRecipientName:[_addressdic valueForKey:@"fullname"]
                                                                                       withLine1:[_addressdic valueForKey:@"address_1"]
                                                                                       withLine2:@""
                                                                                        withCity:[_addressdic valueForKey:@"city"]
                                                                                       withState:[_addressdic valueForKey:@"zone"]
                                                                                  withPostalCode:[_addressdic valueForKey:@"postcode"]
                                                                                 withCountryCode:@"US"];
        payment.shippingAddress = address;
        PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                       configuration:self.payPalConfiguration
                                                                            delegate:self];
        [self presentViewController:paymentViewController animated:YES completion:nil];

    }else{//使用信用卡支付
        NSDictionary *paydic = [_paymentdic valueForKey:@"data"];
        NSString *time = [self getCurrentTimestamp];
        NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"email",@"equipment_id",@"token",@"payment",@"address_id",@"billing_address_id"];
        NSDictionary *dic = @{@"email" : CWEMAIL,
                              @"token" : CWTOKEN,
                              @"appKey" : APPKEY,
                              @"apiKey" : APIKEY,
                              @"equipment_id" : MYDEVICEID,
                              @"timestamp" : time,
                              @"payment":@"2",
                              @"address_id":[_addressdic valueForKey:@"address_id"],
                              @"credit_id":[paydic valueForKey:@"credit_id"],
                              @"billing_address_id":[_addressdic valueForKey:@"address_id"]
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
        [[CWAPIClient sharedClient] POSTRequest:PLACEORDER_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSNumber *status_code = [responseObject valueForKey:@"status_code"];
            if ([status_code integerValue]==1) {
                [MBManager showBriefAlert:@"Error:API payment is fail"];
                return;
            }else if ([status_code integerValue]==0) {
                [MBManager showBriefAlert:@"Payment Success"];
                OrderPlacedViewController *vc = [[OrderPlacedViewController alloc] init];
                vc.value1 = _price1.text;
                vc.value2 = _price2.text;
                vc.value3 = _price4.text;
                [self.navigationController pushViewController:vc animated:YES];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
}

- (NSDictionary *)all {
    if (!_all) {
        _all = [NSDictionary dictionary];
    }
    return _all;
}

- (NSArray *)products {
    if (!_products) {
        _products = [NSArray array];
    }
    return _products;
}

- (NSDictionary *)addressdic {
    if (!_addressdic) {
        _addressdic = [NSDictionary dictionary];
    }
    return _addressdic;
}

- (NSDictionary *)paymentdic {
    if (!_paymentdic) {
        _paymentdic = [NSDictionary dictionary];
    }
    return _paymentdic;
}

- (NSDictionary *)totaldic {
    if (!_totaldic) {
        _totaldic = [NSDictionary dictionary];
    }
    return _totaldic;
}

- (NSDictionary *)shipingdic {
    if (!_shipingdic) {
        _shipingdic = [NSDictionary dictionary];
    }
    return _shipingdic;
}

@end
