//
//  MyCacheProduct.m
//  MyShop
//
//  Created by SilverStar on 7/30/14.
//  Copyright (c) 2014 SilverStar. All rights reserved.
//

#import "MyCacheProduct.h"

#import "XMLReader.h"
#import "ASIHTTPRequest.h"


@implementation MyCacheProduct

static MyCacheProduct *_sharedInstance = nil;

+ (MyCacheProduct *)sharedInstance {
    @synchronized(self) {
        if (!_sharedInstance) {
            _sharedInstance = [[MyCacheProduct alloc] init];
            
            _sharedInstance.cashProducts = [[NSMutableDictionary alloc] init];
        }
    }
    return _sharedInstance;
}
- (id)init {
    
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (STATUS) getStatus:(NSString*) urlIndex
{
    NSString * strStatus = [self.cashProducts objectForKey:[NSString stringWithFormat:@"status_%@", urlIndex]];
    
    if (strStatus == nil) {
        return STATUS_NONE;
    }
    if ([strStatus isEqualToString:@"DONE"]) {
        return STATUS_DONE;
    }
    else if ([strStatus isEqualToString:@"LOADING"]) {
        return STATUS_LOADING;
    }
    
    return STATUS_NONE;
}

- (NSDictionary*) getData:(NSString*) urlIndex
{
    NSDictionary * product = [self.cashProducts objectForKey:[NSString stringWithFormat:@"product_%@", urlIndex]];
    
    return product;
}

- (void) loadData:(NSString*) url completed:(void(^)(void))completed failed:(void(^)(void))failed
{
    
    [self.cashProducts setObject:@"LOADING" forKey:[NSString stringWithFormat:@"status_%@", url]];
    
    __weak ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"GET"];
    [request setCompletionBlock:^ {
        NSString * responseString = [request responseString];
        
        NSError * error = nil;
        NSDictionary * result = [XMLReader dictionaryForXMLString:responseString error:&error];
        if (error != nil) {
            NSLog(@"Error = %@", error);
            return;
        }
        
        NSLog(@"result = %@", result);
        
        
        [self.cashProducts setObject:@"DONE" forKey:[NSString stringWithFormat:@"status_%@", url]];
        [self.cashProducts setObject:result[@"prestashop"][@"product"] forKey:[NSString stringWithFormat:@"product_%@", url]];
        
        if (result != nil) {
            completed();
        }
    }];
    [request setFailedBlock:^{
        failed();
    }];
    
    [request startAsynchronous];
}

@end
