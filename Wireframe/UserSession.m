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
    User* u = [[User alloc] init];
    u.id = self.id;
    u.token = self.token;
    
    return u;
}

- (void)load {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    self.id = [defaults objectForKey:kSessionStoreId];
    self.token = [defaults objectForKey:kSessionStoreToken];
}

- (BOOL)isAuthenticated {
    return self.token != nil;
}

- (void)storeUser:(User *)user {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    self.token = user.token;
    self.id = user.id;
    [defaults setObject:user.id forKey:kSessionStoreId];
    [defaults setObject:user.token forKey:kSessionStoreToken];
    [defaults synchronize];
}

- (void)destroy {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kSessionStoreId];
    [defaults removeObjectForKey:kSessionStoreToken];
    [defaults synchronize];
}

@end
