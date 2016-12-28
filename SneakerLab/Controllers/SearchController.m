//
//  SearchController.m
//  SneakerLab
//
//  Created by Jason cao on 2016/10/11.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "SearchController.h"
#import "RootViewController.h"
@interface SearchController ()
{
    UISearchController *_searchController;
}
@end

@implementation SearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.hidesBackButton = YES;
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.obscuresBackgroundDuringPresentation = NO;

    _searchController.searchBar.placeholder = [NSString stringWithCString:"搜索" encoding:NSUTF8StringEncoding];
    //设置searchBar的背景色
    UIImage * searchBarBg1 = [self GetImageWithColor:[UIColor blackColor] andHeight:40];
    [_searchController.searchBar setBackgroundImage:searchBarBg1];
    [_searchController.searchBar setBackgroundColor:[UIColor clearColor]];
    //设置输入框的背景色
    UIImage * searchBarBg2 = [self GetImageWithColor:[UIColor colorWithWhite:1 alpha:1.000] andHeight:40];
    [_searchController.searchBar setSearchFieldBackgroundImage:searchBarBg2 forState:UIControlStateNormal];
    //设置字体颜色/大小，和圆角边框
    UITextField *searchField = [_searchController.searchBar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor whiteColor];
    [searchField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    searchField.font = [UIFont systemFontOfSize:17];
    searchField.layer.cornerRadius = _searchController.searchBar.frame.size.height/2;
    searchField.layer.masksToBounds = YES;
    [_searchController.searchBar setContentMode:UIViewContentModeLeft];
    self.navigationItem.titleView = _searchController.searchBar;
}

//生成图片
- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
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
