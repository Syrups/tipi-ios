//
//  FriendManagaer.m
//  Wireframe
//
//  Created by Leo on 03/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "FriendManager.h"
#import "AppDelegate.h"

@implementation FriendManager

- (void)fetchFriendsOfUser:(User *)user {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [delegate.userController fetchFriendsOfUser:user success:^(NSArray *friends) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(friendManager:successfullyFetchedFriends:ofUser:)]) {
                    [self.delegate friendManager:self successfullyFetchedFriends:friends ofUser:user];
                }
            });
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(friendManager:failedToFetchFriendsOfUser:withError:)]) {
                    [self.delegate friendManager:self failedToFetchFriendsOfUser:user withError:error];
                }
            });
        }];
    });
}

- (void)addFriend:(User *)friend {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [delegate.userController addFriend:friend success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(friendManager:successfullyAddedFriend:)]) {
                    [self.delegate friendManager:self successfullyAddedFriend:friend];
                }
            });
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(friendManager:failedToAddFriendWithError:)]) {
                    [self.delegate friendManager:self failedToAddFriendWithError:error];
                }
            });
        }];
    });
}

@end
