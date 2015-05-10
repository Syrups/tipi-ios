//
//  StoryController.h
//  Wireframe
//
//  Created by Leo on 02/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModelController.h"
#import "User.h"
#import "Room.h"
#import "Story.h"
#import "Comment.h"

@interface StoryController : BaseModelController

- (void)createStoryWithName:(NSString*)name owner:(User*)owner inRooms:(NSArray*)rooms tag:(NSString*)tag medias:(NSArray*)medias audiosFiles:(NSArray*)audioFiles success:(void(^)(Story* story, NSArray* pages))success failure:(void(^)(NSError* error))failure;
- (void)deleteStory:(Story*)story inRoom:(Room*)room success:(void(^)(Room* room))success failure:(void(^)(NSError* error))failure;

- (void)fetchStoriesForRoomId:(NSUInteger )room filteredByTag:(NSString*)tag orUser:(User*)user success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure;
- (void)fetchStoryWithId:(NSUInteger)roomId success:(void (^)(Story *))success failure:(void (^)(NSError *))failure;
- (void)addCommentOnPage:(Page*)page atTime:(NSUInteger)time withAudioFile:(NSString*)audioFile success:(void (^)(Comment *))success failure:(void (^)(NSError *))failure;;

@end
