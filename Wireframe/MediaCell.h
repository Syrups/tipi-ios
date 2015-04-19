//
//  MediaCell.h
//  Wireframe
//
//  Created by Leo on 17/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MediaCell : UICollectionViewCell

@property (strong, nonatomic) NSMutableDictionary* media;
@property (strong, nonatomic) AVPlayer* moviePlayer;
@property (strong, nonatomic) AVPlayerLayer* playerLayer;

- (instancetype)initWithMedia:(NSMutableDictionary*)media;
- (void)launchVideoPreviewWithUrl:(NSURL*)videoUrl;

@end
