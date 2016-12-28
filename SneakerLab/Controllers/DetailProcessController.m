//
//  DetailProcessController.m
//  SneakerLab
//
//  Created by edz on 2016/11/4.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "DetailProcessController.h"
#import "UIView+YZTCView.h"
#import "Tatals.h"
#import "OrderProduct.h"
#import "OptionModel.h"
#import "DetailProcessTableViewCell.h"
#import "UILabel+ChangeDate.h"
#import "ContactUsController.h"
@interface DetailProcessController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{

    NSString *_order_id;
    NSMutableArray *_total;
    UITableView *_tableView;
    UIImageView *_image;
    UILabel *_ordertal;
    UILabel *_ordertal4;
    UILabel *_ordertal2;
    UILabel *_ordertal3;
}

@property(nonatomic,strong)UILabel *ordertails;
@property(nonatomic,strong)UILabel *orderPlaced;
@property(nonatomic,strong)UILabel *orderPlaced1;
@property(nonatomic,strong)UILabel *Order;
@property(nonatomic,strong)UILabel *Order1;
@property(nonatomic,strong)UIView *addPay;
@property(nonatomic,strong)UIView *Summay;
@property(nonatomic,strong)UIView *Items;
@property(nonatomic,strong)UILabel *shippaddress;
@property(nonatomic,strong)UILabel *beiyuan;
@property(nonatomic,strong)UILabel *paymentmeth;
@property(nonatomic,strong)UILabel *creaditcard;
@property(nonatomic,strong)UILabel *number;
@property(nonatomic,strong)UILabel *zipcode;
@property(nonatomic,strong)UILabel *number1;
@property(nonatomic,strong)UILabel *zipcode1;
@property(nonatomic,strong)UILabel *line;
@property(nonatomic,strong)UILabel *line2;
@property(nonatomic,strong)UILabel *Items1;
@property(nonatomic,strong)NSMutableArray *productArray;
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)NSArray *total;

@end

@implementation DetailProcessController
-(NSMutableArray *)productArray{
    if (_productArray == nil) {
        _productArray = [[NSMutableArray alloc]init];
    }
    return _productArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
#if PREDUPLICATE==0
    self.title = @"FOUNDED SOLE";
#elif PREDUPLICATE==1
    self.title = @"IVANKA JINGLE";
#elif PREDUPLICATE==5
    self.title = @"SNEAKER CRUNCH";
#elif PREDUPLICATE==6
    self.title = @"STYL";
#endif
    self.view.backgroundColor = COLOR_FA;
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 280)];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W,SCREEN_H-64-65) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView registerClass:[DetailProcessTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = _headerView;
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H -64- 65, SCREEN_W, 65)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    UIButton *confirm = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W-102.5, 0, 90, 30)];
    confirm.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    confirm.backgroundColor = [UIColor colorWithHexString:@"#DE4536"];
    confirm.layer.cornerRadius = 4;
    confirm.layer.masksToBounds = YES;
    [confirm setTitle:@"Confirm" forState:UIControlStateNormal];
    confirm.titleLabel.textColor = [UIColor whiteColor];
    [confirm addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:confirm];
    
    UIButton *contact = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W-202.5, 0, 90, 30)];
    contact.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    contact.backgroundColor = [UIColor colorWithHexString:@"#E7E7E7"];
    [contact setTitleColor:COLOR_6 forState:UIControlStateNormal];
    contact.layer.cornerRadius = 4;
    contact.layer.masksToBounds = YES;
    [contact setTitle:@"Contact us" forState:UIControlStateNormal];
    [contact addTarget:self action:@selector(contactAction) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:contact];
    if (self.state == 0) {
        
    }
    if (self.state == 1) {
        _tableView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64);
        _bottomView.frame = CGRectZero;
        contact.hidden = YES;
        confirm.hidden = YES;
    }
    [self CreatUI];
    [self Creatitem];
    [self refreshUI];
}

