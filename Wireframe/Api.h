//
//  Api.h
//  Wireframe
//
//  Created by Leo on 18/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Api : NSObject

+ (NSURLRequest *) getBaseRequestFor:(NSString *)path authenticated:(BOOL)authenticated method:(NSString*)method;
+ (NSURLRequest *) getBaseRequestForImageUpload;

@end
