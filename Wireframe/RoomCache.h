//
//  RoomCache.h
//  Wireframe
//
//  Created by Leo on 27/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoomCache : NSObject

+ (void)cacheRooms:(NSArray*)rooms completion:(void(^)())completion;
+ (void)fetchCachedRoomsWithSuccess:(void(^)(NSArray* rooms))success failure:(void(^)())failure;
                                                    
@end
