//
//  StoryManager.h
//  Wireframe
//
//  Created by Leo on 18/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Story.h"

@interface StoryManager : NSObject

- (void)createStoryWithName:(NSString*)name tag:(NSString*)tag medias:(NSArray*)medias audiosFiles:(NSArray*)audioFiles sucess:(void(^)())success failure:(void(^)())failure;

@end

@protocol StoryCreatorDelegate <NSObject>

- (void)storyManager:(StoryManager*)manager successfullyCreatedStory:(Story*)story;
- (void)storyManager:(StoryManager *)manager failedToCreateStory:(NSError*)error;

@end

@protocol StoryFetcherDelegate <NSObject>

- (void)storyManager:(StoryManager*)manager successfullyFetchedStory:(Story *)story;
- (void)storyManager:(StoryManager *)manager failedToFetchStoryWithId:(NSString*)id;

@end