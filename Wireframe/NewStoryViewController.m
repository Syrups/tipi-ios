//
//  NewStoryViewController.m
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "NewStoryViewController.h"
#import "StoryWIPSaver.h"

@interface NewStoryViewController ()

@end

@implementation NewStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.microphone = [[EZMicrophone alloc] initWithMicrophoneDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"stop fetching");
    [self.microphone stopFetchingAudio];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    for (UIView* v in self.view.subviews) {
        if (v.tag == 10) continue;
        
        v.layer.borderWidth = 1;
        v.layer.borderColor = [UIColor blackColor].CGColor;
    }
    
    if ([[StoryWIPSaver sharedSaver] saved]) {
        [self.mainButton setTitle:@"Continue story" forState:UIControlStateNormal];
        self.secondaryButton.hidden = NO;
    }
    
    [self.microphone startFetchingAudio];
}

#pragma mark - EZMicrophone

- (void)microphone:(EZMicrophone *)microphone hasAudioReceived:(float **)buffer withBufferSize:(UInt32)bufferSize withNumberOfChannels:(UInt32)numberOfChannels {
    
    NSUInteger scaledAmount = abs(buffer[0][0] * 1000);
    
    // enjoy
}

@end
