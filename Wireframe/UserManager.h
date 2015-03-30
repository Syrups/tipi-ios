//
//  UserManager.h
//  Wireframe
//
//  Created by Leo on 18/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseManager.h"
#import "User.h"

@interface UserManager : BaseManager

- (void)createUserWithUsername:(NSString*)username password:(NSString*)password email:(NSString*)email;
- (void)authenticateUserWithUsername:(NSString*)username password:(NSString*)password;
- (void)fetchUserWithId:(NSInteger)userId;

@end

@protocol UserCreatorDelegate <NSObject>

- (void)userManager:(UserManager*)manager successfullyCreatedUser:(User*)user;
- (void)userManager:(UserManager*)manager failedToCreateUserWithStatusCode:(NSUInteger)statusCode;

@end

@protocol UserAuthenticatorDelegate <NSObject>

- (void)userManager:(UserManager*)manager successfullyAuthenticatedUser:(User*)user;
- (void)userManager:(UserManager*)manager failedToAuthenticateUserWithUsername:(NSString*)username;

@end

@protocol UserFetcherDelegate <NSObject>

- (void)userManager:(UserManager*)manager successfullyFetchedUser:(User*)user;
- (void)userManager:(UserManager*)manager failedToFetchUserWithId:(NSUInteger)userId;

@end

@protocol UserUpdaterDelegate <NSObject>

- (void)userManager:(UserManager*)manager successfullyUpdatedUser:(User*)user;
- (void)userManager:(UserManager*)manager failedToUpdateUser:(User*)user;

@end