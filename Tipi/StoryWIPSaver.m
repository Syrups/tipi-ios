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
    
    NSDictionary* dataDic = [NSDictionary dictionaryWithObjects:@[self.uuid, [NSNumber numberWithInteger:self.medias.count]] forKeys:@[@"uuid", @"count"]];
    [dataDic writeToFile:[self pathForStorySaveFile] atomically:YES];
    
    self.saved = YES;
    
}

- (void)loadSavedStory {
    NSDictionary* dataDic = [NSDictionary dictionaryWithContentsOfFile:[self pathForStorySaveFile]];
    
    if (dataDic != nil) {
        self.uuid = [dataDic objectForKey:@"uuid"];
    }
}

- (void)discard {
    
    // erase all medias
    [self.medias enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSError* err = nil;
        [[NSFileManager defaultManager] removeItemAtPath:[self pathForAudioFileAtIndex:idx] error:&err];
        
        if (err) { NSLog(@"%@", err); }
        
        if (idx == self.medias.count-1) {
            self.medias = [NSMutableArray array];
            self.uuid = nil;
            self.saved = NO;
        }
    }];
}

- (void)appendBlankMediaAfterIndex:(NSUInteger)index {
    
    NSMutableDictionary* media = @{
        @"audio_only": [NSNumber numberWithBool:YES]
    }.mutableCopy;
    
    // insert object after media
    
    NSMutableArray* newArray = [NSMutableArray array];
    
    [self.medias enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL *stop) {
        if (idx <= index) {
            [newArray addObject:obj];
        } else if (idx == index+1) {
            [newArray addObject:media];
            [newArray addObject:obj];
        } else {
            [newArray addObject:obj];
        }
    }];
    
    self.medias = newArray;
}

- (NSString *)generateUuid {
    // Returns a UUID
    
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    
    return uuidString;
}

#pragma mark - Helper

- (NSString*)pathForAudioFileAtIndex:(NSUInteger)index {
    
    NSString* filename = [NSString stringWithFormat:@"%@_%ld.m4a", self.uuid, (long)index];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
#ifdef IPHONE_SIMULATOR
    basePath = @"/Users/leo/Desktop";
#endif
    
    return [NSString stringWithFormat:@"%@/%@", basePath, filename];
}

- (NSString*)pathForStorySaveFile {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;

    return [NSString stringWithFormat:@"%@/%@", basePath, @"current_story"];
}

@end
