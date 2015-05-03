//
//  RoomManager.h
//  Wireframe
//
//  Created by Leo on 19/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "BaseManager.h"
#import "Room.h"
#import "StoryManager.h"

@interface RoomManager : BaseManager

- (void)createRoomWithName:(NSString*)name andUsers:(NSArray*)users;
- (void)fetchRoomWithId:(NSUInteger)roomId;
- (void)fetchRoomsForUser:(User*)user;
- (void)deleteRoom:(Room*)room;
- (void)updateRoom:(Room*)room;

@end

@protocol RoomCreatorDelegate <NSObject>

@required
- (void)roomManager:(RoomManager*)manager successfullyCreatedRoom:(Room*)room;

@required
- (void)roomManager:(RoomManager *)manager failedToCreateRoom:(NSError*)error;

@end

@protocol RoomFetcherDelegate <NSObject>

@optional
- (void)roomManager:(RoomManager*)manager successfullyFetchedRooms:(NSArray*)rooms;

@optional
- (void)roomManager:(RoomManager*)manager successfullyFetchedRoom:(Room*)room;


@optional
- (void)roomManager:(RoomManager *)manager failedToFetchRoomWithId:(NSUInteger)roomId;

@optional
- (void)roomManager:(RoomManager *)manager failedToFetchRooms:(NSError*)error;

@end

@protocol RoomDeleterDelegate <NSObject>

- (void)roomManager:(RoomManager*)manager successfullyDeletedRoom:(Room*)room;
- (void)roomManager:(RoomManager *)manager failedToDeleteRoom:(Room*)room withError:(NSError*)error;
@end

@protocol RoomUpdaterDelegate <NSObject>

- (void)roomManager:(RoomManager*)manager successfullyUpdatedRoom:(Room*)room;
- (void)roomManager:(RoomManager *)manager failedToUpdateRoom:(Room*)room withError:(NSError*)error;

@end
