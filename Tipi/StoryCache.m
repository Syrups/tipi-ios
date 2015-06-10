//
//  StoryCache.m
//  Tipi
//
//  Created by Leo on 11/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "StoryCache.h"

@implementation StoryCache

+ (void)cacheStory:(Story *)story {
    NSMutableDictionary* cache = [NSMutableDictionary dictionaryWithContentsOfFile:[self cacheFilePath]];
    
    if (!cache) {
        cache = [NSMutableDictionary dictionary];
    }
    
    [cache setObject:[story toDictionary] forKey:story.id];
    
    [cache writeToFile:[self cacheFilePath] atomically:YES];
}

+ (void)fetchCachedStoryForId:(NSString*)storyId withSuccess:(void (^)(Story *))success failure:(void (^)())failure {
    NSMutableDictionary* cache = [NSMutableDictionary dictionaryWithContentsOfFile:[self cacheFilePath]];
    
    if (!cache) {
        failure();
    } else {
        NSDictionary* storyDic = (NSDictionary*)[cache objectForKey:storyId];
        
        if (!storyId) {
            failure();
        } else {
            NSError* err = nil;
            Story* story = [[Story alloc] initWithDictionary:storyDic error:&err];
            
            if (err) {
                failure();
            } else {
                success(story);
            }
        }
    }
}

+ (NSString*)cacheFilePath {
    //applications Documents dirctory path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingString:@"/story_cache.json"];
}


@end
