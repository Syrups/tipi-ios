//
//  StoryMediaRecorder.m
//  Wireframe
//
//  Created by Leo on 17/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "StoryMediaRecorder.h"

@implementation StoryMediaRecorder

- (id)initWithStoryUUID:(NSString *)uuid {
    self = [super init];
    
    self.storyUuid = uuid;
    
    self.microphone = [EZMicrophone microphoneWithDelegate:self];
    
    return self;
}

- (void)setupForMediaWithIndex:(NSInteger)pageIndex {
    
    self.currentPageIndex = pageIndex;
    
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
    
    if (err) {
        NSLog(@"%@", err);
    }
    
    [self.player play];
}

- (NSString*)pathForAudioFile {
//    NSArray* documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* filename = [NSString stringWithFormat:@"%@_%ld.m4a", self.storyUuid, (long)self.currentPageIndex];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    #ifdef IPHONE_SIMULATOR
        basePath = @"/Users/leo/Desktop";
    #endif
    
    return [NSString stringWithFormat:@"%@/%@", basePath, filename];
}

#pragma mark - EZMicrophone

- (void)microphone:(EZMicrophone *)microphone hasBufferList:(AudioBufferList *)bufferList withBufferSize:(UInt32)bufferSize withNumberOfChannels:(UInt32)numberOfChannels {
    // Getting audio data as a buffer list that can be directly fed into the EZRecorder. This is happening on the audio thread - any UI updating needs a GCD main queue block.
    if (self.recording) {
        [self.recorder appendDataFromBufferList:bufferList
                                 withBufferSize:bufferSize];
    }
    
}

@end
