//
//  SignUpViewController.m
//  Wireframe
//
//  Created by Leo on 19/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "SignUpViewController.h"
#import "TPLoader.h"
#import "TPAlert.h"

@implementation SignUpViewController {
    TPLoader* loader;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeters)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    
    // authenticate
    [[UserSession sharedSession] storeUser:user];
    
    // show walkthrough to home
    UIViewController* walkthrough = [self.storyboard instantiateViewControllerWithIdentifier:@"Walkthrough"];
    
    [loader removeFromSuperview];
    [self.navigationController setViewControllers:@[walkthrough]];
    
    
}

- (void)userManager:(UserManager *)manager failedToCreateUserWithStatusCode:(NSUInteger)statusCode {
    if (statusCode == 409) {
        [TPAlert displayOnController:self withMessage:@"Désolé, mais ce nom d'utilisateur est déjà pris" delegate:nil];
    } else {
        [TPAlert displayOnController:self withMessage:@"Impossible de créer le compte, réessayez plus tard" delegate:nil];
    }
}

@end
