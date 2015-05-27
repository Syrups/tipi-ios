//
//  LoginViewController.h
//  Wireframe
//
//  Created by Leo on 18/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SCSiriWaveformView.h"
#import "UserManager.h"

@interface LoginViewController : UIViewController <UserAuthenticatorDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView* fieldsZone;
@property (strong, nonatomic) IBOutlet UIButton* signUpButton;
@property (strong, nonatomic) IBOutlet UIButton* signInButton;
@property (strong, nonatomic) IBOutlet UIButton* backButton;
@property (strong, nonatomic) IBOutlet UITextField* usernameField;
@property (strong, nonatomic) IBOutlet UITextField* passwordField;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* centerFieldsVerticalContraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* signInButtonVerticalSpace;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* signUpButtonVerticalSpace;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* signInButtonWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* signInButtonHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* backButtonTopConstraint;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, weak) IBOutlet SCSiriWaveformView *waveformView;
@property (nonatomic, weak) IBOutlet SCSiriWaveformView *secondWaveformView;
@property (strong, nonatomic) IBOutlet UIImageView* littleWaves;

@end
