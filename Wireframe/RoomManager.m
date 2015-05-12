//
//  RoomManager.m
//  Wireframe
//
//  Created by Leo on 19/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "RoomManager.h"
#import "BaseModelController.h"
#import <AFNetworking/AFNetworking.h>
#import "AppDelegate.h"

@implementation RoomManager

- (void)createRoomWithName:(NSString *)name andUsers:(NSArray *)users {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [delegate.roomController createRoomWithName:name andUsers:users success:^(Room *room) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(roomManager:successfullyCreatedRoom:)]) {
                    [self.delegate roomManager:self successfullyCreatedRoom:room];
                }
            });
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(roomManager:failedToCreateRoom:)]) {
                    [self.delegate roomManager:self failedToCreateRoom:error];
                }
            });
        }];
    });
}

- (void)fetchRoomsForUser:(User *)user {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [delegate.roomController fetchRoomsForUser:user success:^(NSArray *rooms) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(roomManager:successfullyFetchedRooms:)]) {
                    [self.delegate roomManager:self successfullyFetchedRooms:rooms];
                }
            });
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(roomManager:failedToFetchRooms:)]) {
                    [self.delegate roomManager:self failedToFetchRooms:error];
                }
            });
        }];
    });
}

- (void)fetchRoomWithId:(NSUInteger)roomId {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [delegate.roomController fetchRoomWithId:roomId success:^(Room *room) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(roomManager:successfullyFetchedRoom:)]) {
                    [self.delegate roomManager:self successfullyFetchedRoom:room];
                }
            });
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(roomManager:failedToFetchRoomWithId:)]) {
                    [self.delegate roomManager:self failedToFetchRoomWithId:roomId];
                }
            });
        }];
    });
}

- (void)updateRoom:(Room *)room {
    // TODO
}

- (void)deleteRoom:(Room *)room {
    // TODO
}

@end
