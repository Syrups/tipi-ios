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
    // TODO
}

- (void)fetchRoomsForUser:(User *)user success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    
    // first use cache
    [RoomCache fetchCachedRoomsWithSuccess:^(NSArray *rooms) {
        success(rooms);
    } failure:^{
        failure(nil);
    }];
    
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

@end
