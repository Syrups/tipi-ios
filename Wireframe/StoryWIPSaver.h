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

@end
