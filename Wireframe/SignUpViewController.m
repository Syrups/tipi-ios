//
//  SignUpViewController.m
//  Wireframe
//
//  Created by Leo on 19/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "SignUpViewController.h"
#import "Configuration.h"

@implementation SignUpViewController

- (IBAction)requestCreate:(id)sender {
    UserManager* manager = [[UserManager alloc] initWithDelegate:self];
    
    NSString* username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
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
}

- (void)userManager:(UserManager *)manager failedToCreateUserWithStatusCode:(NSUInteger)statusCode {
    if (statusCode == 409) {
        ErrorAlert(@"Username is already taken");
    } else {
        ErrorAlert(@"Network error");
    }
}

@end
