//
//  OverViewController.h
//  caowei
//
//  Created by Jason cao on 16/9/5.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"
#import "FooterView.h"
@interface OverViewController : UIViewController

@property (nonatomic , strong) HeaderView *header;
@property (nonatomic , strong) FooterView *footer;
- (void)refreshUI:(NSString *)productID;
- (void)refreshCellUI:(NSString *)productID;
@end
