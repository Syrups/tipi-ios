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

@interface StoryMediaRecorder : NSObject <EZMicrophoneDelegate, EZAudioFileDelegate>

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

@end
