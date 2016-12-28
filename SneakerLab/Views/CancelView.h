//
//  CancelView.h
//  SneakerLab
//
//  Created by edz on 2016/11/3.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ConfirmBlock)(int );

@interface CancelView : UIView
@property(nonatomic,strong) NSString *orderID;
@property(nonatomic,copy) ConfirmBlock block;
@end
