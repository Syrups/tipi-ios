//
//  LoginViewController.h
//  Wireframe
//
//  Created by Leo on 18/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"

@interface LoginViewController : UIViewController <UserAuthenticatorDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField* usernameField;
@property (strong, nonatomic) IBOutlet UITextField* passwordField;

@end
