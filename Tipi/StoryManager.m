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

- (void)fetchStoriesForRoomId:(NSUInteger )room filteredByTag:(NSString *)tag orUser:(User *)user {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [delegate.storyController fetchStoriesForRoomId:room filteredByTag:tag orUser:user success:^(NSArray * stories) {
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

- (void)deleteStory:(Story *)story inRoom:(Room *)room {
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.storyController deleteStory:story inRoom:room success:^(Room *room) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(storyManager:successfullyDeletedStoryInRoom:)]) {
                [self.delegate storyManager:self successfullyDeletedStoryInRoom:room];
            }
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(storyManager:failedToDeleteStory:inRoom:withError:)]) {
                [self.delegate storyManager:self failedToDeleteStory:story inRoom:room withError:error];
            }
        });
    }];
}


- (void)addCommentOnPage:(Page *)page atTime:(NSUInteger)time withAudioFile:(NSString *)audioFile{
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    [delegate.storyController addCommentOnPage:page atTime:time withAudioFile:audioFile success:^(Comment *comment) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(storyManager:successfullyCreatedComment:)]) {
                [self.delegate storyManager:self successfullyCreatedComment:comment];
            }
        });
    } failure:^() {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(storyManagerFailedToCreateComment:)]) {
                [self.delegate storyManagerFailedToCreateComment:self];
            }
        });
    }];
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
