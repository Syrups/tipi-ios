//
//  UserSession.h
//  Wireframe
//
//  Created by Leo on 19/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserSession : NSObject

@property (assign, nonatomic) NSString* id;
@property (strong, nonatomic) NSString* token;
@property (strong, nonatomic) NSURL* avatarUrl;
@property (assign, nonatomic) BOOL hasPendingFriendRequests;

+ (UserSession*)sharedSession;

- (User*)user;
- (void)load;
- (BOOL) isAuthenticated;
- (void) destroy;
- (void) storeUser:(User*)user;

@end
