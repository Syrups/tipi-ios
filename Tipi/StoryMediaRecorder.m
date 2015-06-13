//
//  StoryMediaRecorder.m
//  Wireframe
//
//  Created by Leo on 17/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "StoryMediaRecorder.h"
#import "StoryWIPSaver.h"
#import "AudioManager.h"

@implementation StoryMediaRecorder

- (id)initWithStoryUUID:(NSString *)uuid {
    self = [super init];
    
    self.storyUuid = uuid;
    
    self.microphone = [EZMicrophone microphoneWithDelegate:self];
    
    [AudioManager configureAudioSession];
    
    return self;
}

- (void)setupForMediaWithIndex:(NSInteger)pageIndex {
    
    self.currentPageIndex = pageIndex;
    
}

// Swap audio files when indexes of medias swaps together
- (void)moveAudioFileWithIndex:(NSUInteger)fromIndex atIndex:(NSUInteger)atIndex {
    NSFileManager* manager = [NSFileManager defaultManager];
    [manager moveItemAtPath:[self pathForAudioFileWithIndex:fromIndex] toPath:[self pathForAudioFileWithIndex:999] error:nil];
    
    if (atIndex > fromIndex) {
        for (NSUInteger i = fromIndex ; i < atIndex ; i++) {
            NSString* oldPath = [self pathForAudioFileWithIndex:i+1];
            NSString* newPath = [self pathForAudioFileWithIndex:i];
            [manager moveItemAtPath:oldPath toPath:newPath error:nil];
        }
        
    } else {
        for (NSUInteger i = atIndex ; i < fromIndex ; i++) {
            NSString* oldPath = [self pathForAudioFileWithIndex:i];
            NSString* newPath = [self pathForAudioFileWithIndex:i+1];
            [manager moveItemAtPath:oldPath toPath:newPath error:nil];
        }
    }
    
    [manager moveItemAtPath:[self pathForAudioFileWithIndex:999] toPath:[self pathForAudioFileWithIndex:atIndex] error:nil];
}

- (void)startRecording {
    // Creates a temporary file with filename <STORY_UUID>_<PAGE_INDEX>.m4a
    // to hold audio data
    NSString* path = [self pathForAudioFile];
    self.recorder = [EZRecorder recorderWithDestinationURL:[NSURL URLWithString:path] sourceFormat:self.microphone.audioStreamBasicDescription destinationFileType:EZRecorderFileTypeM4A];
    [self.microphone startFetchingAudio];
    self.recording = YES;
}

- (void)stopRecording {
    [self.microphone stopFetchingAudio];
    [self.recorder closeAudioFile];
    self.recording = NO;
}

- (void)playAudio {
    NSError* err = nil;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:[self pathForAudioFile]] error:&err];
    self.player.delegate = self;
    self.player.volume = 1;
    
    if (err) {
        NSLog(@"%@", err);
    }
    
    [self.player play];
}

- (NSString*)pathForAudioFile {
    
    NSString* filename = [NSString stringWithFormat:@"%@_%ld.m4a", self.storyUuid, (long)self.currentPageIndex];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    #ifdef IPHONE_SIMULATOR
        basePath = @"/Users/leo/Desktop";
    #endif
    
    return [NSString stringWithFormat:@"%@/%@", basePath, filename];
}

- (NSString*)pathForAudioFileWithIndex:(NSUInteger)index {
    
    NSString* filename = [NSString stringWithFormat:@"%@_%ld.m4a", self.storyUuid, (long)index];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
#ifdef IPHONE_SIMULATOR
    basePath = @"/Users/leo/Desktop";
#endif
    
    return [NSString stringWithFormat:@"%@/%@", basePath, filename];
}

- (NSData *)dataOfAudioWithIndex:(NSUInteger)index {
    NSString* filename = [NSString stringWithFormat:@"%@_%ld.m4a", self.storyUuid, (long)index];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    #ifdef IPHONE_SIMULATOR
        basePath = @"/Users/leo/Desktop";
    #endif
    
    return [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", basePath, filename]];
}

- (BOOL)hasRecordedAtIndex:(NSUInteger)index {
    return [self dataOfAudioWithIndex:index] != nil;
}

- (BOOL)isComplete {
    NSUInteger count = [[StoryWIPSaver sharedSaver].medias count];
    for (int i = 0 ; i < count; ++i) {
        if (![self hasRecordedAtIndex:i]) {
            return false;
        }
    }
    
    return true;
}

- (BOOL)isEmpty {
    NSUInteger count = [[StoryWIPSaver sharedSaver].medias count];
    for (int i = 0 ; i < count; ++i) {
        if ([self hasRecordedAtIndex:i]) {
            return false;
        }
    }
    
    return true;
}

- (void)configureAudioSession {
    AVAudioSession* session = [AVAudioSession sharedInstance];
    
    BOOL success;
    NSError *err;
    
    success = [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&err];
    
    if (!success) {
        NSLog(@"%@", err);
    }
    
    success = [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&err];
    
    if (!success) {
        NSLog(@"%@", err);
    }
    
    success = [session setActive:YES error:&err];
    
    if (!success) {
        NSLog(@"%@", err);
    }
}

#pragma mark - EZMicrophone

- (void)microphone:(EZMicrophone *)microphone hasBufferList:(AudioBufferList *)bufferList withBufferSize:(UInt32)bufferSize withNumberOfChannels:(UInt32)numberOfChannels {
    // Getting audio data as a buffer list that can be directly fed into the EZRecorder. This is happening on the audio thread - any UI updating needs a GCD main queue block.
    if (self.recording) {
        [self.recorder appendDataFromBufferList:bufferList
                                 withBufferSize:bufferSize];
    }
    
}

- (void)microphone:(EZMicrophone *)microphone hasAudioReceived:(float **)buffer withBufferSize:(UInt32)bufferSize withNumberOfChannels:(UInt32)numberOfChannels {
    if ([self.delegate respondsToSelector:@selector(mediaRecorder:hasAudioReceived:withBufferSize:withNumberOfChannels:)]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self.delegate mediaRecorder:self hasAudioReceived:buffer withBufferSize:bufferSize withNumberOfChannels:numberOfChannels];
        });
    }
}

#pragma mark - AVAudioPlayer

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag == YES) {
        if ([self.delegate respondsToSelector:@selector(mediaRecorder:didFinishPlayingAudioAtIndex:)]) {
            [self.delegate mediaRecorder:self didFinishPlayingAudioAtIndex:self.currentPageIndex];
        }
    }
}

@end
