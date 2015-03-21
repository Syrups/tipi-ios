//
//  RoomManager.h
//  Wireframe
//
//  Created by Leo on 19/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "BaseManager.h"
#import "Room.h"

@interface RoomManager : BaseManager

- (void)createRoomWithName:(NSString*)name andUsers:(NSArray*)users;
- (void)fetchRoomWithId:(NSUInteger)roomId;
- (void)fetchRoomsForUser:(User*)user;

@end

@protocol RoomCreatorDelegate <NSObject>

- (void)roomManager:(RoomManager*)manager successfullyCreatedRoom:(Room*)room;
- (void)roomManager:(RoomManager *)manager failedToCreateRoom:(NSError*)error;

@end

@protocol RoomFetcherDelegate <NSObject>

- (void)roomManager:(RoomManager*)manager successfullyFetchedRooms:(NSArray*)rooms;
- (void)roomManager:(RoomManager*)manager successfullyFetchedRoom:(Room*)room;
- (void)roomManager:(RoomManager *)manager failedToFetchRoomWithId:(NSUInteger)roomId;
- (void)roomManagerFailedToFetchRooms:(RoomManager *)manager;

@end