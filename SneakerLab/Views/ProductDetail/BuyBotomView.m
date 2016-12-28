//
//  BuyBotomView.m
//  GongDoo_iphone
//
//  Created by 员延孬 on 16/6/1.
//  Copyright © 2016年 路之遥网络科技有限公司. All rights reserved.
//

#import "BuyBotomView.h"
#import "SignInController.h"
#import "UIView+Extension.h"

@implementation BuyBotomView

+(id)botomViewWithFrame:(CGRect)frame withDelegate:(id<BotomViewDelegate>)delegate withPrice:(NSString *)price withProductID:(NSString *)productID {
    
    BuyBotomView * botomView=[[BuyBotomView alloc]initWithFrame:frame];
    botomView.botomViewDelegate=delegate;
    
    UIView *topline = [[UIView alloc] init];
    [botomView addSubview:topline];
    [topline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(botomView);
        make.height.equalTo(1);
    }];
    topline.backgroundColor = COLOR_D;
    
    LJButton *heart = [[LJButton alloc] init];
    [botomView addSubview:heart];
    [heart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(botomView.mas_left).with.offset(17.5);
        make.top.equalTo(botomView.mas_top).with.offset(14);
        make.size.mas_equalTo(CGSizeMake(22.5, 18.5));
    }];
    [heart setSelectedImageStr:@"保存填充" andUnselectImageStr:@"保存-拷贝"];
    //遍历收藏列表来确定button的选中状态
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"signInSuccessful"]boolValue]==YES) {
        
        [PHPNetwork PHPNetworkWithParam:nil andUrl:COllECTION_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
            NSArray *arr = [responseObject objectForKey:@"data"];
            for (NSDictionary *dic in arr) {
                if ([[dic valueForKey:@"product_id"] isEqualToString:productID]) {
                    heart.selected = YES;
                }
            }
        } err:^(NSURLSessionDataTask *task, NSError *error) {
            LJLog(@"%@", error);
        }];
    }
    else{
        SignInController *vc = [[SignInController alloc] init];
        [[UIView currentViewController].navigationController pushViewController:vc animated:YES];
    }
    [heart addTapBlock:^(UIButton *btn) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"signInSuccessful"] boolValue] == YES) {
            
            if (btn.selected)
            {
                //发送请求删除
                NSDictionary *dic = @{@"product_id":productID};
                [PHPNetwork PHPNetworkWithParam:dic andUrl:DELCOLLECTION_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
                    btn.selected = NO;
                } err:^(NSURLSessionDataTask *task, NSError *error) {
                    
                }];
            }
            else
            {
                //发送请求更改
                NSDictionary *dic = @{@"product_id":productID};
                [PHPNetwork PHPNetworkWithParam:dic andUrl:ADDCOLLECTION_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
                    btn.selected = YES;
                } err:^(NSURLSessionDataTask *task, NSError *error) {
                    
                }];
            }
        }else{
            //跳转到登录页面
            SignInController *vc = [[SignInController alloc] init];
            [[UIView currentNavigationController] pushViewController:vc animated:YES];
            
        }
    }];
    UIView *span = [[UIView alloc] init];
    [botomView addSubview:span];
    [span mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(heart.mas_right).with.offset(17);
        make.top.equalTo(botomView.mas_top).with.offset(8);
        make.bottom.equalTo(botomView.mas_bottom).with.offset(-11);
        make.width.mas_equalTo(1);
    }];
    span.backgroundColor = COLOR_D;
    
    UIImageView *tagSelf = [[UIImageView alloc] init];
    [botomView addSubview:tagSelf];
    [tagSelf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(span.mas_right).with.offset(4.5);
        make.top.equalTo(botomView.mas_top);
        make.bottom.equalTo(botomView.mas_bottom);
        make.width.mas_equalTo(55);
    }];
    tagSelf.image = [UIImage imageNamed:@"标签 copy"];
    tagSelf.contentMode = UIViewContentModeCenter;
    UILabel *priceLB = [[UILabel alloc] init];
    [botomView addSubview:priceLB];
    [priceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tagSelf.mas_right).with.offset(3);
        make.centerY.equalTo(tagSelf.mas_centerY);
    }];
    priceLB.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
    priceLB.textColor = [UIColor colorWithHexString:@"#DA4937"];
    priceLB.text = [NSString stringWithFormat:@"$%@", price];
    UIButton *commit = [[UIButton alloc] init];
    [botomView addSubview:commit];
    [commit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(botomView.mas_right);
        make.top.equalTo(botomView.mas_top);
        make.bottom.equalTo(botomView.mas_bottom);
        make.width.mas_equalTo(SCREEN_W/3);
    }];
    commit.backgroundColor = [UIColor colorWithHexString:@"#DA4937"];
    commit.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
    [commit setTitle:@"Buy" forState:UIControlStateNormal];
    [commit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    commit.tag = 101;
    [commit addTarget:botomView action:@selector(clikedBtn:) forControlEvents:UIControlEventTouchUpInside];
    return botomView;
}
-(void)clikedBtn:(UIButton*)btn{
    if ([self.botomViewDelegate respondsToSelector:@selector(clickedBotomViewBtnWithBtnTag:)]) {
        [self.botomViewDelegate clickedBotomViewBtnWithBtnTag:btn.tag];
    }
}

@end
