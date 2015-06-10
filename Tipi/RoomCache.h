//
//  RoomCache.h
//  Wireframe
//
//  Created by Leo on 27/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Room.h"

@interface RoomCache : NSObject

+ (void)cacheRooms:(NSArray*)rooms completion:(void(^)())completion;
+ (void)fetchCachedRoomsWithSuccess:(void(^)(NSArray* rooms))success failure:(void(^)())failure;
+ (void)cacheLastStories:(NSArray*)stories forRoomId:(NSString*)roomId;
+ (void)fetchCachedLastStoriesForRoomId:(NSString*)roomId withSuccess:(void(^)(NSArray* stories))success failure:(void(^)())failure;
                                                    
@end
