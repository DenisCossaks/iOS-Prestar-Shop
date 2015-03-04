//
//  Global.h
//  MyShop
//
//  Created by SilverStar on 7/30/14.
//  Copyright (c) 2014 SilverStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Global : NSObject


@property (nonatomic, strong) NSMutableArray * g_arrShopItem;


+ (Global *)sharedInstance;

- (NSString *) correctString:(NSString*) string;


@end
