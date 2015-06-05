//
//  AVAudioPlayer+AVAudioPlayer_Fading.h
//  Tipi
//
//  Created by Leo on 04/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVAudioPlayer (AVAudioPlayer_Fading)

-(void)fadeOutAndPause;
-(void)fadeInWithCompletion:(void(^)(BOOL finished))completion;
-(void)fadeOutWithCompletion:(void(^)(BOOL finished))completion;

@end
