//
//  CommentAudioRecorder.m
//  Tipi
//
//  Created by Glenn Sonna on 30/05/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "CommentAudioRecorder.h"
#import "AudioManager.h"

@implementation CommentAudioRecorder

- (id)init{
    self = [super init];
    
    self.commentUUID = [StoryWIPSaver sharedSaver].uuid;
    
    self.microphone = [EZMicrophone microphoneWithDelegate:self];
    
    [AudioManager configureAudioSession];
    
    return self;
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


#pragma mark - EZMicrophone

- (void)microphone:(EZMicrophone *)microphone hasBufferList:(AudioBufferList *)bufferList withBufferSize:(UInt32)bufferSize withNumberOfChannels:(UInt32)numberOfChannels {
    // Getting audio data as a buffer list that can be directly fed into the EZRecorder. This is happening on the audio thread - any UI updating needs a GCD main queue block.
    if (self.recording) {
        [self.recorder appendDataFromBufferList:bufferList
                                 withBufferSize:bufferSize];
    }
    
}

- (void)microphone:(EZMicrophone *)microphone hasAudioReceived:(float **)buffer withBufferSize:(UInt32)bufferSize withNumberOfChannels:(UInt32)numberOfChannels {
    if ([self.delegate respondsToSelector:@selector(commentRecorder:hasAudioReceived:withBufferSize:withNumberOfChannels:)]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self.delegate commentRecorder:self hasAudioReceived:buffer withBufferSize:bufferSize withNumberOfChannels:numberOfChannels];
        });
    }
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

- (NSData *)dataOfAudioWithIndex:(NSUInteger)index {
    NSString* filename = [NSString stringWithFormat:@"%@_%ld.m4a", self.commentUUID, (long)index];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
#ifdef IPHONE_SIMULATOR
    basePath = @"/Users/leo/Desktop";
#endif
    
    return [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", basePath, filename]];
}


#pragma mark - AVAudioPlayer

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag == YES) {
        if ([self.delegate respondsToSelector:@selector(commentRecorder:didFinishPlayingAudioAtIndex:)]) {
            [self.delegate commentRecorder:self didFinishPlayingAudioAtIndex:self.currentPageIndex];
        }
    }
}

- (NSString*)pathForAudioFile {
    //    NSArray* documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* filename = [NSString stringWithFormat:@"%@_%ld.m4a", self.commentUUID, (long)self.currentPageIndex];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
#ifdef IPHONE_SIMULATOR
    basePath = @"/Users/leo/Desktop";
#endif
    
    return [NSString stringWithFormat:@"%@/%@", basePath, filename];
}
@end
