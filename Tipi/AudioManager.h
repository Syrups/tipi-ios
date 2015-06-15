//
//  AudioManager.h
//  Tipi
//
//  Created by Leo on 13/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioManager : NSObject

+ (BOOL)configureAudioSession;
+ (BOOL)isHeadsetPluggedIn;

@end
