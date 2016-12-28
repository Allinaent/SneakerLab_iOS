//
//  OrderRatedCell.h
//  caowei
//
//  Created by Jason cao on 2016/10/9.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderRatedModel.h"
@interface OrderRatedCell : UICollectionViewCell
{
    UIImageView *_imageView;
}

- (void)refreshUI:(OrderRatedModel *)model;

@end
