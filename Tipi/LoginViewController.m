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
#import "TPAlert.h"
#import <UIView+MTAnimation.h>

@implementation LoginViewController {
    TPLoader* loader;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    if ([[UserSession sharedSession] isAuthenticated]) {
        UIViewController* home = [self.storyboard instantiateViewControllerWithIdentifier:@"Home"];
        [self.navigationController setViewControllers:@[home]];
    }
    
    [self.termsButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [PKAIDecoder builAnimatedImageIn:self.logo fromFile:@"logo" withAnimationDuration:3.5f];

    self.backButtonTopConstraint.constant = -100;

    [self animateIntroWithDelay:1.3f];
}


- (IBAction)openFields:(UIButton*)sender {
    [self animateToLogin];
}

- (IBAction)closeFields:(id)sender {
    [self animateFromLogin];
}

- (IBAction)toSignUp:(id)sender {
    [self animateToSignUp];
}

- (IBAction)closeSignUp:(id)sender {
    [self animateFromSignUp];
}

- (IBAction)attemptLogin:(id)sender {
    UserManager* manager = [[UserManager alloc] initWithDelegate:self];
    
    NSString* username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username isEqualToString:@""] || [password isEqualToString:@""]) {
        return;
    }
    
    [manager authenticateUserWithUsername:username password:password];
    
    loader = [[TPLoader alloc] initWithFrame:self.view.frame];
    [self.view addSubview:loader];
}

