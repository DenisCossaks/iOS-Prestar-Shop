//
//  MyUrl.m
//  MyShop
//
//  Created by SilverStar on 7/25/14.
//  Copyright (c) 2014 SilverStar. All rights reserved.
//

#import "MyUrl.h"

@implementation MyUrl

+(NSString*) getServerUrl
{
    NSString *urlString = [[SERVER_URL stringByAppendingFormat:@"/api"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return urlString;
}

+(NSString*) getProductsList
{
    NSString *urlString = [[SERVER_URL stringByAppendingFormat:@"/api/products"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"getProductsList url : %@", urlString);
    
    NSString * result = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:nil];
    
    return result;
}
+(NSString*) getProductsDetail:(NSString*) productId
{
    NSString *urlString = [[SERVER_URL stringByAppendingFormat:@"/api/products/%@", productId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"getProductsList url : %@", urlString);
    
    NSString * result = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:nil];
    
    return result;
}

@end
