//
//  UserManager.m
//  Wireframe
//
//  Created by Leo on 18/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "UserManager.h"
#import <AFNetworking/AFNetworking.h>
#import "AppDelegate.h"

@implementation UserManager

- (void)createUserWithUsername:(NSString *)username password:(NSString *)password email:(NSString *)email {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [delegate.userController createUserWithUsername:username password:password email:email success:^(User *user) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(userManager:successfullyCreatedUser:)]) {
                    [self.delegate userManager:self successfullyCreatedUser:user];
                }
            });
        } failure:^(NSError *error, NSUInteger statusCode) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(userManager:failedToCreateUserWithStatusCode:)]) {
                    [self.delegate userManager:self failedToCreateUserWithStatusCode:statusCode];
                }
            });
        }];
    });
}

- (void)authenticateUserWithUsername:(NSString *)username password:(NSString *)password {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [delegate.userController authenticateUserWithUsername:username password:password success:^(User *user) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(userManager:successfullyAuthenticatedUser:)]) {
                    [self.delegate userManager:self successfullyAuthenticatedUser:user];
                }
            });
        } failure:^(NSError *error, NSUInteger code) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(userManager:failedToAuthenticateUserWithUsername:withStatusCode:)]) {
                    [self.delegate userManager:self failedToAuthenticateUserWithUsername:username withStatusCode:code];
                }
            });
        }];
    });
}

- (void)fetchUserWithId:(NSInteger)userId {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [delegate.userController fetchUserWithId:userId success:^(User *user) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(userManager:successfullyFetchedUser:)]) {
                    [self.delegate userManager:self successfullyFetchedUser:user];
                }
            });
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(userManager:failedToFetchUserWithId:)]) {
                    [self.delegate userManager:self failedToFetchUserWithId:userId];
                }
            });
        }];
    });
}

- (void)fetchLatestTags {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [delegate.userController getLatestTagsWithSuccess:^(NSArray *tags) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(userManager:successfullyFetchedTags:)]) {
                    [self.delegate userManager:self successfullyFetchedTags:tags];
                }
            });
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(userManager:failedToFetchTagsWithError:)]) {
                    [self.delegate userManager:self failedToFetchTagsWithError:error];
                }
            });
        }];
    });
}

- (void)findUsersWithQuery:(NSString *)query {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [delegate.userController findUsersWithQuery:query success:^(NSArray *results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(userManager:successfullyFindUsers:)]) {
                    [self.delegate userManager:self successfullyFindUsers:results];
                }
            });
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(userManager:failedToFindUsersWithError:)]) {
                    [self.delegate userManager:self failedToFindUsersWithError:error];
                }
            });
        }];
    });
}

- (void)fetchRoomInvitationsOfUser:(User *)user {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [delegate.userController fetchRoomInvitationsOfUser:user success:^(NSArray *invitations) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(userManager:successfullyFetchedInvitations:)]) {
                    [self.delegate userManager:self successfullyFetchedInvitations:invitations];
                }
            });
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(userManager:failedToFetchInvitationsWithError:)]) {
                    [self.delegate userManager:self failedToFetchInvitationsWithError:error];
                }
            });
        }];
    });
}

- (void)deleteUser:(User *)user {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [delegate.userController deleteUser:user success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(userManagerSuccessfullyDeletedUser:)]) {
                    [self.delegate userManagerSuccessfullyDeletedUser:self];
                }
            });
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(userManagerFailedToDeleteUserWithError:)]) {
                    [self.delegate userManagerFailedToDeleteUserWithError:error];
                }
            });
        }];
    });
}

@end
