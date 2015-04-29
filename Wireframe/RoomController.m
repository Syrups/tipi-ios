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
    
    NSLog(@"%@", request.HTTPBody);
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