- (IBAction)requestCreate:(id)sender {
    UserManager* manager = [[UserManager alloc] initWithDelegate:self];
    
    NSString* username = [self.registerUsernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* password = [self.registerPasswordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* email = [self.registerEmailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    loader = [[TPLoader alloc] initWithFrame:self.view.frame];
    [self.view addSubview:loader];
    
    [manager createUserWithUsername:username password:password email:email];
}

#pragma mark - UserAuthenticator

- (void)userManager:(UserManager *)manager successfullyAuthenticatedUser:(User *)user {
    NSLog(@"API TOKEN : %@", user.token);
    
    [[UserSession sharedSession] storeUser:user];
    
    UIViewController* home = [self.storyboard instantiateViewControllerWithIdentifier:@"Home"];
    [self.navigationController setViewControllers:@[home]];
}

- (void)userManager:(UserManager *)manager failedToAuthenticateUserWithUsername:(NSString *)username withStatusCode:(NSInteger)code {
    
    if (code == 404 || code == 403) {
        [TPAlert displayOnController:self withMessage:NSLocalizedString(@"Mauvaise combinaison nom d'utilisateur / mot de passe", nil) delegate:nil];
    } else {
    // failure
        [TPAlert displayOnController:self withMessage:NSLocalizedString(@"Une erreur est survenue, merci de réessayer plus tard", nil) delegate:nil];
    }
    [loader removeFromSuperview];
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
    
    [loader removeFromSuperview];
}

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if ([textField isEqual:self.usernameField]) {
        [self.passwordField becomeFirstResponder];
    }
    
    return YES;
}

#pragma mark - Animations

- (void)animateIntroWithDelay:(CGFloat)delay {
    self.logo.transform = Translate(0, 90);
    self.titleLabel.transform = Translate(0, 100);
    self.subtitleLabel.transform = Translate(0, 100);
    self.titleLabel.alpha = 0;
    self.subtitleLabel.alpha = 0;
    self.signInButton.transform = Translate(0, 150);
    self.signUpButton.transform = Translate(0, 200);
    
    [UIView mt_animateWithViews:@[self.logo, self.titleLabel, self.signInButton, self.signUpButton] duration:.6f delay:delay timingFunction:kMTEaseOutBack animations:^{
        self.logo.alpha = 1;
        self.logo.transform = CGAffineTransformIdentity;
    } completion:nil];
    
    [UIView mt_animateWithViews:@[self.titleLabel] duration:.6f delay:delay + .1f timingFunction:kMTEaseOutBack animations:^{
        self.titleLabel.transform = CGAffineTransformIdentity;
        self.titleLabel.alpha = 1;
    } completion:nil];
    
    [UIView mt_animateWithViews:@[self.subtitleLabel] duration:.6f delay:delay + .2f timingFunction:kMTEaseOutBack animations:^{
        self.subtitleLabel.transform = CGAffineTransformIdentity;
        self.subtitleLabel.alpha = .6f;
    } completion:nil];
    
    [UIView mt_animateWithViews:@[self.signUpButton] duration:.6f delay:delay + .3f timingFunction:kMTEaseOutBack animations:^{
        self.signUpButton.transform = CGAffineTransformIdentity;
    } completion:nil];
    
    [UIView mt_animateWithViews:@[self.signInButton] duration:.6f delay:delay + .4f timingFunction:kMTEaseOutBack animations:^{
        self.signInButton.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)animateToLogin {
    [self.view layoutIfNeeded];
    
    [UIView mt_animateWithViews:@[self.signUpButton] duration:.6f delay:0 timingFunction:kMTEaseInBack animations:^{
        self.signUpButton.transform = Translate(0, 200);
    } completion:nil];
    
    [UIView mt_animateWithViews:@[self.signInButton] duration:.4f delay:.1f timingFunction:kMTEaseInBack animations:^{
        self.signInButton.transform = Translate(0, 150);
    } completion:^{
        self.signInButton.backgroundColor = [UIColor whiteColor];
        self.signInButton.titleLabel.textColor = kCreateBackgroundColor;
        [UIView mt_animateWithViews:@[self.signInButton] duration:.6f delay:.3f timingFunction:kMTEaseOutBack animations:^{
            self.signInButton.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
    
    [UIView mt_animateWithViews:@[self.logo, self.titleLabel, self.subtitleLabel] duration:.3f delay:.2f timingFunction:kMTEaseInBack animations:^{
        self.logo.transform = Translate(0, 50);
        self.titleLabel.transform = Translate(0, 50);
        self.subtitleLabel.transform = Translate(0, 50);
        self.logo.alpha = 0;
        self.titleLabel.alpha = 0;
        self.subtitleLabel.alpha = 0;
    } completion:nil];
    
    self.usernameField.transform = Translate(0, -150);
    self.passwordField.transform = Translate(0, -70);
    
    [UIView mt_animateWithViews:@[self.usernameField] duration:.6f delay:.4f timingFunction:kMTEaseOutBack animations:^{
        self.usernameField.transform = CGAffineTransformIdentity;
        self.usernameField.alpha = 1;
    } completion:nil];
    
    [UIView mt_animateWithViews:@[self.passwordField] duration:.5f delay:.5f timingFunction:kMTEaseOutBack animations:^{
        self.passwordField.transform = CGAffineTransformIdentity;
        self.passwordField.alpha = 1;
    } completion:nil];
    
    
    [UIView animateWithDuration:.3f delay:.2f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backButtonTopConstraint.constant = 0;
        self.view.backgroundColor = kCreateBackgroundColor;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.backButton removeTarget:self action:@selector(closeSignUp:) forControlEvents:UIControlEventTouchUpInside];
        [self.backButton addTarget:self action:@selector(closeFields:) forControlEvents:UIControlEventTouchUpInside];
        [self.signInButton removeTarget:self action:@selector(openFields:) forControlEvents:UIControlEventTouchUpInside];
        [self.signInButton addTarget:self action:@selector(attemptLogin:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)animateFromLogin {
    
    [UIView animateWithDuration:.3f animations:^{
        self.view.backgroundColor = RgbColorAlpha(222, 86, 54, 1);
        self.backButtonTopConstraint.constant = -100;
        [self.view layoutIfNeeded];
    }];
    
    [UIView mt_animateWithViews:@[self.usernameField] duration:.6f delay:0 timingFunction:kMTEaseInBack animations:^{
        self.usernameField.transform = Translate(0, -100);
        self.usernameField.alpha = 0;
    } completion:nil];
    
    [UIView mt_animateWithViews:@[self.passwordField] duration:.6f delay:.1f timingFunction:kMTEaseInBack animations:^{
        self.passwordField.transform = Translate(0, -100);
        self.passwordField.alpha = 0;
    } completion:nil];
    
    [UIView mt_animateWithViews:@[self.signInButton] duration:.4f delay:.2f timingFunction:kMTEaseInBack animations:^{
        self.signInButton.transform = Translate(0, 200);
    } completion:^{
        self.signInButton.backgroundColor = [UIColor clearColor];
        self.signInButton.titleLabel.textColor = [UIColor whiteColor];
        [self animateIntroWithDelay:0];
    }];
    
    [self.signInButton removeTarget:self action:@selector(attemptLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.signInButton addTarget:self action:@selector(openFields:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)animateToSignUp {
    [UIView mt_animateWithViews:@[self.signUpButton] duration:.6f delay:0 timingFunction:kMTEaseInBack animations:^{
        self.signUpButton.transform = Translate(0, 200);
    } completion:^{
        [UIView mt_animateWithViews:@[self.signUpButton] duration:.6f delay:.3f timingFunction:kMTEaseOutBack animations:^{
            self.signUpButton.transform = Translate(0, 40);
        } completion:nil];
    }];
    
    [UIView mt_animateWithViews:@[self.signInButton] duration:.4f delay:.1f timingFunction:kMTEaseInBack animations:^{
        self.signInButton.transform = Translate(0, 150);
    } completion:nil];
    
    [UIView mt_animateWithViews:@[self.logo, self.titleLabel, self.subtitleLabel] duration:.3f delay:.2f timingFunction:kMTEaseInBack animations:^{
        self.logo.transform = Translate(0, 50);
        self.titleLabel.transform = Translate(0, 50);
        self.subtitleLabel.transform = Translate(0, 50);
        self.logo.alpha = 0;
        self.titleLabel.alpha = 0;
        self.subtitleLabel.alpha = 0;
    } completion:nil];
    
    self.registerUsernameField.transform = Translate(0, -160);
    self.registerPasswordField.transform = Translate(0, -100);
    self.registerEmailField.transform = Translate(0, -70);
    self.termsButton.transform = Translate(0, -40);
    
    [UIView mt_animateWithViews:@[self.registerUsernameField] duration:.6f delay:.4f timingFunction:kMTEaseOutBack animations:^{
        self.registerUsernameField.transform = CGAffineTransformIdentity;
        self.registerUsernameField.alpha = 1;
    } completion:nil];
    
    [UIView mt_animateWithViews:@[self.registerPasswordField] duration:.5f delay:.5f timingFunction:kMTEaseOutBack animations:^{
        self.registerPasswordField.transform = CGAffineTransformIdentity;
        self.registerPasswordField.alpha = 1;
    } completion:nil];
    
    [UIView mt_animateWithViews:@[self.registerEmailField] duration:.4f delay:.6f timingFunction:kMTEaseOutBack animations:^{
        self.registerEmailField.transform = CGAffineTransformIdentity;
        self.registerEmailField.alpha = 1;
    } completion:nil];
    
    [UIView mt_animateWithViews:@[self.termsButton] duration:.4f delay:.6f timingFunction:kMTEaseOutBack animations:^{
        self.termsButton.transform = CGAffineTransformIdentity;
        self.termsButton.alpha = 1;
    } completion:nil];
    
    
    [UIView animateWithDuration:.3f delay:.2f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backButtonTopConstraint.constant = 0;
        self.view.backgroundColor = kCreateBackgroundColor;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.signUpButton removeTarget:self action:@selector(toSignUp:) forControlEvents:UIControlEventTouchUpInside];
        [self.signUpButton addTarget:self action:@selector(requestCreate:) forControlEvents:UIControlEventTouchUpInside];
        [self.backButton removeTarget:self action:@selector(closeFields:) forControlEvents:UIControlEventTouchUpInside];
        [self.backButton addTarget:self action:@selector(closeSignUp:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)animateFromSignUp {
    
    [UIView animateWithDuration:.3f animations:^{
        self.backButtonTopConstraint.constant = -100;
        self.view.backgroundColor = RgbColorAlpha(222, 86, 54, 1);
        [self.view layoutIfNeeded];
    }];
    
    [UIView mt_animateWithViews:@[self.registerUsernameField] duration:.6f delay:0 timingFunction:kMTEaseInBack animations:^{
        self.registerUsernameField.transform = Translate(0, -100);
        self.registerUsernameField.alpha = 0;
    } completion:nil];
    
    [UIView mt_animateWithViews:@[self.registerPasswordField] duration:.6f delay:.1f timingFunction:kMTEaseInBack animations:^{
        self.registerPasswordField.transform = Translate(0, -100);
        self.registerPasswordField.alpha = 0;
    } completion:nil];
    
    [UIView mt_animateWithViews:@[self.registerEmailField] duration:.6f delay:.2f timingFunction:kMTEaseInBack animations:^{
        self.registerEmailField.transform = Translate(0, -100);
        self.registerEmailField.alpha = 0;
    } completion:nil];
    
    [UIView mt_animateWithViews:@[self.termsButton] duration:.6f delay:.2f timingFunction:kMTEaseInBack animations:^{
        self.termsButton.transform = Translate(0, -50);
        self.termsButton.alpha = 0;
    } completion:nil];
    
    [UIView mt_animateWithViews:@[self.signUpButton] duration:.4f delay:.3f timingFunction:kMTEaseInBack animations:^{
        self.signUpButton.transform = Translate(0, 200);
    } completion:^{
        [self animateIntroWithDelay:0];
    }];
    
    [self.signUpButton removeTarget:self action:@selector(requestCreate:) forControlEvents:UIControlEventTouchUpInside];
    [self.signUpButton addTarget:self action:@selector(toSignUp:) forControlEvents:UIControlEventTouchUpInside];
}

@end
