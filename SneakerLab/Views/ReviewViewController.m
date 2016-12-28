//
//  ReviewViewController.m
//  SneakerLab
//
//  Created by 郭隆基 on 2016/11/24.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "ReviewViewController.h"
#import "LEOStarView.h"
#import "BRPlaceholderTextView.h"
#import "OrderHistoryModel.h"
#import "ReviewTableViewCell.h"
#import "ReviewModel.h"
#import "OrderProduct.h"

@interface ReviewViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) LEOStarView *starView;
@property (strong, nonatomic) BRPlaceholderTextView *text;
@property (assign, nonatomic) NSInteger score;
@property (strong, nonatomic) UITableView *tableview;
@end

@implementation ReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SET_NAV_MIDDLE
    self.title = @"Review";
    self.view.backgroundColor = [UIColor colorWithHexString:@"EBEBF1"];
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    [self setupview];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReviewTableViewCell *cell = [ReviewTableViewCell cellWithTableView:tableView];
    ReviewModel *model = [[ReviewModel alloc] init];
    OrderProduct *product = self.model.product[indexPath.row];
    model.product_id = product.order_product_id;
    cell.model = model;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.product.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 365;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)setupview {
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
