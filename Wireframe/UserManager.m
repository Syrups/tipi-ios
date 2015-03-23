//
//  UserManager.m
//  Wireframe
//
//  Created by Leo on 18/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "UserManager.h"
#import "Api.h"
#import <AFNetworking/AFNetworking.h>

@implementation UserManager

- (void)createUserWithUsername:(NSString *)username password:(NSString *)password email:(NSString *)email {
    NSMutableURLRequest* request = [Api getBaseRequestFor:@"/users" authenticated:NO method:@"POST"].mutableCopy;
    
    NSString* deviceToken = @"";
    
    [request setHTTPBody:[[NSString stringWithFormat:@"{ \"username\": \"%@\", \"password\": \"%@\", \"email\" : \"%@\", \"device_type\" : \"ios\", \"device_token\": \"%@\" }", username, password, email, deviceToken] dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.delegate) {
            
            NSError* err = nil;
            User* user = [[User alloc] initWithDictionary:(NSDictionary*)responseObject error:&err];
            
            if (err) { NSLog(@"%@", err); }
            
            [self.delegate userManager:self successfullyCreatedUser:user];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        if (self.delegate) {
            [self.delegate userManager:self failedToCreateUserWithStatusCode:operation.response.statusCode];
        }
    }];
    
    [op start];
}

- (void)authenticateUserWithUsername:(NSString *)username password:(NSString *)password {
    
    NSMutableURLRequest* request = [Api getBaseRequestFor:@"/authenticate" authenticated:NO method:@"POST"].mutableCopy;
    [request setHTTPBody:[[NSString stringWithFormat:@"{ \"username\": \"%@\", \"password\": \"%@\" }", username, password] dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.delegate) {
            
            NSError* err = nil;
            User* user = [[User alloc] initWithDictionary:(NSDictionary*)responseObject error:&err];
            
            if (err) { NSLog(@"%@", err); }
            
            [self.delegate userManager:self successfullyAuthenticatedUser:user];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        if (self.delegate) {
            [self.delegate userManager:self failedToAuthenticateUserWithUsername:username];
        }
    }];
    
    [op start];
}

- (void)fetchUserWithId:(NSInteger)userId {
    NSString* path = [NSString stringWithFormat:@"/users/%ld", userId];
    NSURLRequest* request = [Api getBaseRequestFor:path authenticated:NO method:@"POST"];
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.delegate) {
            
            NSError* err = nil;
            User* user = [[User alloc] initWithDictionary:(NSDictionary*)responseObject error:&err];
            
            if (err) { NSLog(@"%@", err); }
            
            [self.delegate userManager:self successfullyFetchedUser:user];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        if (self.delegate) {
            [self.delegate userManager:self failedToFetchUserWithId:userId];
        }
    }];
    
    [op start];
}

@end
