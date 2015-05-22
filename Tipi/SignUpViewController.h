//
//  SignUpViewController.h
//  Wireframe
//
//  Created by Leo on 19/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "SCSiriWaveformView.h"

@interface SignUpViewController : UIViewController <UITextFieldDelegate, UserCreatorDelegate>

@property (strong, nonatomic) IBOutlet SCSiriWaveformView* waveformView;
@property (strong, nonatomic) IBOutlet SCSiriWaveformView* secondWaveformView;
@property (strong, nonatomic) IBOutlet UITextField* usernameField;
@property (strong, nonatomic) IBOutlet UITextField* passwordField;
@property (strong, nonatomic) IBOutlet UITextField* emailField;

@end
