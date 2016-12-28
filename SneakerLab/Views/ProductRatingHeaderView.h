//
//  ProductRatingHeaderView.h
//  SneakerLab
//
//  Created by 郭隆基 on 16/11/7.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RatingHeadModel;
@interface ProductRatingHeaderView : UIView
{
    
}
@property (nonatomic, strong) RatingHeadModel *model;
- (void)refreshUI;
@end
