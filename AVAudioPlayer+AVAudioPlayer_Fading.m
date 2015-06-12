//
//  AVAudioPlayer+AVAudioPlayer_Fading.m
//  Tipi
//
//  Created by Leo on 04/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "AVAudioPlayer+AVAudioPlayer_Fading.h"

typedef void(^fadeCompletion)(BOOL);

@implementation AVAudioPlayer (AVAudioPlayer_Fading)

-(void)fadeOutWithCompletion:(void(^)(BOOL finished))completion {
    if (self.volume > 0.1) {
        self.volume = self.volume - 0.1;
        [self performSelector:@selector(fadeOutWithCompletion:) withObject:completion afterDelay:0.05f];
    } else {
        completion(YES);
    }
}

-(void)fadeInWithCompletion:(void(^)(BOOL finished))completion {
    if (self.volume < 0.9) {
        self.volume = self.volume + 0.1;
        [self performSelector:@selector(fadeOutWithCompletion:) withObject:completion afterDelay:0.05f];
    } else {
        completion(YES);
    }
}

- (void)fadeOutPause{
    NSTimeInterval trueTime = self.currentTime;
    
    [self fadeOutWithCompletion:^(BOOL finished) {
        [self pause];
        [self prepareToPlay];
        self.volume = 1.0;
        self.currentTime = trueTime;
    }];
}

- (void)fadeOutPlay {
    [self prepareToPlay];
    [self fadeInWithCompletion:^(BOOL finished) {
        self.volume = 1.0;
        [self play];
    }];
}

-(void)fadeOutAndStop{
    [self fadeOutWithCompletion:^(BOOL stop) {
        // Stop and get the sound ready for playing again
        [self stop];
        self.currentTime = 0;
        
        [self prepareToPlay];
        self.volume = 1.0;
    }];
}



- (void)setTrueCurrentTime:(id)trueCurrentTime{
    objc_setAssociatedObject(self, @selector(trueCurrentTime), trueCurrentTime, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



- (id)trueCurrentTime {
    return objc_getAssociatedObject(self, @selector(trueCurrentTime));
}


@end
