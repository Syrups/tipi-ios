//
//  CommentAudioRecorder.h
//  Tipi
//
//  Created by Glenn Sonna on 30/05/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EZAudio/EZAudio.h>
#import <AVFoundation/AVFoundation.h>
#import "StoryWIPSaver.h"

@interface CommentAudioRecorder : NSObject  <EZMicrophoneDelegate, EZAudioFileDelegate, AVAudioPlayerDelegate>

@property (weak, nonatomic) id delegate;
@property (strong, nonatomic) NSString* commentUUID;
@property (strong, nonatomic) EZMicrophone* microphone;
@property (strong, nonatomic) EZRecorder* recorder;
@property (strong, nonatomic) AVAudioPlayer* player;
@property (strong, nonatomic) AVAudioRecorder* audioRecorder;
@property NSUInteger currentPageIndex;
@property BOOL recording;

- (void)startRecording;
- (void)stopRecording;
- (void)playAudio;
- (NSData *)dataOfAudioWithIndex:(NSUInteger)index;


@end

@protocol CommentAudioRecorderDelegate <NSObject>

- (void)commentRecorder:(CommentAudioRecorder*)recorder hasAudioReceived:(float **)buffer withBufferSize:(UInt32)bufferSize withNumberOfChannels:(UInt32)numberOfChannels;
- (void)commentRecorder:(CommentAudioRecorder*)recorder didFinishPlayingAudioAtIndex:(NSUInteger)index;

@end
