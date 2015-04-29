//
//  SettingsViewController.m
//  Wireframe
//
//  Created by Leo on 28/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)logout:(id)sender {
    [[UserSession sharedSession] destroy];
    
    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
    [self.navigationController setViewControllers:@[vc] animated:YES];
}

- (IBAction)openTerms:(id)sender {
    
}

@end
