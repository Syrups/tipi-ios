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
- (void)fetchLatestTags;
- (void)findUsersWithQuery:(NSString*)query;
- (void)fetchRoomInvitationsOfUser:(User*)user;
- (void)deleteUser:(User*)user;

@end

@protocol UserCreatorDelegate <NSObject>

- (void)userManager:(UserManager*)manager successfullyCreatedUser:(User*)user;
- (void)userManager:(UserManager*)manager failedToCreateUserWithStatusCode:(NSUInteger)statusCode;

@end

@protocol UserFinderDelegate <NSObject>

- (void)userManager:(UserManager*)manager successfullyFindUsers:(NSArray*)results;
- (void)userManager:(UserManager *)manager failedToFindUsersWithError:(NSError*)error;

@end

@protocol UserAuthenticatorDelegate <NSObject>

- (void)userManager:(UserManager*)manager successfullyAuthenticatedUser:(User*)user;
- (void)userManager:(UserManager*)manager failedToAuthenticateUserWithUsername:(NSString*)username withStatusCode:(NSInteger)code;

@end

@protocol UserFetcherDelegate <NSObject>

- (void)userManager:(UserManager*)manager successfullyFetchedUser:(User*)user;
- (void)userManager:(UserManager*)manager failedToFetchUserWithId:(NSUInteger)userId;

@end

@protocol UserUpdaterDelegate <NSObject>

- (void)userManager:(UserManager*)manager successfullyUpdatedUser:(User*)user;
- (void)userManager:(UserManager*)manager failedToUpdateUser:(User*)user;

@end

@protocol UserDeleterDelegate <NSObject>

- (void)userManagerSuccessfullyDeletedUser:(UserManager*)manager;
- (void)userManagerFailedToDeleteUserWithError:(NSError*)error;

@end

@protocol TagFetcherDelegate <NSObject>

- (void)userManager:(UserManager*)manager successfullyFetchedTags:(NSArray*)tags;
- (void)userManager:(UserManager *)manager failedToFetchTagsWithError:(NSError*)error;

@end

@protocol InvitationFetcherDelegate <NSObject>

- (void)userManager:(UserManager*)manager successfullyFetchedInvitations:(NSArray*)invitations;
- (void)userManager:(UserManager*)manager failedToFetchInvitationsWithError:(NSError*)error;

@end
