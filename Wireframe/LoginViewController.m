//
//  LoginViewController.m
//  Wireframe
//
//  Created by Leo on 18/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "LoginViewController.h"
#import "UserSession.h"

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[UserSession sharedSession] load];
    
    if ([[UserSession sharedSession] isAuthenticated]) {
        UIViewController* home = [self.storyboard instantiateViewControllerWithIdentifier:@"Home"];
        [self.navigationController setViewControllers:@[home]];
    }
    
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
