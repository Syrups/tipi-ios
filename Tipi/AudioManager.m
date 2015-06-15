//
//  AudioManager.m
//  Tipi
//
//  Created by Leo on 13/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "AudioManager.h"

@implementation AudioManager

+ (BOOL)configureAudioSession {
    AVAudioSession* session = [AVAudioSession sharedInstance];
    
    BOOL success;
    NSError *err;
    
    success = [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&err];
    
    if (!success) {
        NSLog(@"%@", err);
    }
    
    if (![self isHeadsetPluggedIn])
        success = [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&err];
    
    if (!success) {
        NSLog(@"%@", err);
    }
    
    success = [session setActive:YES error:&err];
    
    if (!success) {
        NSLog(@"%@", err);
    }
    
    return success;
}

+ (BOOL)isHeadsetPluggedIn
{
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones])
            return YES;
    }
    return NO;
}

@end
