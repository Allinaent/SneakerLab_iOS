//
//  ProductCell.h
//  caowei
//
//  Created by Jason cao on 2016/9/19.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
@interface ProductCell : UICollectionViewCell
{
    int _productId;
    UIImageView *_imageView;
    UILabel *_nameLabel;
    UILabel *_priceLabel1;
    UILabel *_priceLabel2;
    UILabel *_viewLabel;
}

- (void)refreshUI:(ProductModel *)model;
@end
