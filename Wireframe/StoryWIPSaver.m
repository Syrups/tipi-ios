//
//  StoryWIPSaver.m
//  Wireframe
//
//  Created by Leo on 04/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "StoryWIPSaver.h"

@implementation StoryWIPSaver

+ (StoryWIPSaver *)sharedSaver {
    static StoryWIPSaver* saver = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        saver = [[StoryWIPSaver alloc] init];
    });
    
    return saver;
}

@end
