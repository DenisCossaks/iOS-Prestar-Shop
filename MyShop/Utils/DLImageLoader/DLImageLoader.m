//
//  DLImageLoader.m
//
//  Created by Andrey Lunevich on 7/9/13.
//  Copyright (c) 2013 Andrey Lunevich. All rights reserved.
//

#import "DLImageLoader.h"
#import "DLILOperation.h"
#import "DLILCacheManager.h"
#import "DLILCache.h"

#import "ASIHTTPRequest.h"

@implementation DLImageLoader

+ (void)loadImageFromURL:(NSString *)urlString
               completed:(void (^)(NSError *, NSData *))completed {
    __block NSError *error = nil;
    __block NSData *image = nil;
    
    if (urlString == nil || urlString.length < 1) {
        return;
    }
    
    [DLILOperation newOperationWithBlock:^{
        NSURL *url = [NSURL URLWithString:urlString];
        image = [[DLILCacheManager sharedInstance] imageFromCache:urlString];
        if (image == nil && url != nil) {
            
            __weak ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:url];
            [request setRequestMethod:@"GET"];
            [request setCompletionBlock:^ {
                
                image = [request responseData];
//                image = [NSData dataWithContentsOfURL:url options:0 error:&error];
                
                [[DLILCacheManager sharedInstance] addNewImageToCache:image
                                                                  url:urlString];
                [[DLILCacheManager sharedInstance] saveCache];
 
            }];
            [request setFailedBlock:^{
            }];
            [request startAsynchronous];

        }
    } completed:^{
        completed(error, image);
    }];
}

@end
