//
//  StoryCache.h
//  Tipi
//
//  Created by Leo on 11/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Story.h"

@interface StoryCache : NSObject

+ (void)cacheStory:(Story*)story;
+ (void)fetchCachedStoryForId:(NSString*)storyId withSuccess:(void(^)(Story* story))success failure:(void(^)())failure;

@end
