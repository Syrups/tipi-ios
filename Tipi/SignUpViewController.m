//
//  SignUpViewController.m
//  Wireframe
//
//  Created by Leo on 19/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "SignUpViewController.h"
#import "TPLoader.h"

@implementation SignUpViewController {
    TPLoader* loader;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeters)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateMeters
{
    [self.waveformView updateWithLevel:.5f];
    [self.secondWaveformView updateWithLevel:.5f];
}

- (IBAction)requestCreate:(id)sender {
    UserManager* manager = [[UserManager alloc] initWithDelegate:self];
    
    NSString* username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    loader = [[TPLoader alloc] initWithFrame:self.view.frame];
    [self.view addSubview:loader];
    
    [manager createUserWithUsername:username password:password email:email];
}

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - UserCreator

- (void)userManager:(UserManager *)manager successfullyCreatedUser:(User *)user {
    // success
    [loader removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)userManager:(UserManager *)manager failedToCreateUserWithStatusCode:(NSUInteger)statusCode {
    if (statusCode == 409) {
        ErrorAlert(@"Username is already taken");
    } else {
        ErrorAlert(@"Network error");
    }
}

@end
