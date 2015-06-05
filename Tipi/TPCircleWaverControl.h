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

typedef enum TPCircleMode{
    TPCircleModeListen = 0,
    TPCircleModeRecord,
    TPCircleModeDemo
} TPCircleMode;

@interface TPCircleWaverControl : UIControl

@property TPCircleMode mode;

@property (nonatomic, assign) id delegate;

@property (strong, nonatomic) SCSiriWaveformView* wave;
@property (strong, nonatomic) UIView* innerInteractionView;

@property (strong, nonatomic)  UIColor *backgroundPathColor;
@property (strong, nonatomic)  UIColor *progressPathColor;

@property (strong, nonatomic) NSTimer* updateTimer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVPlayer *simplePlayer;


@property CGFloat duration;
@property CGFloat currentTimePercent;
@property CGFloat radiusFactor;
@property CGFloat radius;
@property CGFloat startAngle;

@property BOOL appeared;
@property BOOL recording;
@property BOOL showController;
@property BOOL showWave;
@property BOOL autoStart;


- (void)start;
- (void)close;
- (void)appear;

@end

@protocol TPCircleModeLongTouchDelegate <NSObject>

@optional
- (void)circleWaverControl:(TPCircleWaverControl *)control didReceveivedLongPressGestureRecognizer: (UILongPressGestureRecognizer*) page;
@end
