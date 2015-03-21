//
//  RoomManager.m
//  Wireframe
//
//  Created by Leo on 19/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "RoomManager.h"
#import "Api.h"
#import <AFNetworking/AFNetworking.h>

@implementation RoomManager

- (void)fetchRoomsForUser:(User *)user {
    NSString* path = [NSString stringWithFormat:@"/users/%@/rooms", user.id];
    NSURLRequest* request = [Api getBaseRequestFor:path authenticated:YES method:@"GET"];
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.delegate) {
            
            NSError* err = nil;
            NSArray* rooms = [Room arrayOfModelsFromDictionaries:responseObject];
            
            if (err) { NSLog(@"%@", err); }
            
            [self.delegate roomManager:self successfullyFetchedRooms:rooms];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        if (self.delegate) {
            [self.delegate roomManagerFailedToFetchRooms:self];
        }
    }];
    
    [op start];
}

@end
