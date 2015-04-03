//
//  FriendManagaer.h
//  Wireframe
//
//  Created by Leo on 03/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "BaseManager.h"
#import "User.h"

@interface FriendManager : BaseManager

- (void)fetchFriendsOfUser:(User*)user;

@end

@protocol FriendFetcherDelegate <NSObject>

- (void)friendManager:(FriendManager*)manager successfullyFetchedFriends:(NSArray*)friends ofUser:(User*)user;
- (void)friendManager:(FriendManager *)manager failedToFetchFriendsOfUser:(User*)user withError:(NSError*)error;

@end