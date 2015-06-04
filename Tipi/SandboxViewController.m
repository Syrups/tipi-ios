//
//  SandboxViewController.m
//  Wireframe
//
//  Created by Leo on 15/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "SandboxViewController.h"
#import "PKAIDecoder.h"
#import "TPSwipableViewController.h"

#import "TPCircleWaverControl.h"
@import AVFoundation;
@import AVKit;

@implementation SandboxViewController {
    CGFloat lastValue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *path = [NSString stringWithFormat:@"%@/suitcase.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    NSError *err;
    // Create audio player object and initialize with URL to sound
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&err];
    
    CGRect frame = CGRectMake(self.view.frame.size.width /2 - 100, self.view.frame.size
                              .height/2 - 100, 200, 200);
    TPCircleWaverControl *wv = [[TPCircleWaverControl alloc]initWithFrame:frame];
    wv. audioPlayer = self.audioPlayer;
    [wv appear];
    [wv start];
    
    [self.audioPlayer play];
    
    /*NSString *streamingString = @"http://api.soundcloud.com/tracks/146814101/stream.json?client_id=fc886d005e29ba78f046e5474e3fdefb";
     NSURL *streamingURL = [NSURL URLWithString:streamingString];
     NSLog(@"%@", streamingURL);
     self.sandbPlayer = [AVPlayer playerWithURL:streamingURL];
     [self.sandbPlayer play];
     self.sandbPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;*/
    
    [self.view addSubview:wv];
}


@end
