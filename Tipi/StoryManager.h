//
//  StoryManager.h
//  Wireframe
//
//  Created by Leo on 18/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseManager.h"
#import "Story.h"
#import "User.h"
#import "RoomManager.h"

@interface StoryManager : BaseManager

- (void)createStoryWithName:(NSString*)name owner:(User*)owner inRooms:(NSArray*)rooms tag:(NSString*)tag medias:(NSArray*)medias audiosFiles:(NSArray*)audioFiles;

- (void)fetchStoriesForRoomId:(NSUInteger )room filteredByTag:(NSString*)tag orUser:(User*)user;
- (void)fetchStoryWithId:(NSUInteger)roomId ;
- (void)deleteStory:(Story*)story inRoom:(Room*)room;


- (void)addCommentOnPage:(Page *)page atTime:(NSUInteger)time withAudioFile:(NSString *)audioFile;

@end

@protocol StoryCreatorDelegate <NSObject>

- (void)storyManager:(StoryManager*)manager successfullyCreatedStory:(Story*)story withPages:(NSArray*)pages;
- (void)storyManager:(StoryManager *)manager failedToCreateStory:(NSError*)error;

@end

@protocol StoryDeleterDelegate <NSObject>

- (void)storyManager:(StoryManager*)manager successfullyDeletedStoryInRoom:(Room*)room;
- (void)storyManager:(StoryManager*)manager failedToDeleteStory:(Story*)story inRoom:(Room*)room withError:(NSError*)error;
@end


@protocol StoryFetcherDelegate <NSObject>

@optional
- (void)storyManager:(StoryManager*)manager successfullyFetchedStories:(NSArray *)stories;

@optional
- (void)storyManager:(StoryManager *)manager failedToFetchStories:(NSError*)error;

@optional
- (void)storyManager:(StoryManager*)manager successfullyFetchedStory:(Story *)story;

@optional
- (void)storyManager:(StoryManager *)manager failedToFetchStoryWithId:(NSUInteger)id;

@end

@protocol CommentCreatorDelegate <NSObject>

- (void)storyManager:(StoryManager*)manager successfullyCreatedComment:(Comment*)story;
- (void)storyManagerFailedToCreateComment:(StoryManager*)manager;
@end