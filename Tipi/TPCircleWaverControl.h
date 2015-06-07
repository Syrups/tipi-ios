//
//  TPCircleWaverControl.h
//  Tipi
//
//  Created by Glenn Sonna on 03/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

IB_DESIGNABLE

@import UIKit;
@import AVFoundation;

#import "SCSiriWaveformView.h"
#import <EZAudio/EZRecorder.h>
#import <EZAudio/EZMicrophone.h>

typedef enum TPCircleMode{
    TPCircleModeListen = 0,
    TPCircleModeRecord,
    TPCircleModeDemo
} TPCircleMode;

@interface TPCircleWaverControl : UIControl

@property (nonatomic) TPCircleMode mode;

@property (nonatomic, assign) id delegate;

@property (strong, nonatomic) SCSiriWaveformView* wave;
@property (strong, nonatomic) UIView* innerInteractionView;

@property (strong, nonatomic)  UIColor *backgroundPathColor;
@property (strong, nonatomic)  UIColor *progressPathColor;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVPlayer *simplePlayer;
@property (nonatomic, strong) EZRecorder *recorder;
@property (strong, nonatomic) EZMicrophone* microphone;



@property (strong, nonatomic) NSTimer* updateTimer;
@property NSTimeInterval currentRecordTime;

@property CGFloat duration;
@property CGFloat recordDuration;
@property CGFloat currentTimePercent;
@property CGFloat radiusFactor;
@property CGFloat radius;
@property CGFloat startAngle;

@property BOOL appeared;
@property BOOL showController;
@property BOOL showWave;
@property BOOL autoStart;

@property BOOL nowPlaying;
@property BOOL nowRecording;


- (void)play;
- (void)pause;

- (void)close;
- (void)appear;

@end

@protocol TPCircleTouchDelegate <NSObject>

@optional
- (void)circleWaverControl:(TPCircleWaverControl *)control didReceveivedLongPressGestureRecognizer: (UILongPressGestureRecognizer*) recognizer;

- (void)circleWaverControl:(TPCircleWaverControl *)control didReceveivedTapGestureRecognizer: (UITapGestureRecognizer*) recognizer;
@end

