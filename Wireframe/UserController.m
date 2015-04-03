//
//  UserController.m
//  Wireframe
//
//  Created by Leo on 02/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "UserController.h"
#import <AFNetworking/AFNetworking.h>

@implementation UserController

- (void)createUserWithUsername:(NSString *)username password:(NSString *)password email:(NSString *)email success:(void (^)(User *))success failure:(void (^)(NSError *, NSUInteger))failure {
    NSMutableURLRequest* request = [UserController getBaseRequestFor:@"/users" authenticated:NO method:@"POST"].mutableCopy;
    
    NSString* deviceToken = @"";
    
    [request setHTTPBody:[[NSString stringWithFormat:@"{ \"username\": \"%@\", \"password\": \"%@\", \"email\" : \"%@\", \"device_type\" : \"ios\", \"device_token\": \"%@\" }", username, password, email, deviceToken] dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSError* err = nil;
        User* user = [[User alloc] initWithDictionary:(NSDictionary*)responseObject error:&err];
        
        if (err) { NSLog(@"%@", err); }
            
        success(user);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
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
    NSString* path = [NSString stringWithFormat:@"/users/%ld", userId];
    NSURLRequest* request = [UserController getBaseRequestFor:path authenticated:NO method:@"POST"];
    
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

@end
