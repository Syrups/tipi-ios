//
//  StoryManager.m
//  Wireframe
//
//  Created by Leo on 18/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "StoryManager.h"
#import "Api.h"
#import "Room.h"
#import <AFNetworking/AFNetworking.h>

@implementation StoryManager

-(void)createStoryWithName:(NSString *)name owner:(User *)owner inRooms:(NSArray *)rooms tag:(NSString *)tag medias:(NSArray *)medias audiosFiles:(NSArray *)audioFiles {
    
    NSString* path = [NSString stringWithFormat:@"/users/%@/stories", owner.id];
    NSMutableURLRequest* request = [Api getBaseRequestFor:path authenticated:YES method:@"POST"].mutableCopy;
    
    [request setHTTPBody:[[NSString stringWithFormat:@"{ \"story\": { \"title\": \"%@\", \"page_count\": \"%ld\", \"tag\": \"%@\", \"rooms\": %@ } }", name, medias.count, tag, [self jsonArrayForRooms:rooms]] dataUsingEncoding:NSUTF8StringEncoding]];
    
                  

    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* err = nil;
        Story* story = [[Story alloc] initWithDictionary:responseObject error:&err];
        
        if (err) { NSLog(@"%@", err); }
        
        
        [self.delegate storyManager:self successfullyCreatedStory:story withPages:story.pages];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate storyManager:self failedToCreateStory:error];
    }];
    
    [op start];
}

- (void)fetchStoriesForRoomId:(NSUInteger )room {
    NSString* path = [NSString stringWithFormat:@"/rooms/%ld/stories", (long)room];
    NSURLRequest* request = [Api getBaseRequestFor:path authenticated:YES method:@"GET"];
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.delegate) {
            
            
            
            NSError* err = nil;
            NSArray* stories = [Story arrayOfModelsFromDictionaries:responseObject];
            
            if (err) { NSLog(@"%@", err); }
            
            if ([self.delegate respondsToSelector:@selector(storyManager:successfullyFetchedStories:)]) {
                [self.delegate storyManager:self successfullyFetchedStories:stories];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        if ([self.delegate respondsToSelector:@selector(storyManager:failedToFetchStories:)]) {
            [self.delegate storyManager:self failedToFetchStories:error];
        }
    }];
    
    [op start];
}

- (void)fetchStoryWithId:(NSUInteger)roomId {
    NSString* path = [NSString stringWithFormat:@"/stories/%ld", roomId];
    NSURLRequest* request = [Api getBaseRequestFor:path authenticated:YES method:@"GET"];
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.delegate) {
            
            NSLog(@"blubli %@", responseObject);
            
            NSError* err = nil;
            Story* story = [[Story alloc] initWithDictionary:responseObject error:&err];
            
            if (err) { NSLog(@"%@", err); }
            
            if ([self.delegate respondsToSelector:@selector(storyManager:successfullyFetchedStory:)]) {
                [self.delegate storyManager:self successfullyFetchedStory:story];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        if ([self.delegate respondsToSelector:@selector(storyManager:failedToFetchStoryWithId:)]) {
            [self.delegate storyManager:self failedToFetchStoryWithId:roomId];
        }
    }];
    
    [op start];
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
