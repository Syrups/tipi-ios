//
//  RoomController.h
//  Wireframe
//
//  Created by Leo on 03/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "BaseModelController.h"
#import "Room.h"

@interface RoomController : BaseModelController

- (void)createRoomWithName:(NSString*)name andUsers:(NSArray*)users success:(void(^)(Room* room))success failure:(void(^)(NSError* error))failure;
- (void)fetchRoomWithId:(NSUInteger)roomId success:(void(^)(Room* room))success failure:(void(^)(NSError* error))failure;
- (void)fetchRoomsForUser:(User*)user success:(void(^)(NSArray* rooms))success failure:(void(^)(NSError* error))failure;
- (void)updateRoom:(Room*)room success:(void(^)(Room* room))success failure:(void(^)(NSError* error))failure;

@end
