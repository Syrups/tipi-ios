//
//  StoryManager.m
//  Wireframe
//
//  Created by Leo on 18/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "StoryManager.h"
#import "Room.h"
#import <AFNetworking/AFNetworking.h>
#import "AppDelegate.h"

@implementation StoryManager

-(void)createStoryWithName:(NSString *)name owner:(User *)owner inRooms:(NSArray *)rooms tag:(NSString *)tag medias:(NSArray *)medias audiosFiles:(NSArray *)audioFiles {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [delegate.storyController createStoryWithName:name owner:owner inRooms:rooms tag:tag medias:medias audiosFiles:audioFiles success:^(Story *story, NSArray* pages) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(storyManager:successfullyCreatedStory:withPages:)]) {
                    [self.delegate storyManager:self successfullyCreatedStory:story withPages:pages];
                }
            });
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(storyManager:failedToCreateStory:)]) {
                    [self.delegate storyManager:self failedToCreateStory:error];
                }
            });
        }];

    });
}

- (void)fetchStoriesForRoomId:(NSUInteger )room {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [delegate.storyController fetchStoriesForRoomId:room success:^(NSArray * stories) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([self.delegate respondsToSelector:@selector(storyManager:successfullyFetchedStories:)]) {
                    [self.delegate storyManager:self successfullyFetchedStories:stories];
                }
            });
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(storyManager:failedToFetchStories:)]) {
                    [self.delegate storyManager:self failedToFetchStories:error];
                }
            });
        }];
    });
}

- (void)fetchStoryWithId:(NSUInteger)roomId {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [delegate.storyController fetchStoryWithId:roomId success:^(Story * story) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([self.delegate respondsToSelector:@selector(storyManager:successfullyFetchedStory:)]) {
                    [self.delegate storyManager:self successfullyFetchedStory:story];
                }
            });
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(storyManager:failedToFetchStoryWithId:)]) {
                    [self.delegate storyManager:self failedToFetchStoryWithId:roomId];
                }
            });
        }];
    });
}


#pragma mark - Helpers

- (NSString*)jsonArrayForRooms:(NSArray*)rooms {
    NSMutableString* json = [NSMutableString  stringWithString:@"[ "];
    
    NSUInteger i = 0;
    
    for (Room* room in rooms) {
        [json appendString:[NSString stringWithFormat:@"\"%@\"", room.id]];
        
        if (i < rooms.count-1) {
            [json appendString:@", "];
        }
        
        i++;
    }
    
    return [json stringByAppendingString:@" ]"];
}

@end
