//
//  ProfileViewController.m
//  Wireframe
//
//  Created by Leo on 03/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "ProfileViewController.h"

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usernameLabel.text = CurrentUser.username;
    
//    UserManager* manager = [[UserManager alloc] initWithDelegate:self];
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
