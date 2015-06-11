//
//  SettingsViewController.m
//  Wireframe
//
//  Created by Leo on 28/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingsViewController.h"
#import "ProfileViewController.h"
#import "AnimationLibrary.h"
#import "TPLoader.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self animate];
}

- (IBAction)logout:(id)sender {
    [[UserSession sharedSession] destroy];
    
    UINavigationController* rootNav = (UINavigationController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController;
    UIViewController* vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Login"];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    TPLoader* loader = [[TPLoader alloc] initWithFrame:self.view.frame];
    [self.parentViewController.view addSubview:loader];
    
    [rootNav setViewControllers:@[vc] animated:YES];
}

- (IBAction)openTerms:(id)sender {
    
}

- (IBAction)dismiss:(id)sender {
    [UIView animateWithDuration:.3f animations:^{
        self.view.frame = ((ProfileViewController*)self.parentViewController).bodyView.frame;
        
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (void)animate {
    [self.rows enumerateObjectsUsingBlock:^(UIView* view, NSUInteger idx, BOOL *stop) {
        
        [AnimationLibrary animateBouncingView:view withDelay:idx * .1f];
        
    }];
    
}

@end
