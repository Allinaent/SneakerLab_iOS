//
//  OrderHistoryViewController.m
//  SneakerLab
//
//  Created by edz on 2016/11/1.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "OrderHistoryViewController.h"
#import "OrderHistoryCell.h"
#import "OrderProduct.h"
#import "OrderHistoryModel.h"
#import "UIView+YZTCView.h"
#import "OrderHeaderView.h"
#import "CancelView.h"
#import "OptionModel.h"
#import "DetailProcessController.h"
#import "RequestRefundViewController.h"
#import "ReviewViewController.h"
@interface OrderHistoryViewController ()<UITableViewDelegate ,UITableViewDataSource>
{
    UITableView *_tableView;
    NSString *_order_status;
    NSString *_sizename;
}
@property(nonatomic,strong)NSMutableArray <OrderHistoryModel *>* allSectionArray;
@property(nonatomic,strong)NSMutableArray *productArray;
@property(nonatomic,strong)NSMutableArray *optionArray;

@end

@implementation OrderHistoryViewController
-(NSMutableArray *)productArray{
    if (_productArray == nil) {
        _productArray = [[NSMutableArray alloc]init];
    }
    return _productArray;
}

-(NSMutableArray *)optionArray{
    if (_optionArray == nil) {
        _optionArray = [[NSMutableArray alloc]init];
    }
    return _optionArray;
}

- (NSMutableArray<OrderHistoryModel *> *)array {
    if (!_allSectionArray) {
        _allSectionArray = [NSMutableArray array];
    }
    return _allSectionArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Order History";
    self.view.backgroundColor = [UIColor whiteColor];
    [_tableView registerClass:[OrderHistoryCell class] forCellReuseIdentifier:@"cell"];
    [self CreatUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshUI];
}

-(void)CreatUI{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark ---tableView协议
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [self.array[section] product].count;
    return count;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = [UIColor whiteColor];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderHistoryCell *cell = (OrderHistoryCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    DebugLog(@"%f", cell.cellheight);
    return cell.cellheight;
}

//显示header的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 90;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]init];
    footerView.frame = CGRectMake(0, 0, SCREEN_W, 50);
    footerView.backgroundColor = [UIColor whiteColor];
    OrderHistoryModel *model = _allSectionArray[section];
    if ([model.order_status isEqualToString:@"Shipping"]) {
        //shipping
        UIButton *detailShip = [FactoryUI createButtonWithFrame:CGRectMake(SCREEN_W - 180, 10, 65, 30) title:@"Detail" titleColor:[UIColor colorWithHexString:@"#666666"] imageName:nil backgroundImageName:nil target:self selector:nil];
        detailShip.layer.cornerRadius = 4;
        detailShip.backgroundColor = [UIColor colorWithHexString:@"#E7E7E7"];
        [footerView addSubview:detailShip];
        
        UIButton *Confirm = [FactoryUI createButtonWithFrame:CGRectMake(detailShip.yzRight+10,10 , 90, 30) title:@"Confirm" titleColor:[UIColor whiteColor] imageName:nil backgroundImageName:nil target:self selector:nil];
        Confirm.backgroundColor = [UIColor colorWithHexString:@"#DE4536"];
        Confirm.layer.cornerRadius = 4;
        [footerView addSubview:Confirm];
    }else if ([model.order_status isEqualToString:@"Processing"])
    {
        //Processing
        UIButton *detail = [FactoryUI createButtonWithFrame:CGRectMake(SCREEN_W-80, 10, 65, 30) title:@"Detail" titleColor:[UIColor colorWithHexString:@"#666666"] imageName:nil backgroundImageName:nil target:self selector:@selector(detailProcess:)];
        detail.tag = section + 500;
        detail.backgroundColor = [UIColor colorWithHexString:@"#E7E7E7"];
        detail.layer.cornerRadius = 8;
        [footerView addSubview:detail];
        UIButton *Cancel = [FactoryUI createButtonWithFrame:CGRectMake(15, 17 , 40.5, 15.5) title:nil titleColor:[UIColor colorWithHexString:@"#999999"] imageName:nil backgroundImageName:nil target:self selector:@selector(Cancel:)];
        Cancel.tag = section + 500;
        [footerView addSubview:Cancel];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"Cancel"];
        NSRange strRange = {0,[str length]};
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
        [str addAttribute:NSForegroundColorAttributeName value:COLOR_9 range:strRange];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:13] range:strRange];
        [Cancel setAttributedTitle:str forState:UIControlStateNormal];
    }else if ([model.order_status isEqualToString:@"Completed"]){
        //Completed
        UIButton *detailCompleted = [FactoryUI createButtonWithFrame:CGRectMake(SCREEN_W-155, 10, 65, 30) title:@"Detail" titleColor:[UIColor colorWithHexString:@"#666666"] imageName:nil backgroundImageName:nil target:self selector:@selector(completeDetailAction:)];
            detailCompleted.layer.cornerRadius = 4;
            detailCompleted.backgroundColor = [UIColor colorWithHexString:@"#E7E7E7"];
        detailCompleted.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
            [footerView addSubview:detailCompleted];
        detailCompleted.tag = 500 + section;
        UIButton *reviews = [FactoryUI createButtonWithFrame:CGRectMake(detailCompleted.yzRight+10,10 , 65, 30) title:@"Reviews" titleColor:[UIColor colorWithHexString:@"#666666"] imageName:nil backgroundImageName:nil target:self selector:@selector(reviewsAction:)];
            reviews.backgroundColor = [UIColor  colorWithHexString:@"#E7E7E7"];
            reviews.layer.cornerRadius = 4;
            [footerView addSubview:reviews];
        reviews.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        reviews.tag = 500 + section;
        UIButton *request = [FactoryUI createButtonWithFrame:CGRectMake(15,detailCompleted.yzTop, 94, 40) title:nil titleColor:[UIColor colorWithHexString:@"#999999"] imageName:nil backgroundImageName:nil target:self selector:@selector(requestRefundAction:)];
        request.titleLabel.font = [UIFont systemFontOfSize:13];
        request.titleLabel.textAlignment = 0;
        [footerView addSubview:request];
        request.tag = 500 + section;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"Request Refund"];
        NSRange strRange = {0,[str length]};
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
        [str addAttribute:NSForegroundColorAttributeName value:COLOR_9 range:strRange];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:13] range:strRange];
        [request setAttributedTitle:str forState:UIControlStateNormal];
    }
    return footerView;
}

