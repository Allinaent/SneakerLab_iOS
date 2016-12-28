//
//  GShippingAddressViewController.m
//  SneakerLab
//
//  Created by 郭隆基 on 2016/12/8.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "GShippingAddressViewController.h"
#import "EditAddressTableViewCell.h"
#import "GEditAddressViewController.h"

@interface GShippingAddressViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSArray *all;
@property (nonatomic, strong) NSMutableArray *shipArr;
@property (nonatomic, strong) NSMutableArray *billArr;
@end

@implementation GShippingAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SET_NAV_MIDDLE
    self.title = @"Shipping address";
    self.view.backgroundColor = COLOR_FA;
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64-49)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.allowsMultipleSelection = NO;
    [self.tableview registerClass:[EditAddressTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableview.backgroundColor = COLOR_FA;
    UIView *foot = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableview.tableFooterView = foot;
    
    [self.view addSubview:_tableview];
    UIButton *add = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_H-64-49, SCREEN_W, 49)];
    add.backgroundColor = [UIColor colorWithHexString:@"#DE4536"];
    add.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
    add.titleLabel.textColor = [UIColor whiteColor];
    add.titleLabel.text = @"+Add shipping address";
    [add setTitle:@"+Add shipping address" forState:UIControlStateNormal];
    [add addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:add];
    
    //2 billing
    if (self.type.length != 0) {
        self.tableview.frame = CGRectMake(0, 55.5, SCREEN_W, SCREEN_H-64-49-55.5);
        self.title = @"Billing address";
        LJButton *btn = [[LJButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 50.5)];
        [self.view addSubview:btn];
        btn.backgroundColor = [UIColor whiteColor];
        UIImageView *right = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20.5, 20.5)];
        right.image = [UIImage imageNamed:@"xuanzhong"];
        btn.selected = NO;
        [btn addTapBlock:^(UIButton *btn) {
            btn.selected = !btn.selected;
            if (btn.selected) {
                [btn addSubview:right];
            }else{
                [right removeFromSuperview];
            }
        }];
        UILabel *same = [[UILabel alloc] initWithFrame:CGRectMake(55.5, 17, 200, 16.5)];
        same.font = FONT_14;
        same.textColor = COLOR_3;
        same.text = @"Same as shipping address";
        [btn addSubview:same];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestdatas];
}

- (void)requestdatas {
//    if ([self.type isEqualToString:@"billing"]) {
//        
//        return;
//    }
    [PHPNetwork PHPNetworkWithUrl:ADDRESSLIST_URL finish:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = [NSDictionary dictionaryWithJsonString:responseObject];
        _all = [dic valueForKey:@"data"];
        [self.billArr removeAllObjects];
        [self.shipArr removeAllObjects];
        for (NSDictionary *dict in _all) {
            if ([[dict valueForKey:@"type"] integerValue]==2) {
                [self.billArr addObject:dict];
            }else{
                [self.shipArr addObject:dict];
            }
        }
        [self.tableview reloadData];
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.type isEqualToString:@"billing"]) {
        return _billArr.count;
    }else{
        return _shipArr.count;
    }
    //return _all.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 125;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *type;
    if ([self.type isEqualToString:@"billing"]) {
        type = @"2";
    }else{
        type = @"1";
    }
    EditAddressTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    NSDictionary *dict = @{@"address_id":cell.address_id,@"fullname":cell.name,@"phone":cell.phone,@"address":cell.street,@"suite":cell.apt,@"city":cell.city,@"postcode":cell.postcode,@"country_id":cell.country_id,@"zone_id":cell.zone_id,@"set_default":@"1",@"type":type};
