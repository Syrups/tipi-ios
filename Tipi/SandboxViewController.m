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

@import AVFoundation;
@import AVKit;

@implementation SandboxViewController {
    CGFloat lastValue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //TPCircleWaverControl *wv = [[TPCircleWaverControl alloc]initWithFrame:CGRectMake(self.view.frame.size.width /2 - 100, self.view.frame.size.height/2 - 100, 200, 200);];
    //[self.view addSubview:wv];
    
    
    NSString *path = [NSString stringWithFormat:@"%@/suitcase.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    NSError *err;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&err];
    self.sendBoxControl.audioPlayer = self.audioPlayer;
    [self.audioPlayer play];
    
    
    ///S>T>R>E>A>M>I>N>G
    
    //NSString *streamingString = @"http://api.soundcloud.com/tracks/146814101/stream.json?client_id=fc886d005e29ba78f046e5474e3fdefb";
    
    //self.sandbPlayer = [AVPlayer playerWithURL:[NSURL URLWithString:streamingString]];
    //self.sandbPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    /*[[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(playerItemDidReachEnd:)
     name:AVPlayerItemDidPlayToEndTimeNotification
     object:[songPlayer currentItem]];*/

    //[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
    
    //self.sendBoxControl.simplePlayer = self.sandbPlayer;
    [self.sendBoxControl appear];
}



- (void)viewDidAppear:(BOOL)animated{
    
    
}


@end
