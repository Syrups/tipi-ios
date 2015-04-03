//
//  BaseModelController.m
//  Wireframe
//
//  Created by Leo on 02/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "BaseModelController.h"
#import "UserSession.h"
#import "Configuration.h"

@implementation BaseModelController

+ (NSURLRequest *)getBaseRequestFor:(NSString *)path authenticated:(BOOL)authenticated method:(NSString *)method {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kApiRootUrl, path] ] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:4];
    
    [request setHTTPMethod:method];
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    [mutableRequest addValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    
    NSString* token = [[UserSession sharedSession] token];
    
    if (authenticated) {
        [mutableRequest addValue:token forHTTPHeaderField:@"X-Authorization-Token"];
    }
    
    request = [mutableRequest copy];
    
    return request;
}

@end
