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
    
//    self.microphone = [[EZMicrophone alloc] initWithMicrophoneDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"stop fetching");
//    [self.microphone stopFetchingAudio];
}

- (IBAction)launchStoryBuilder:(id)sender {
    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StoryBuilder"];
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([[StoryWIPSaver sharedSaver] saved]) {
        [self.mainButton setTitle:@"Continue story" forState:UIControlStateNormal];
        self.secondaryButton.hidden = NO;
    }
    
//    [self.microphone startFetchingAudio];
}

#pragma mark - EZMicrophone

- (void)microphone:(EZMicrophone *)microphone hasAudioReceived:(float **)buffer withBufferSize:(UInt32)bufferSize withNumberOfChannels:(UInt32)numberOfChannels {
    
    //NSUInteger scaledAmount = fabsf(buffer[0][0] * 1000);
    
    [self.wave updateWithBuffer:buffer bufferSize:bufferSize withNumberOfChannels:numberOfChannels];
    
    // enjoy
}

@end
