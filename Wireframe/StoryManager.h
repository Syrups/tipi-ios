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

@interface StoryManager : BaseManager

- (void)createStoryWithName:(NSString*)name owner:(User*)owner inRooms:(NSArray*)rooms tag:(NSString*)tag medias:(NSArray*)medias audiosFiles:(NSArray*)audioFiles;

@end

@protocol StoryCreatorDelegate <NSObject>

- (void)storyManager:(StoryManager*)manager successfullyCreatedStory:(Story*)story withPages:(NSArray*)pages;
- (void)storyManager:(StoryManager *)manager failedToCreateStory:(NSError*)error;

@end

@protocol StoryFetcherDelegate <NSObject>

- (void)storyManager:(StoryManager*)manager successfullyFetchedStory:(Story *)story;
- (void)storyManager:(StoryManager *)manager failedToFetchStoryWithId:(NSString*)id;

@end