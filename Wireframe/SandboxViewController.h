//
//  SandboxViewController.h
//  Wireframe
//
//  Created by Leo on 15/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRRecordButton.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioWave.h"
#import <EZMicrophone.h>

@interface SandboxViewController : UIViewController <EZMicrophoneDelegate>

@property (strong, nonatomic) IBOutlet SRRecordButton* button;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (weak, nonatomic) IBOutlet AudioWave *audioWave;
@property (strong, nonatomic) EZMicrophone* microphone;
@property (strong, nonatomic) IBOutlet UIImageView* loader;

@end
