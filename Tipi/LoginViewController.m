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
#import "TPLoader.h"

@implementation LoginViewController {
    TPLoader* loader;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    if ([[UserSession sharedSession] isAuthenticated]) {
        UIViewController* home = [self.storyboard instantiateViewControllerWithIdentifier:@"Home"];
        [self.navigationController setViewControllers:@[home]];
    }
    
    
    CADisplayLink *displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeters)];
    [displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    [PKAIDecoder builAnimatedImageIn:self.littleWaves fromFile:@"waves" withAnimationDuration:7];
    
    [AnimationLibrary animateBouncingView:self.signInButton usingConstraint:self.signInButtonVerticalSpace ofType:AnimationLibraryBottomSpaceConstraint relativeToSuperview:self.view inverted:NO];
    [AnimationLibrary animateBouncingView:self.signUpButton usingConstraint:self.signUpButtonVerticalSpace ofType:AnimationLibraryBottomSpaceConstraint relativeToSuperview:self.view inverted:NO];
}

- (void)updateMeters
{
    [self.waveformView updateWithLevel:.5f];
    [self.secondWaveformView updateWithLevel:.5f];
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
    
    loader = [[TPLoader alloc] initWithFrame:self.view.frame];
    [self.view addSubview:loader];
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
