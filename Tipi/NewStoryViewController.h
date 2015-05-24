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
#import "AudioWave.h"
#import "HomeBubble.h"

@interface NewStoryViewController : BaseHomeViewController <EZMicrophoneDelegate>

@property (strong, nonatomic) IBOutlet UIButton* mainButton;
@property (strong, nonatomic) IBOutlet UIButton* secondaryButton;
@property (strong, nonatomic) EZMicrophone* microphone;
@property (strong, nonatomic) IBOutlet AudioWave* wave;
@property (strong, nonatomic) IBOutlet UIView* bottom;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* bottomViewYConstraint;
@property (strong, nonatomic) IBOutlet HomeBubble* bubble;

@property (strong, nonatomic) IBOutlet UIButton* profileButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* topControlsYConstraint;

@property (strong, nonatomic) IBOutlet UIView* notificationsAlert;

- (void)transitionToFires;
- (void)transitionFromFires;
- (void)transitionFromProfile;
- (void)transitionFromStoryBuilder;

@end
