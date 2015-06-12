//
//  RoomController.m
//  Wireframe
//
//  Created by Leo on 03/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "RoomController.h"
#import "RoomCache.h"
#import <AFNetworking/AFNetworking.h>

@implementation RoomController

- (void)createRoomWithName:(NSString *)name andUsers:(NSArray *)users success:(void (^)(Room *))success failure:(void (^)(NSError *))failure {

    NSString* path = [NSString stringWithFormat:@"/users/%@/rooms", CurrentUser.id];
    NSMutableURLRequest* request = [RoomController getBaseRequestFor:path authenticated:YES method:@"POST"].mutableCopy;
    
    [request setHTTPBody:[[NSString stringWithFormat:@"{ \"room\" : { \"name\" : \"%@\", \"users\" : %@ } }", name, [self httpBodyForUsers:users]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError* err = nil;
        Room* room = [[Room alloc] initWithDictionary:(NSDictionary*)responseObject error:&err];
        
        if (err) { NSLog(@"%@", err); }
        
        success(room);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
        if (failure != nil) failure(error);
    }];
    
    [op start];
}

- (void)fetchRoomsForUser:(User *)user success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    
    NSString* path = [NSString stringWithFormat:@"/users/%@/rooms", user.id];
    NSURLRequest* request = [BaseModelController getBaseRequestFor:path authenticated:YES method:@"GET"];
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* err = nil;
        NSArray* rooms = [Room arrayOfModelsFromDictionaries:responseObject];
        
        if (err) { NSLog(@"%@", err); }
        
        [RoomCache cacheRooms:rooms completion:^{
            success(rooms);
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        failure(error);
        
        [RoomCache fetchCachedRoomsWithSuccess:^(NSArray *rooms) {
            success(rooms);
        } failure:^{
            
        }];

    }];
    
    [op start];
    
    
}

- (void)fetchRoomWithId:(NSUInteger)roomId success:(void (^)(Room *))success failure:(void (^)(NSError *))failure {
    NSString* path = [NSString stringWithFormat:@"/rooms/%ld", (unsigned long)roomId];
    NSURLRequest* request = [BaseModelController getBaseRequestFor:path authenticated:YES method:@"GET"];
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* err = nil;
        Room* room = [[Room alloc] initWithDictionary:responseObject error:&err];
        
        if (err) { NSLog(@"%@", err); }
        
        success(room);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        failure(error);
    }];
    
    [op start];
}

- (void)deleteRoom:(Room*)room success:(void(^)(Room* room))success failure:(void(^)(NSError* error))failure{
    NSString* path = [NSString stringWithFormat:@"/rooms/%@", room.id];
    NSURLRequest* request = [BaseModelController getBaseRequestFor:path authenticated:YES method:@"GET"];
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* err = nil;
        Room* room = [[Room alloc] initWithDictionary:responseObject error:&err];
        
        if (err) { NSLog(@"%@", err); }
        
        success(room);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        failure(error);
    }];
    
    [op start];
}

- (void)inviteUsers:(NSArray *)usersIds toRoom:(Room *)room success:(void (^)(Room *))success failure:(void (^)(NSError *))failure {
    
    NSString* path = [NSString stringWithFormat:@"/rooms/%@/invite", room.id];
    NSMutableURLRequest* request = [BaseModelController getBaseRequestFor:path authenticated:YES method:@"POST"].mutableCopy;
    
    [request setHTTPBody:[[NSString stringWithFormat:@"{ \"users\": %@ }", [self httpBodyForUsers:usersIds]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* err = nil;
        Room* room = [[Room alloc] initWithDictionary:responseObject error:&err];
        
        if (err) { NSLog(@"%@", err); }
        
        success(room);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        failure(error);
    }];
    
    [op start];
}

- (void)joinRoom:(Room *)room success:(void (^)(Room *))success failure:(void (^)(NSError *))failure {
    NSString* path = [NSString stringWithFormat:@"/rooms/%@/join", room.id];
    NSURLRequest* request = [BaseModelController getBaseRequestFor:path authenticated:YES method:@"POST"];
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* err = nil;
        Room* room = [[Room alloc] initWithDictionary:responseObject error:&err];
        
        if (err) { NSLog(@"%@", err); }
        
        success(room);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        failure(error);
    }];
    
    [op start];
}

- (void)updateRoom:(Room*)room success:(void(^)(Room* room))success failure:(void(^)(NSError* error))failure{
    NSString* path = [NSString stringWithFormat:@"/rooms/%@", room.id];
    NSMutableURLRequest* request = [RoomController getBaseRequestFor:path authenticated:YES method:@"PUT"].mutableCopy;
    
    [request setHTTPBody:[[NSString stringWithFormat:@"{ \"room\" : { \"name\" : \"%@\" } }", room.name] dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError* err = nil;
        Room* room = [[Room alloc] initWithDictionary:(NSDictionary*)responseObject error:&err];
        
        if (err) { NSLog(@"%@", err); }
        
        success(room);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
        if (failure != nil) failure(error);
    }];
    
    [op start];
}


- (NSString*)httpBodyForUsers:(NSArray*)users {
    NSMutableString *usersJson = [NSMutableString stringWithString:@"["];
    int i = 0;
    
    for (NSString* u in users) {
        [usersJson appendString:[NSString stringWithFormat:@"\"%@\"", u]];
        if (i != users.count-1) {
            [usersJson appendString:@", "];
        }
        i++;
    }
    
    [usersJson appendString:@"]"];
    
    return usersJson;
}

@end
