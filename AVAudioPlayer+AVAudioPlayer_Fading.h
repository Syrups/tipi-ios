//
//  AVAudioPlayer+AVAudioPlayer_Fading.h
//  Tipi
//
//  Created by Leo on 04/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>

@interface AVAudioPlayer (AVAudioPlayer_Fading)

@property (nonatomic, strong) id trueCurrentTime;

-(void)fadeInWithCompletion:(void(^)(BOOL finished))completion;
-(void)fadeOutWithCompletion:(void(^)(BOOL finished))completion;


- (void)fadeInPlay;
- (void)fadeOutPause;
- (void)fadeOutAndStop;


@end