- (void)confirmAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure you have received the goods？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary *dict = @{@"order_id":self.orderID,@"order_status_id":@"5"};
        [PHPNetwork PHPNetworkWithParam:dict andUrl:DINGDANSTATUS_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
            [MBManager showBriefAlert:@"Confirm success"];
        } err:^(NSURLSessionDataTask *task, NSError *error) {
            [MBManager showBriefAlert:@"Something wrong with your confirm"];
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)contactAction {
    ContactUsController *contactVC = [[ContactUsController alloc] init];
    [self.navigationController pushViewController:contactVC animated:YES];
}

-(void)CreatUI{
    _ordertails = [FactoryUI createLabelWithFrame:CGRectMake(10,15,SCREEN_W-20,18) text:@"Order Details" textColor: [UIColor colorWithHexString:@"#333333"]font:[UIFont boldSystemFontOfSize:18]];
    _ordertails.textAlignment = 1;
    [_headerView addSubview:_ordertails];
    
    _orderPlaced1 =[FactoryUI createLabelWithFrame:CGRectMake(10,45,SCREEN_W-20,18 ) text:nil textColor: [UIColor colorWithHexString:@"#333333"]font:[UIFont systemFontOfSize:12]];
    _orderPlaced1.textAlignment = 1;
    [_headerView addSubview:_orderPlaced1];
    
    _Order1 = [FactoryUI createLabelWithFrame:CGRectMake(10,63, SCREEN_W-20, 18) text:nil textColor: [UIColor colorWithHexString:@"#333333"]font:[UIFont systemFontOfSize:12]];
    _Order1.textAlignment = 1;
    [_headerView addSubview:_Order1];
    _addPay = [FactoryUI createViewWithFrame:CGRectMake(10, 100, SCREEN_W-20, 170)];
    _addPay.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
    _addPay.layer.borderWidth = 0.5;
    _addPay.layer.borderColor = [Color(221, 221, 221, 1) CGColor];
    [_headerView addSubview:_addPay];
    _shippaddress =[FactoryUI createLabelWithFrame:CGRectMake(10,11,120,14 ) text:@"Shipping Address:" textColor: [UIColor colorWithHexString:@"#333333"]font:[UIFont systemFontOfSize:12]];
    [_addPay addSubview:_shippaddress];
    _beiyuan =[FactoryUI createLabelWithFrame:CGRectMake(10,_shippaddress.yzBottom +8 ,150,14 ) text:nil textColor: [UIColor colorWithHexString:@"#999999"]font:[UIFont systemFontOfSize:12]];
    [_addPay addSubview:_beiyuan];
    _line =[FactoryUI createLabelWithFrame:CGRectMake(10,_beiyuan.yzBottom+9,SCREEN_W-40,1 ) text:nil textColor: [UIColor colorWithHexString:@"#DDDDDD"]font:[UIFont systemFontOfSize:12]];
    _line.backgroundColor = COLOR_D;
    [_addPay addSubview:_line];
    _paymentmeth =[FactoryUI createLabelWithFrame:CGRectMake(10,_line.yzBottom+8,100,14 ) text:@"Payment Method:" textColor: [UIColor colorWithHexString:@"#333333"]font:[UIFont systemFontOfSize:12]];
    [_addPay addSubview:_paymentmeth];
    _creaditcard =[FactoryUI createLabelWithFrame:CGRectMake(10,_paymentmeth.yzBottom+8,100,14 ) text:@"Credit Card" textColor: [UIColor colorWithHexString:@"#999999"]font:[UIFont systemFontOfSize:12]];
    [_addPay addSubview:_creaditcard];
    
    _number =[FactoryUI createLabelWithFrame:CGRectMake(10,_creaditcard.yzBottom+8,85,14 ) text:@"Number:" textColor: [UIColor colorWithHexString:@"#999999"]font:[UIFont systemFontOfSize:12]];
    [_addPay addSubview:_number];
    _number1 =[FactoryUI createLabelWithFrame:CGRectMake(70,_creaditcard.yzBottom+8,200,14 ) text:nil textColor: [UIColor colorWithHexString:@"#999999"]font:[UIFont systemFontOfSize:12]];
    [_addPay addSubview:_number1];
    _zipcode =[FactoryUI createLabelWithFrame:CGRectMake(10,_number.yzBottom+8,100,14 ) text:@"Zip/Postal Code:" textColor: [UIColor colorWithHexString:@"#999999"]font:[UIFont systemFontOfSize:12]];
    [_addPay addSubview:_zipcode];
    
    _zipcode1 =[FactoryUI createLabelWithFrame:CGRectMake(110,_number.yzBottom+8,120,14 ) text:nil textColor: [UIColor colorWithHexString:@"#999999"]font:[UIFont systemFontOfSize:12]];
    [_addPay addSubview:_zipcode1];
}

