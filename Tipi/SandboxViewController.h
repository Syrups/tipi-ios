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
#import <EZMicrophone.h>
#import "MediaLibrary.h"
#import "TPCircleWaverControl.h"

@interface SandboxViewController : UIViewController
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVPlayer *sandbPlayer;
@property (weak, nonatomic) IBOutlet TPCircleWaverControl *sendBoxControl;


@end
