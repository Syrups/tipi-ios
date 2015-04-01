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
    
    // set a uuid if it does not have one
    if (saver.uuid == nil) {
        saver.uuid = [saver generateUuid];
    }
    
    return saver;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.medias = [NSMutableArray array];
        self.uuid = [self generateUuid];
    }
    
    return self;
}

- (void)save {
    self.saved = YES;
    
}

- (void)discard {
    self.medias = [NSMutableArray array];
    self.uuid = nil;
    self.saved = NO;
}

- (NSString *)generateUuid {
    // Returns a UUID
    
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    
    return uuidString;
}


@end
