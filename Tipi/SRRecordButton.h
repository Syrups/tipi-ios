//
//  SRRecordButton.h
//  Wireframe
//
//  Created by Leo on 01/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCSiriWaveformView.h"

@interface SRRecordButton : UIView

@property (strong, nonatomic) UIColor* color;
@property (strong, nonatomic) UIColor* fillColor;
@property CGFloat duration;
@property CGFloat currentTime;
@property BOOL appeared;
@property (strong, nonatomic) SCSiriWaveformView* wave;

- (void)appear;
- (void)close;
- (void)start;
- (void)hide;
- (void)pause;
- (void)reset;
- (void)updateWithBuffer:(float **)buffer bufferSize:(UInt32)bufferSize withNumberOfChannels:(UInt32)numberOfChannels ;

@end
