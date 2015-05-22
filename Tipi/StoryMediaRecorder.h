//
//  StoryMediaRecorder.h
//  Wireframe
//
//  Created by Leo on 17/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EZAudio/EZAudio.h>
#import <AVFoundation/AVFoundation.h>

@interface StoryMediaRecorder : NSObject <EZMicrophoneDelegate, EZAudioFileDelegate, AVAudioPlayerDelegate>

@property (weak, nonatomic) id delegate;
@property (strong, nonatomic) NSString* storyUuid;
@property (strong, nonatomic) EZMicrophone* microphone;
@property (strong, nonatomic) EZRecorder* recorder;
@property (strong, nonatomic) AVAudioPlayer* player;
@property (strong, nonatomic) AVAudioRecorder* audioRecorder;
@property NSUInteger currentPageIndex;
@property BOOL recording;

- initWithStoryUUID:(NSString*)uuid;
- (void)setupForMediaWithIndex:(NSInteger)pageIndex;
- (void)startRecording;
- (void)stopRecording;
- (void)playAudio;
- (NSData*)dataOfAudioWithIndex:(NSUInteger)index;
- (BOOL)hasRecordedAtIndex:(NSUInteger)index;
- (BOOL)isComplete;
- (BOOL)isEmpty;

@end

@protocol StoryMediaRecorderDelegate <NSObject>

- (void)mediaRecorder:(StoryMediaRecorder*)recorder hasAudioReceived:(float **)buffer withBufferSize:(UInt32)bufferSize withNumberOfChannels:(UInt32)numberOfChannels;
- (void)mediaRecorder:(StoryMediaRecorder*)recorder didFinishPlayingAudioAtIndex:(NSUInteger)index;

@end
