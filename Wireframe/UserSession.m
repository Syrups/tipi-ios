//
//  UserSession.m
//  Wireframe
//
//  Created by Leo on 19/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "UserSession.h"
#import "Configuration.h"

@implementation UserSession

static UserSession* sharedSession;

+ (UserSession*)sharedSession {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedSession = [[UserSession alloc] init];
    });
    
    return sharedSession;
}

- (User *)user {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    User* u = [[User alloc] initWithString:[defaults objectForKey:kSessionStoreId] error:nil];
    
    return u;
}

- (void)load {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    self.id = [defaults objectForKey:kSessionStoreId];
    self.token = [defaults objectForKey:kSessionStoreToken];
}

- (BOOL)isAuthenticated {
    return [self user] != nil;
}

- (void)storeUser:(User *)user {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    self.token = user.token;
    [defaults setObject:[user toJSONString] forKey:kSessionStoreId];
    [defaults synchronize];
}

- (void)destroy {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kSessionStoreId];
    [defaults synchronize];
}

@end
