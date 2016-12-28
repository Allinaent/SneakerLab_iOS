//
//  DescriptionController.m
//  caowei
//
//  Created by Jason cao on 16/9/5.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "DescriptionController.h"
#import "GTMNSString+HTML.h"
#pragma mark - 商品的详情
@interface DescriptionController ()<UIWebViewDelegate>
@end

@implementation DescriptionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshUIWithID:self.productID];
}

- (void)refreshUIWithID:(NSString *)productID
{
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"product_id",@"equipment_id"];
    NSDictionary *dic = @{@"product_id" : productID,
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
    
    [[CWAPIClient sharedClient] POSTRequest:PRODUCTDETAIL_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"%@",responseObject);
         NSDictionary *dic = responseObject[@"data"];
         NSString *description = dic[@"description"];
         UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_W, SCREEN_H-40-64-54)];
         webView.delegate = self;
         NSString *htmlString = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head>%@", (SCREEN_W-20), description.gtm_stringByUnescapingFromHTML];
         [webView loadHTMLString:htmlString baseURL:nil];
         [self.view addSubview:webView];
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"%@",error);
     }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
