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

@interface LoginViewController : UIViewController <UserAuthenticatorDelegate, UserCreatorDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView* fieldsZone;
@property (strong, nonatomic) IBOutlet UIButton* signUpButton;
@property (strong, nonatomic) IBOutlet UIButton* signInButton;
@property (strong, nonatomic) IBOutlet UIButton* backButton;
@property (strong, nonatomic) IBOutlet UITextField* usernameField;
@property (strong, nonatomic) IBOutlet UITextField* passwordField;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* centerFieldsVerticalContraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* titleVerticalConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* signInButtonVerticalSpace;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* signUpButtonVerticalSpace;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* signInButtonWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* signInButtonHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* backButtonTopConstraint;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, weak) IBOutlet SCSiriWaveformView *waveformView;
@property (nonatomic, weak) IBOutlet SCSiriWaveformView *secondWaveformView;
@property (strong, nonatomic) IBOutlet UIImageView* littleWaves;
@property (strong, nonatomic) IBOutlet UIImageView* logo;
@property (strong, nonatomic) IBOutlet UILabel* titleLabel;
@property (strong, nonatomic) IBOutlet UILabel* subtitleLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* logoVerticalConstraint;
@property (strong, nonatomic) IBOutlet UITextField* registerUsernameField;
@property (strong, nonatomic) IBOutlet UITextField* registerPasswordField;
@property (strong, nonatomic) IBOutlet UITextField* registerEmailField;
@property (strong, nonatomic) IBOutlet UIButton* termsButton;

@end
