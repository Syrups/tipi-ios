//
//  NewStoryViewController.h
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseHomeViewController.h"
#import <EZAudio/EZAudio.h>

@interface NewStoryViewController : BaseHomeViewController <EZMicrophoneDelegate>

@property (strong, nonatomic) IBOutlet UIButton* mainButton;
@property (strong, nonatomic) IBOutlet UIButton* secondaryButton;
@property (strong, nonatomic) EZMicrophone* microphone;

@end
