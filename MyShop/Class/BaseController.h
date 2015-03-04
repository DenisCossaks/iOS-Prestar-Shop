//
//  BaseController.h
//  MyShop
//
//  Created by SilverStar on 8/1/14.
//  Copyright (c) 2014 SilverStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseController : UIViewController


- (void) showLoading : (NSString*) label;
-(void)  showChangeLabel:(NSString*) label;
- (void) hideLoading;
- (void) showFail;
- (void) showFail:(NSString*) label;
- (void)showWithCustomView:(NSString * ) label;


@end
