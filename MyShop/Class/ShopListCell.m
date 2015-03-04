//
//  ShopListCell.m
//  MyShop
//
//  Created by SilverStar on 7/25/14.
//  Copyright (c) 2014 SilverStar. All rights reserved.
//

#import "ShopListCell.h"

#import "MyCacheProduct.h"
#import "DLImageLoader.h"

#import "Global.h"


@implementation ShopListCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setProduct:(NSString*) url
{
    self.activityLoading.hidden = NO;
    
    self.viewBack.layer.borderColor = [UIColor grayColor].CGColor;
    self.viewBack.layer.borderWidth = 1;
    self.viewBack.layer.cornerRadius = 5;
    
    
    MyCacheProduct * product = [[MyCacheProduct sharedInstance] init];
    STATUS status = [product getStatus:url];
    
    if (status == STATUS_NONE) {
     
        [product loadData:url
                completed:^{
                    
                    NSLog(@"completed");
                    
                    self.activityLoading.hidden = YES;
                    
                    NSDictionary * dic = [product getData:url];
                    [self setUI:dic];
                    
                }
                   failed:^ {
                       
                       NSLog(@"failed");
                       
                   }
         ];

    }
    else if (status == STATUS_DONE) {

        self.activityLoading.hidden = YES;
        
        NSDictionary * dic = [product getData:url];
        [self setUI:dic];
        
    }
    else {
        return;
    }
    
}

- (void) setUI :(NSDictionary * ) product
{
    NSString * title = product[@"name"][@"language"][@"text"];
    self.lbTitle.text = [[Global sharedInstance] correctString:title];
    
    NSString * description = product[@"description_short"][@"language"][@"text"];
    self.lbDescription.text = [[Global sharedInstance] correctString:description];

    float price = [[[Global sharedInstance] correctString:product[@"price"][@"text"]] floatValue];
    self.lbPrice.text = [NSString stringWithFormat:@"$%.2f", price];

    
    NSString * urlImage = product[@"id_default_image"][@"xlink:href"];
    
    [DLImageLoader loadImageFromURL:urlImage
                          completed:^(NSError *error, NSData *imgData) {
                              if (error == nil) {
                                  // if we have no errors
                                  UIImage * image = [UIImage imageWithData:imgData];
                                  [self.ivThumbnail setImage:image];
                              }
                              else {
                              }
                              
                          }];
}

@end
