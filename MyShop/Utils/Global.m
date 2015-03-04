//
//  Global.m
//  MyShop
//
//  Created by SilverStar on 7/30/14.
//  Copyright (c) 2014 SilverStar. All rights reserved.
//

#import "Global.h"

@implementation Global

static Global *_sharedInstance = nil;

+ (Global *)sharedInstance {
    @synchronized(self) {
        if (!_sharedInstance) {
            _sharedInstance = [[Global alloc] init];
            
        }
    }
    return _sharedInstance;
}

- (NSString *) correctString:(NSString*) string
{
    string = [string stringByReplacingOccurrencesOfString:@"\n\t"
                                         withString:@""];

    string = [string stringByReplacingOccurrencesOfString:@"<p>"
                                               withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"</p>"
                                               withString:@""];
    
    return string;
}

@end