-(void)setOrderID:(NSString *)orderID{
    _orderID = orderID;
}

-(void)refreshUI{
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"equipment_id",@"email",@"order_id",@"token"];
    NSDictionary *dic = @{@"order_id" : self.orderID,
                          @"appKey" : APPKEY,
                          @"apiKey" : APIKEY,
                          @"email" : CWEMAIL,
                          @"token" : CWTOKEN,
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
    [[CWAPIClient sharedClient] POSTRequest:DINGDANDETAL_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSDictionary *datadic = responseObject[@"data"];
         NSString *date_added = datadic[@"date_added"];
         NSString *order_id =  datadic[@"order_id"];
         NSDictionary *shiping = datadic[@"shipping"];
         NSDictionary *address = datadic[@"address"];
         NSDictionary *payment = datadic[@"payment"];
         NSArray *productArray = datadic[@"product"];
         for (NSDictionary *dic in productArray)
        {
            OrderProduct *model = [[OrderProduct alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.productArray addObject:model];
            NSMutableArray *optionmutable = [[NSMutableArray alloc]init];
            NSArray *optionsArray = dic[@"option"];
            for (NSDictionary *dic3 in optionsArray ) {
                OptionModel *model2 = [[OptionModel alloc]init];
                [model2 setValuesForKeysWithDictionary:dic3];
                [optionmutable addObject:model2];
            }
            model.option = optionmutable;
        }
         _total = datadic[@"totals"];
         [self createHeaderView:address payment:payment dataadd:date_added order_id:order_id];
         [self createItemproduct:productArray total:_total ship:shiping];
         [_tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        NSLog(@"%@",error);
    }];
}

- (void)createHeaderView:(NSDictionary *)address payment:(NSDictionary *)payment dataadd:(NSString*)date_added order_id:(NSString*)order_id {
    UILabel *label = [[UILabel alloc] init];
    [label setLabelWithText:date_added inputFormat:@"yyyy-MM-dd HH:mm:ss" outputFormat:@"MMM d,yyyy"];
    _orderPlaced1.text = [NSString stringWithFormat:@"Order Placed:%@", label.text];
    _Order1.text = [NSString stringWithFormat:@"Order #:%@", order_id];
    _beiyuan.text = [NSString stringWithFormat:@"%@,%@,%@",address[@"address_1"],address[@"city"],address[@"country"]];
    ;
    _number1.text =  payment[@"card_number"];
    _zipcode1.text = payment[@"zip_code"];
}

- (void)createHeader {
    _Items = [FactoryUI createViewWithFrame:CGRectMake(10, _addPay.yzBottom +15, SCREEN_W-20, 30)];
    _Items.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
    [_headerView addSubview:_Items];
    _Items1 =[FactoryUI createLabelWithFrame:CGRectMake(150,10,50,18 ) text:@"Items" textColor: [UIColor colorWithHexString:@"#333333"]font:[UIFont systemFontOfSize:16]];
    [_Items addSubview:_Items1];
}

-(void)Creatitem {
    _Summay = [FactoryUI createViewWithFrame:CGRectMake(0, 0,  SCREEN_W, 200)];
    _Summay.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:_Summay];
    UIView *inView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_W-20, 170)];
    inView.backgroundColor = COLOR_FA;
    inView.layer.borderWidth = 0.5;
    inView.layer.borderColor = [Color(221, 221, 221, 1) CGColor];
    [_Summay addSubview:inView];
    
    _line2 =[FactoryUI createLabelWithFrame:CGRectMake(10,0,SCREEN_W-40,1 ) text:nil textColor: [UIColor colorWithHexString:@"#DDDDDD"]font:[UIFont systemFontOfSize:12]];
    _line2.backgroundColor = COLOR_D;
    [inView addSubview:_line2];
    UILabel *summay = [FactoryUI createLabelWithFrame:CGRectMake(10,20,SCREEN_W-20,18 ) text:@"Summary" textColor: [UIColor colorWithHexString:@"#333333"]font:[UIFont systemFontOfSize:16]];
    summay.textAlignment = 1;
    [inView addSubview:summay];
    UILabel *total = [FactoryUI createLabelWithFrame:CGRectMake(10, summay.yzBottom +20, 120, 14 )text:@"Item Total" textColor:[UIColor colorWithHexString:@"#999999"] font:[UIFont systemFontOfSize:12]];
    [inView addSubview:total];
    UILabel *shipping = [FactoryUI createLabelWithFrame:CGRectMake(10,total.yzBottom +10, 120, 14 )text:@"Shipping" textColor:[UIColor colorWithHexString:@"#999999"] font:[UIFont systemFontOfSize:12]];
    [inView addSubview:shipping];
    UILabel *tax = [FactoryUI createLabelWithFrame:CGRectMake(10,shipping.yzBottom +10, 120, 14 )text:@"Tax" textColor:[UIColor colorWithHexString:@"#999999"] font:[UIFont systemFontOfSize:12]];
    [inView addSubview:tax];
    UILabel *ordertal = [FactoryUI createLabelWithFrame:CGRectMake(10,tax.yzBottom +10, 120, 14 )text:@"Order Total" textColor:[UIColor colorWithHexString:@"#999999"] font:[UIFont systemFontOfSize:12]];
    [inView addSubview:ordertal];
    _ordertal = [FactoryUI createLabelWithFrame:CGRectMake(SCREEN_W-100,total.yzTop, 100, 14 )text:@"$" textColor:[UIColor colorWithHexString:@"#333333"] font:[UIFont systemFontOfSize:12]];
    [inView addSubview:_ordertal];
    _ordertal2 = [FactoryUI createLabelWithFrame:CGRectMake(SCREEN_W-100,_ordertal.yzBottom+9, 100, 14 )text:@"$" textColor:[UIColor colorWithHexString:@"#333333"] font:[UIFont systemFontOfSize:12]];
    [inView addSubview:_ordertal2];
    _ordertal3 = [FactoryUI createLabelWithFrame:CGRectMake(SCREEN_W-100,_ordertal2.yzBottom+9, 100, 14 )text:@"$0" textColor:[UIColor colorWithHexString:@"#333333"] font:[UIFont systemFontOfSize:12]];
    [inView addSubview:_ordertal3];
    _ordertal4 = [FactoryUI createLabelWithFrame:CGRectMake(SCREEN_W-100,_ordertal3.yzBottom+9, 100, 14 )text:@"$" textColor:[UIColor colorWithHexString:@"#333333"] font:[UIFont systemFontOfSize:12]];
    [inView addSubview:_ordertal4];
    _tableView.tableFooterView = _Summay;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.productArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailProcessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    OrderProduct *model = self.productArray[indexPath.row];
    cell.model = model;
    return cell;
}

-(void)createItemproduct:(NSArray*)image1 total:(NSArray*)total ship:(NSDictionary*)shiping{
    for (NSDictionary *dic in total) {
        if ([[dic valueForKey:@"code"] isEqualToString:@"sub_total"]) {
            _ordertal.text = [NSString stringWithFormat:@"$%@", [dic valueForKey:@"value"]];
        }
        if ([[dic valueForKey:@"code"] isEqualToString:@"tax"]) {
            _ordertal3.text = [NSString stringWithFormat:@"$%@", [dic valueForKey:@"value"]];
        }
        if ([[dic valueForKey:@"code"] isEqualToString:@"total"]) {
            _ordertal4.text = [NSString stringWithFormat:@"$%@", [dic valueForKey:@"value"]];
        }
    }
    _ordertal2.text = [shiping valueForKey:@"text"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
}

@end
