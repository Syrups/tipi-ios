//
//  UserController.m
//  Wireframe
//
//  Created by Leo on 02/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "UserController.h"
#import "UserSession.h"
#import <AFNetworking/AFNetworking.h>

@implementation UserController

- (void)createUserWithUsername:(NSString *)username password:(NSString *)password email:(NSString *)email success:(void (^)(User *))success failure:(void (^)(NSError *, NSUInteger))failure {
    NSMutableURLRequest* request = [UserController getBaseRequestFor:@"/users" authenticated:NO method:@"POST"].mutableCopy;
    
    NSData* deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"device_token"];
    
    [request setHTTPBody:[[NSString stringWithFormat:@"{ \"username\": \"%@\", \"password\": \"%@\", \"email\" : \"%@\", \"device_type\" : \"ios\", \"device_token\": \"%@\" }", username, password, email, deviceToken] dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSError* err = nil;
        User* user = [[User alloc] initWithDictionary:(NSDictionary*)responseObject error:&err];
        
        if (err) { NSLog(@"%@", err); }
            
        success(user);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
        if (failure != nil) failure(error, operation.response.statusCode);
    }];
    
    [op start];
}

- (void)authenticateUserWithUsername:(NSString *)username password:(NSString *)password success:(void (^)(User *))success failure:(void (^)(NSError *))failure {
    
    NSMutableURLRequest* request = [UserController getBaseRequestFor:@"/authenticate" authenticated:NO method:@"POST"].mutableCopy;
    [request setHTTPBody:[[NSString stringWithFormat:@"{ \"username\": \"%@\", \"password\": \"%@\" }", username, password] dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* err = nil;
        User* user = [[User alloc] initWithDictionary:(NSDictionary*)responseObject error:&err];
        
        if (err) { NSLog(@"%@", err); }
        
        success(user);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        if (failure != nil) failure(error);
    }];
    
    [op start];
}

- (void)fetchUserWithId:(NSInteger)userId success:(void (^)(User *))success failure:(void (^)(NSError *))failure {
    NSString* path = [NSString stringWithFormat:@"/users/%ld", (long)userId];
    NSURLRequest* request = [UserController getBaseRequestFor:path authenticated:YES method:@"GET"];
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* err = nil;
        User* user = [[User alloc] initWithDictionary:(NSDictionary*)responseObject error:&err];
        
        if (err) { NSLog(@"%@", err); }
        
        success(user);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        if (failure != nil) failure(error);
    }];
    
    [op start];
}

- (void)fetchFriendsOfUser:(User *)user success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    NSString* path = [NSString stringWithFormat:@"/users/%@/friends", user.id];
    NSURLRequest* request = [UserController getBaseRequestFor:path authenticated:YES method:@"GET"];
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* err = nil;
        NSArray* friends = [User arrayOfModelsFromDictionaries:responseObject error:&err];
        
        if (err) { NSLog(@"%@", err); }
        
        success(friends);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        if (failure != nil) failure(error);
    }];
    
    [op start];
}

- (void)addFriend:(User *)user success:(void (^)())success failure:(void (^)(NSError *))failure {
    NSString* path = [NSString stringWithFormat:@"/users/%@/friends", [[UserSession sharedSession].user id]];
    NSMutableURLRequest* request = [UserController getBaseRequestFor:path authenticated:YES method:@"POST"].mutableCopy;
    
    [request setHTTPBody:[[NSString stringWithFormat:@"{ \"friend_id\" : \"%@\" }", user.id] dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
 
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        if (failure != nil) failure(error);
    }];
    
    [op start];
}

- (void)getLatestTagsWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    NSString* path = [NSString stringWithFormat:@"/users/%@/tags", CurrentUser.id];
    NSURLRequest* request = [UserController getBaseRequestFor:path authenticated:YES method:@"GET"];
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* err = nil;
        NSArray* tags = responseObject;
        if (err) { NSLog(@"%@", err); }
        
        success(tags);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        if (failure != nil) failure(error);
    }];
    
    [op start];
}

- (void)findUsersWithQuery:(NSString *)query success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    NSURLRequest* request = [UserController getBaseRequestFor:[NSString stringWithFormat:@"/users/search?query=%@", query] authenticated:YES method:@"GET"];
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* err = nil;
        NSArray* results = [User arrayOfModelsFromDictionaries:responseObject];
        if (err) { NSLog(@"%@", err); }
        
        success(results);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        if (failure != nil) failure(error);
    }];
    
    [op start];
}

- (void)fetchFriendsRequestsOfUser:(User *)user success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    // TODO
}

@end
