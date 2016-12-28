//
//  HeaderView.h
//  caowei
//
//  Created by Jason cao on 16/9/6.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyStarView.h"
@interface HeaderView : UIView
- (instancetype)initWithFrame:(CGRect)frame withArr: (NSArray *)image;
@property (nonatomic , strong) UILabel *nameLabel;
@property (nonatomic , strong) UIButton *likeBtn;
@property (nonatomic , copy) NSString *productID;
@property (nonatomic , strong) MyStarView *starView;
@property (nonatomic , strong) UILabel*reviewedLabel;
@property (nonatomic , assign) BOOL likeBtnState;
@end
