//
//  RatingController.m
//  caowei
//
//  Created by Jason cao on 16/9/5.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "RatingController.h"
#import "RatingCell.h"
#import "RatingModel.h"
#import "RatingHeadModel.h"
#import "ProductRatingHeaderView.h"

#define k_TableViewHeight (SCREEN_H-64)

@interface RatingController ()<UITableViewDelegate , UITableViewDataSource>
{
    NSMutableArray *_dataSource;
}
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic, strong) ProductRatingHeaderView *header;
@end

@implementation RatingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Details";
    [self createUI];
    [self refreshUI];
}

- (void)createUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    if (self.header==nil) {
        _header = [[ProductRatingHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 147.5)];
    }
    self.tableView.tableHeaderView = _header;
    _header.model.name = self.productName;
    _header.model.boughtNum = self.bought;
    _header.model.saveNum = [NSString stringWithFormat:@"%ld", self.save];
    _header.model.starNum = self.star;
    _header.model.ratingNum = [NSString stringWithFormat:@"%ld", _ratingNum];
    _header.model.imageUrl = self.productImage;
    [_header refreshUI];
    
    [self.view addSubview:_tableView];
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CGFloat footerHeight = MAX(94.5, k_TableViewHeight - _dataSource.count*94.5);
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, footerHeight)];
    UILabel *no = [[UILabel alloc] init];
    [footer addSubview:no];
    [no mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footer.mas_top).with.offset(36.5);
        make.centerX.equalTo(footer.mas_centerX);
    }];
    no.textColor = COLOR_9;
    no.font = [UIFont fontWithName:DEFAULT_FONT size:15];
    no.text = @"No more reviews";
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 94.5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RatingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ratingCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell)
    {
        cell = [[RatingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ratingCell"];
    }
    if (_dataSource)
    {
        RatingModel *model = _dataSource[indexPath.row];
        [cell refreshUI:model];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RatingModel *model = _dataSource[indexPath.row];
    return 50 + model.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)refreshUI
{
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"page",@"equipment_id",@"limit",@"product_id"];
    NSDictionary *dic = @{@"page" : @"0",
                          @"limit" : @"10",
                          @"appKey" : APPKEY,
                          @"apiKey" : APIKEY,
                          @"equipment_id" : MYDEVICEID,
                          @"timestamp" : time,
                          @"product_id" : self.productID
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
    
    [[CWAPIClient sharedClient] POSTRequest:RATING_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSArray *dataArr = responseObject[@"data"];
         for (NSDictionary *dic in dataArr)
         {
             RatingModel *model = [[RatingModel alloc] init];
             [model setValuesForKeysWithDictionary:dic];
             [self.dataSource addObject:model];
         }
         [_tableView reloadData];
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"%@",error);
     }];
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil)
    {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
