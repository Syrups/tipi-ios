//
//  AVAudioPlayer+AVAudioPlayer_Fading.m
//  Tipi
//
//  Created by Leo on 04/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "AVAudioPlayer+AVAudioPlayer_Fading.h"

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

- (void)fadeOutAndPause {
    [self fadeOutWithCompletion:^(BOOL finished) {
        [self pause];
    }];
}


@end
