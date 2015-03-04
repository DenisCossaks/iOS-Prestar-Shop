//
//  ShopListCell.h
//  MyShop
//
//  Created by SilverStar on 7/25/14.
//  Copyright (c) 2014 SilverStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopListCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIView *viewBack;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityLoading;

@property (strong, nonatomic) IBOutlet UILabel *lbTitle;
@property (strong, nonatomic) IBOutlet UILabel *lbPrice;
@property (strong, nonatomic) IBOutlet UIImageView *ivThumbnail;
@property (strong, nonatomic) IBOutlet UILabel *lbDescription;
@property (strong, nonatomic) IBOutlet UIButton *btnAddCart;

- (void)setProduct:(NSString*) url;

@end
