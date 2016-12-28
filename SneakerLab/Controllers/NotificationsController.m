//
//  NotificationsController.m
//  caowei
//
//  Created by Jason cao on 16/9/2.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "NotificationsController.h"

@interface NotificationsController ()<UITableViewDelegate , UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataSource;
}

@end

@implementation NotificationsController

- (void)viewDidLoad {
    [super viewDidLoad];
    SET_NAV_MIDDLE
    self.title = @"Notifications";
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.tableFooterView = view;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_W, 30)];
    label.text = @"No notification";
    label.font = FONT_15;
    label.textColor = COLOR_9;
    label.textAlignment = 1;
    [_tableView addSubview:label];
}

#pragma mark ----tableView 协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.imageView.image = [UIImage imageNamed:@"Hot@3x"];
    cell.textLabel.text = @"caowei";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
