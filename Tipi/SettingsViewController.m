//
//  SettingsViewController.m
//  Wireframe
//
//  Created by Leo on 28/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingsViewController.h"
#import "AnimationLibrary.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self animate];
}

- (IBAction)logout:(id)sender {
    [[UserSession sharedSession] destroy];
    
    UINavigationController* rootNav = (UINavigationController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController;
    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
    [rootNav setViewControllers:@[vc] animated:YES];
}

- (IBAction)openTerms:(id)sender {
    
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)animate {
    [self.rows enumerateObjectsUsingBlock:^(UIView* view, NSUInteger idx, BOOL *stop) {
        
        [AnimationLibrary animateBouncingView:view];
        
    }];
    
}

@end
