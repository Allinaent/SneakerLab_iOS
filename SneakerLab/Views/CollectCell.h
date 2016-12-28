//
//  CollectCell.h
//  SneakerLab
//
//  Created by edz on 2016/10/21.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectModel.h"
@interface CollectCell : UICollectionViewCell
{
    UIImageView *_imageView;
    UILabel *_nameLabel;
    UILabel *_priceLabel1;
}

- (void)refreshUI:(CollectModel *)model;

@end
