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
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(userManager:failedToAuthenticateUserWithUsername:)]) {
                    [self.delegate userManager:self failedToAuthenticateUserWithUsername:username];
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



@end
