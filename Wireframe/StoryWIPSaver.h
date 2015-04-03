//
//  StoryWIPSaver.h
//  Wireframe
//
//  Created by Leo on 04/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoryWIPSaver : NSObject

+ (StoryWIPSaver*)sharedSaver;

@property BOOL saved;
@property (strong, nonatomic) NSString* uuid;
@property (strong, nonatomic) NSMutableArray* medias;
@property (strong, nonatomic) NSString* tag;
@property (strong, nonatomic) NSString* title;

- (void)discard;
- (void)save;
- (void)loadSavedStory;

@end