//    [PHPNetwork PHPNetworkWithParam:dict andUrl:EDITADDRESS_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
//        cell.selected = YES;
//        [self.tableview selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
//    } err:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];
    //测试用例
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"equipment_id",@"email",@"token",@"address_id",@"fullname",@"phone",@"address",@"suite",@"city",@"postcode",@"country_id",@"zone_id",@"set_default"];
    NSDictionary *dic = @{@"appKey" : APPKEY,
                          @"apiKey" : APIKEY,
                          @"equipment_id" : MYDEVICEID,
                          @"timestamp" : time,
                          @"email" : CWEMAIL,
                          @"token" : CWTOKEN,
                          @"address_id" : cell.address_id,
                          @"fullname" : cell.name,
                          @"phone" : cell.phone,
                          @"address" : cell.street,
                          @"suite" : cell.apt,
                          @"city" : cell.city,
                          @"postcode" : cell.postcode,
                          @"country_id" : cell.country_id,
                          @"zone_id" : cell.zone_id,
                          @"set_default" : @"1",
                          @"type" : type
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
    [manager POST:EDITADDRESS_URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        DebugLog(@"%@", dic);
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        DebugLog(@"%@", str);
        cell.selected = YES;
        [self.tableview selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}

- (void)setDefaultAction:(id)sender {
    //先将未到时间执行前的任务取消。
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(editRequestWith:) object:sender];
    [self performSelector:@selector(editRequestWith:) withObject:sender afterDelay:0.5f];
}

- (void)editRequestWith:(NSString *)address_id {
    [MBManager showPermanentAlert:@""];
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"equipment_id",@"fullname",@"phone",@"address",@"suite",@"city",@"postcode",@"country_id",@"zone_id",@"email",@"token",@"set_default",@"address_id"];
    NSDictionary *dic = @{@"appKey" : APPKEY,
                          @"apiKey" : APIKEY,
                          @"equipment_id" : MYDEVICEID,
                          @"timestamp" : time,
                          @"fullname" : @"",
                          @"phone" : @"",
                          @"address" : @"",
                          @"suite": @"",
                          @"city" : @"",
                          @"postcode" : @"",
                          @"country_id" : @"",
                          @"zone_id" : @"",
                          @"set_default":@"1",
                          @"address_id":address_id,
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
    [[CWAPIClient sharedClient] POSTRequest:EDITADDRESS_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         [MBManager hideAlert];
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         LJLog(@"%@",error);
     }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditAddressTableViewCell *cell = [EditAddressTableViewCell cellWithTableView:tableView];
    NSDictionary *dict;
    if ([self.type isEqualToString:@"billing"]) {
        dict = _billArr[indexPath.row];
    }else{
        dict = _shipArr[indexPath.row];
    }
    cell.name = [dict valueForKey:@"fullname"];
    cell.phone = [dict valueForKey:@"phone"];
    cell.city = [dict valueForKey:@"city"];
    cell.street = [dict valueForKey:@"address_1"];
    cell.country = [dict valueForKey:@"country"];
    cell.address_id = [dict valueForKey:@"address_id"];
    cell.apt = [dict valueForKey:@"suite"];
    cell.postcode = [dict valueForKey:@"postcode"];
    cell.country_id = [dict valueForKey:@"country_id"];
    cell.zone_id = [dict valueForKey:@"zone_id"];
    cell.set_default = [dict valueForKey:@"is_default"];
    if ([cell.set_default integerValue]==1) {
        [self.tableview selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        cell.del.hidden = YES;
    }
    return cell;
}

- (void)addButtonAction {
    GEditAddressViewController *vc = [[GEditAddressViewController alloc] init];
    vc.add = YES;
    if ([self.type isEqualToString:@"billing"]) {
        vc.type = @"billing";
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSArray *)all {
    if (!_all) {
        _all = [NSArray array];
    }
    return _all;
}

- (NSMutableArray *)shipArr {
    if (!_shipArr) {
        _shipArr = [NSMutableArray array];
    }
    return _shipArr;
}

- (NSMutableArray *)billArr {
    if (!_billArr) {
        _billArr = [NSMutableArray array];
    }
    return _billArr;
}
@end
