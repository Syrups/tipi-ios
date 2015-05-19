//
//  LoginViewController.m
//  Wireframe
//
//  Created by Leo on 18/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "LoginViewController.h"
#import "UserSession.h"
#import "PKAIDecoder.h"
#import "AnimationLibrary.h"

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    if ([[UserSession sharedSession] isAuthenticated]) {
        UIViewController* home = [self.storyboard instantiateViewControllerWithIdentifier:@"Home"];
        [self.navigationController setViewControllers:@[home]];
    }
    
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    
    NSDictionary *settings = @{AVSampleRateKey:          [NSNumber numberWithFloat: 44100.0],
                               AVFormatIDKey:            [NSNumber numberWithInt: kAudioFormatAppleLossless],
                               AVNumberOfChannelsKey:    [NSNumber numberWithInt: 2],
                               AVEncoderAudioQualityKey: [NSNumber numberWithInt: AVAudioQualityMin]};
    
    NSError *error;
    self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    
    if(error) {
        NSLog(@"Ups, could not create recorder %@", error);
        return;
    }
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    
    if (error) {
        NSLog(@"Error setting category: %@", [error description]);
    }
    
    [self.recorder prepareToRecord];
    [self.recorder setMeteringEnabled:YES];
    [self.recorder record];
    
    CADisplayLink *displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeters)];
    [displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    [PKAIDecoder builAnimatedImageIn:self.littleWaves fromFile:@"waves" withAnimationDuration:6];
    
    [AnimationLibrary animateBouncingView:self.signInButton usingConstraint:self.signInButtonVerticalSpace ofType:AnimationLibraryBottomSpaceConstraint relativeToSuperview:self.view inverted:NO];
    [AnimationLibrary animateBouncingView:self.signUpButton usingConstraint:self.signUpButtonVerticalSpace ofType:AnimationLibraryBottomSpaceConstraint relativeToSuperview:self.view inverted:NO];
}

- (void)updateMeters
{
    [self.recorder updateMeters];
    
    CGFloat normalizedValue = pow (10, [self.recorder averagePowerForChannel:0] / 20);
    
    [self.waveformView updateWithLevel:normalizedValue];
    [self.secondWaveformView updateWithLevel:normalizedValue];
}

- (IBAction)openFields:(UIButton*)sender {
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.fieldsZone.alpha = 1;
        self.signInButtonVerticalSpace.constant -= 40;
        self.signUpButton.alpha = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [sender removeTarget:self action:@selector(openFields:) forControlEvents:UIControlEventTouchUpInside];
        [sender addTarget:self action:@selector(attemptLogin:) forControlEvents:UIControlEventTouchUpInside];
        [self.usernameField becomeFirstResponder];
    }];
}

- (IBAction)attemptLogin:(id)sender {
    UserManager* manager = [[UserManager alloc] initWithDelegate:self];
    
    NSString* username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [manager authenticateUserWithUsername:username password:password];
}

#pragma mark - UserManager

- (void)userManager:(UserManager *)manager successfullyAuthenticatedUser:(User *)user {
    NSLog(@"API TOKEN : %@", user.token);
    
    [[UserSession sharedSession] storeUser:user];
    
    UIViewController* home = [self.storyboard instantiateViewControllerWithIdentifier:@"Home"];
    [self.navigationController setViewControllers:@[home]];
}

- (void)userManager:(UserManager *)manager failedToAuthenticateUserWithUsername:(NSString *)username {
    // failure
}

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

@end
