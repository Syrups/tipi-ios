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
    NSLog(@"%@", videoUrl);
    AVURLAsset* asset = [AVURLAsset URLAssetWithURL:videoUrl options:nil];
    AVPlayerItem* item = [AVPlayerItem playerItemWithAsset:asset];
    self.moviePlayer = [AVPlayer playerWithPlayerItem:item];
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.moviePlayer];
    self.moviePlayer.volume = 0;
    
    self.playerLayer.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height + 100);
    
    UIView* preview = [self.contentView viewWithTag:40];
    [preview.layer insertSublayer:self.playerLayer atIndex:0];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:item queue:nil usingBlock:^(NSNotification *note) {
        AVPlayerItem* item = [note object];
        [item seekToTime:kCMTimeZero];
        [self.moviePlayer play];
    }];
    
    [self.moviePlayer play];
}

@end
