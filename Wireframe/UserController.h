//
//  UserController.h
//  Wireframe
//
//  Created by Leo on 02/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "BaseModelController.h"

@interface UserController : BaseModelController

- (void)createUserWithUsername:(NSString*)username password:(NSString*)password email:(NSString*)email success:(void(^)(User* user))success failure:(void(^)(NSError* error, NSUInteger statusCode))failure;
- (void)authenticateUserWithUsername:(NSString*)username password:(NSString*)password success:(void(^)(User* user))success failure:(void(^)(NSError* error))failure;
- (void)fetchUserWithId:(NSInteger)userId success:(void(^)(User* user))success failure:(void(^)(NSError* error))failure;

@end
