//
//  RoomCache.m
//  Wireframe
//
//  Created by Leo on 27/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "RoomCache.h"
#import "Room.h"
#import "Story.h"

@implementation RoomCache

+ (void)cacheRooms:(NSArray *)rooms completion:(void (^)())completion {
    
    NSArray* roomsDic = [Room arrayOfDictionariesFromModels:rooms];
    NSData* json = [NSJSONSerialization dataWithJSONObject:roomsDic options:0 error:nil];
    [json writeToFile:[self cacheFilePath] atomically:YES];
    
    completion();
}

+ (void)fetchCachedRoomsWithSuccess:(void (^)(NSArray *))success failure:(void (^)())failure {
    NSData* json = [NSData dataWithContentsOfFile:[self cacheFilePath]];
    
    if (json == nil) {
        failure();
    } else {
        NSArray* roomsDic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableLeaves error:nil];
        NSArray* rooms = [Room arrayOfModelsFromDictionaries:roomsDic];
        
        success(rooms);
    }
}

+ (void)cacheLastStories:(NSArray *)stories forRoomId:(Room *)roomId {
    NSMutableDictionary* cache = [NSMutableDictionary dictionaryWithContentsOfFile:[self cacheFilePathForStories]];
    NSMutableArray* encodedStories = [NSMutableArray array];
    
    if (!cache) {
        cache = [NSMutableDictionary dictionary];
    }
    
    for (Story* story in stories) {
        [encodedStories addObject:[story toDictionary]];
    }
    
    [cache setObject:encodedStories forKey:roomId];
    
    [cache writeToFile:[self cacheFilePathForStories] atomically:YES];
}

+ (void)fetchCachedLastStoriesForRoomId:(Room *)roomId withSuccess:(void (^)(NSArray *))success failure:(void (^)())failure {
    NSMutableDictionary* cache = [NSMutableDictionary dictionaryWithContentsOfFile:[self cacheFilePathForStories]];
    
    if (!cache) {
        failure();
    } else {
        NSArray* encodedStories = (NSArray*)[cache objectForKey:roomId];
        NSMutableArray* stories = [NSMutableArray array];
        
        for (NSDictionary* story in encodedStories) {
            [stories addObject:[[Story alloc] initWithDictionary:story error:nil]];
        }
        
        
        if (!stories) {
            failure();
        } else {
            success(stories);
        }
    }
}

+ (NSString*)cacheFilePath {
    //applications Documents dirctory path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingString:@"/room_cache.json"];
}

+ (NSString*)cacheFilePathForStories {
    //applications Documents dirctory path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingString:@"/room_stories.json"];
}

@end