- (void)completeDetailAction:(UIButton *)sender {
    DetailProcessController *detail = [[DetailProcessController alloc] init];
    NSDictionary *dic = _productArray[sender.tag - 500];
    detail.orderID = [dic valueForKey:@"order_id"];
    detail.state = 1;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)reviewsAction:(UIButton *)sender {
    ReviewViewController *vc = [[ReviewViewController alloc] init];
    OrderHistoryModel *model = self.allSectionArray[sender.tag - 500];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)requestRefundAction:(UIButton *)sender {
    RequestRefundViewController *vc = [[RequestRefundViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    OrderHeaderView *sectionLabel = [[OrderHeaderView alloc]init];
    sectionLabel.frame = CGRectMake(0, 0, SCREEN_W, 90) ;
    sectionLabel.tag = 500 + section;
    sectionLabel.backgroundColor = [UIColor whiteColor];
    if (_allSectionArray.count>=section&&_allSectionArray.count!=0) {//durex
        OrderHistoryModel *model = _allSectionArray[section];
        sectionLabel.model = model;
    }
    return sectionLabel;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[OrderHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    if (self.allSectionArray.count>0) {
        OrderProduct *model = [self.allSectionArray[indexPath.section] product][indexPath.row];
        cell.model = model;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)refreshUI{
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"page",@"equipment_id",@"email",@"limit",@"token"];
    NSDictionary *dic = @{@"page" : @"1",
                          @"limit" : @"10",
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
    [[CWAPIClient sharedClient] POSTRequest:DINGDANLIEBIAO_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSArray *dataArray = responseObject[@"data"];
         DebugLog(@"%@", dataArray);
         _productArray = [NSMutableArray arrayWithArray:dataArray];
         NSMutableArray *array = [NSMutableArray array];
         for (NSDictionary *dict in dataArray)
        {
            //相当于section的model
            OrderHistoryModel *historyListModel = [[OrderHistoryModel alloc]init];
            historyListModel.order_status = dict[@"order_status"];
            historyListModel.order_id  = dict[@"order_id"];
            historyListModel.date_added = dict[@"date_added"];
            NSArray *productRowArray = dict[@"product"];
            NSMutableArray *order = [[NSMutableArray alloc] init];
            if (productRowArray != nil && ![productRowArray isKindOfClass:[NSNull class]] && productRowArray.count != 0)
            {
               for (NSDictionary *dic in productRowArray)
                {
                    OrderProduct *rowModel = [[OrderProduct alloc] init];
                    [rowModel setValuesForKeysWithDictionary:dic];
                    [order addObject:rowModel];
                }
                historyListModel.product = order;
            }
            [array addObject:historyListModel];
        }
         self.allSectionArray = array;
         [_tableView reloadData];
         [self showView];
    } failure:^(NSURLSessionDataTask *task, NSError *error)
    {
         LJLog(@"%@",error);
    }];
}

#pragma mark ---判断显示有无收藏的视图
- (void)showView
{
    if (_allSectionArray.count == 0)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        UIImageView *image = [FactoryUI createImageViewWithFrame:CGRectMake(self.view.center.x - 40, self.view.center.y - 40, 80, 80) imageName:@" 收藏－kong"];
        UILabel *label = [FactoryUI createLabelWithFrame:CGRectMake(20, self.view.center.y + 40, SCREEN_W-40, 20) text:@"No order yet" textColor:[UIColor blackColor] font:[UIFont fontWithName:@"HelveticaNeue" size:15]];
        label.textAlignment = 1;
        label.textColor = COLOR_9;
        [self.view addSubview:image];
        [self.view addSubview:label];
    }
}

-(void)Cancel:(UIButton *)sender {
    CancelView *cancel = [[CancelView alloc]initWithFrame:CGRectMake((SCREEN_W-242)/2, (SCREEN_H-177-64)/2, 242, 177)];
    NSDictionary *dic = _productArray[sender.tag - 500];
    cancel.orderID = [dic valueForKey:@"order_id"];
    cancel.backgroundColor = [UIColor colorWithHexString:@"#333333"];
    cancel.layer.cornerRadius = 5;
    cancel.layer.opaque = 0.7;
    cancel.block = ^(int state) {
        if (state == 1) {
            [self refreshUI];
        }
    };
    [self.view addSubview:cancel];
}

-(void)detailProcess:(UIButton *)sender {
    DetailProcessController *detail = [[DetailProcessController alloc] init];
    NSDictionary *dic = _productArray[sender.tag - 500];
    detail.orderID = [dic valueForKey:@"order_id"];
    detail.state = 0;
    [self.navigationController pushViewController:detail animated:YES];
}

@end
