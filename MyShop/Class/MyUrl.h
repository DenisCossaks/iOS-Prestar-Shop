//
//  MyUrl.h
//  MyShop
//
//  Created by SilverStar on 7/25/14.
//  Copyright (c) 2014 SilverStar. All rights reserved.
//

#import <Foundation/Foundation.h>

#define API_KEY                @"CQ8NFLNPR7YVZ7UA26REMPPDQKR72USV"

#define SERVER_URL            @"http://198.1.65.69/prestashop"


@interface MyUrl : NSObject

+(NSString*) getServerUrl;
+(NSString*) getProductsList;
+(NSString*) getProductsDetail:(NSString*) productId;

@end
