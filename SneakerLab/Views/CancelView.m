//
//  CancelView.m
//  SneakerLab
//
//  Created by edz on 2016/11/3.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "CancelView.h"
#import "UIView+YZTCView.h"
@interface CancelView ()
@property(nonatomic,strong)UILabel *surelabel;
@property(nonatomic,strong)UIButton *confirm;
@property(nonatomic,strong)UIButton *Cancel;
@end
@implementation CancelView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self CreatUI];
    }
    return self;

}

-(void)CreatUI
{
    _surelabel = [FactoryUI createLabelWithFrame:CGRectMake(20, 30,242-40, 120) text:nil textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16]];
    _surelabel.text = @"Are you sure?If you cancel this order then you can not get your goods.";
    _surelabel.numberOfLines = 0;
    [_surelabel sizeToFit];
    [self addSubview:_surelabel];
    _confirm = [FactoryUI createButtonWithFrame:CGRectMake(15, self.frame.size.height-60, 98, 36) title:@"Confirm" titleColor:[UIColor whiteColor] imageName:nil backgroundImageName:nil target:self selector:@selector(confirm1)];
    _confirm.backgroundColor = [COLOR_3 colorWithAlphaComponent:0.69];
    _confirm.layer.cornerRadius = 5;
    
    [self addSubview:_confirm];
    _Cancel = [FactoryUI createButtonWithFrame:CGRectMake(self.frame.size.width-98-15, _confirm.yzTop, 98, 36) title:@"Cancel" titleColor:[UIColor whiteColor] imageName:nil backgroundImageName:nil target:self selector:@selector(cancel1)];
    _Cancel.backgroundColor = [UIColor redColor];
    _Cancel.layer.cornerRadius = 5;
    [self addSubview:_Cancel];

}

-(void)cancel1{
    [self removeFromSuperview];
}

-(void)setOrderID:(NSString *)orderID{
    _orderID = orderID;
}
//商品的状态的接口
-(void)confirm1{
        NSString *time = [self getCurrentTimestamp];
        NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"equipment_id",@"email",@"order_id",@"order_status_id",@"token"];
        NSDictionary *dic = @{@"order_id" : self.orderID,
                              @"order_status_id" : @"7",
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
        [[CWAPIClient sharedClient] POSTRequest:DINGDANSTATUS_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
         {
             [self removeFromSuperview];
             LJLog(@"%@",responseObject);
             self.block(1);
             //成功则刷新页面
         } failure:^(NSURLSessionDataTask *task, NSError *error)
         {
             LJLog(@"%@",error);
             [MBManager showBriefAlert:@"Cancel Fail"];
         }];
}

@end
