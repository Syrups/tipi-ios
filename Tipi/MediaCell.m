//
//  MediaCell.m
//  Wireframe
//
//  Created by Leo on 17/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "MediaCell.h"

@implementation MediaCell

- (instancetype)initWithMedia:(NSMutableDictionary *)media {
    self = [super init];
    
    if (self) {
        self.media = media;
    }
    
    return self;
}

- (void)launchVideoPreviewWithUrl:(NSURL *)videoUrl {
    AVURLAsset* asset = [AVURLAsset URLAssetWithURL:videoUrl options:nil];
    AVPlayerItem* item = [AVPlayerItem playerItemWithAsset:asset];
    self.moviePlayer = [AVPlayer playerWithPlayerItem:item];
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.moviePlayer];
    self.moviePlayer.volume = 0;
    
    UIView* preview = [self.contentView viewWithTag:40];
    
    self.playerLayer.frame = CGRectMake(-preview.frame.size.width/2, -preview.frame.size.height/2, preview.frame.size.width*2, preview.frame.size.height*2);
    [preview.layer addSublayer:self.playerLayer];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:item queue:nil usingBlock:^(NSNotification *note) {
        AVPlayerItem* item = [note object];
        [item seekToTime:kCMTimeZero];
        [self.moviePlayer play];
    }];
    
    [self.moviePlayer play];
}

@end
