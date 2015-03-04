//
//  MyCacheProduct.h
//  MyShop
//
//  Created by SilverStar on 7/30/14.
//  Copyright (c) 2014 SilverStar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    STATUS_NONE = 0,
    STATUS_LOADING,
    STATUS_DONE,
} STATUS;

@interface MyCacheProduct : NSObject

+ (MyCacheProduct *)sharedInstance;

- (STATUS) getStatus:(NSString*) urlIndex;
- (NSDictionary*) getData:(NSString*) urlIndex;
- (void) loadData:(NSString*) url completed:(void(^)(void))completed failed:(void(^)(void))failed;

@property (nonatomic, strong) NSMutableDictionary * cashProducts;


@end
