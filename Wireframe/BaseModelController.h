//
//  BaseModelController.h
//  Wireframe
//
//  Created by Leo on 02/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModelController : NSObject

+ (NSURLRequest *) getBaseRequestFor:(NSString *)path authenticated:(BOOL)authenticated method:(NSString*)method;

@end
