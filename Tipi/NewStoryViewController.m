//
//  NewStoryViewController.m
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "NewStoryViewController.h"
#import "HomeViewController.h"
#import "StoryWIPSaver.h"
#import "AnimationLibrary.h"

@interface NewStoryViewController ()

@end

@implementation NewStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    self.microphone = [[EZMicrophone alloc] initWithMicrophoneDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

//    [self.microphone stopFetchingAudio];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([[StoryWIPSaver sharedSaver] saved]) {
        [self.mainButton setTitle:@"Continue story" forState:UIControlStateNormal];
        self.secondaryButton.hidden = NO;
    }
    
//    [self.microphone startFetchingAudio];
}

#pragma mark - EZMicrophone

- (void)microphone:(EZMicrophone *)microphone hasAudioReceived:(float **)buffer withBufferSize:(UInt32)bufferSize withNumberOfChannels:(UInt32)numberOfChannels {
    
    //NSUInteger scaledAmount = fabsf(buffer[0][0] * 1000);
    
    [self.wave updateWithBuffer:buffer bufferSize:bufferSize withNumberOfChannels:numberOfChannels];
    
    // enjoy
}

#pragma mark - Navigation

- (IBAction)launchStoryBuilder:(id)sender {
    [UIView animateWithDuration:.6f delay:0 options:
     UIViewAnimationOptionCurveEaseOut animations:^{
         self.topControlsYConstraint.constant = -150;
         self.bottomViewYConstraint.constant = -500;
         [self.view layoutIfNeeded];
     } completion:nil];
    
    
    [self.bubble stickTopTopWithCompletion:^{
        UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StoryBuilder"];
        [self.navigationController pushViewController:vc animated:NO];
    }];
    
}

- (void)transitionFromStoryBuilder {
    [UIView animateWithDuration:.3f delay:0 options:
     UIViewAnimationOptionCurveEaseOut animations:^{
         [self.bubble reduceWithCompletion:nil backgroundFading:NO];
         self.topControlsYConstraint.constant = -29;
         self.bottomViewYConstraint.constant = 0;
         [self.view layoutIfNeeded];
     } completion:nil];
}

- (void)transitionFromProfile {
    [UIView animateWithDuration:.3f delay:0 options:
     UIViewAnimationOptionCurveEaseOut animations:^{
         [self.bubble reduceWithCompletion:nil backgroundFading:NO];
         self.topControlsYConstraint.constant = -29;
         self.bottomViewYConstraint.constant = 0;
         [self.view layoutIfNeeded];
     } completion:nil];
}

- (IBAction)openProfile:(id)sender {
        
    UIViewController* profile = [[UIStoryboard storyboardWithName:kStoryboardProfile bundle:nil] instantiateViewControllerWithIdentifier:@"Profile"];
    
    [profile willMoveToParentViewController:self];
    [self addChildViewController:profile];
    CGRect frame = self.view.frame;
    frame.origin.y = frame.size.height;
    profile.view.frame = frame;
    [self.view addSubview:profile.view];
    [profile didMoveToParentViewController:self];
    
    [UIView animateWithDuration:.3f delay:.2f options:
     UIViewAnimationOptionCurveEaseOut animations:^{
         [self.bubble expandWithCompletion:nil backgroundFading:NO];
         self.topControlsYConstraint.constant = -150;
         [self.view layoutIfNeeded];
         CGRect frame = profile.view.frame;
         frame.origin.y = 0;
         profile.view.frame = frame;
     } completion:nil];
}

- (IBAction)transitionToFires {
    [self.bubble expandWithCompletion:^{
        HomeViewController* parent = (HomeViewController*)self.parentViewController;
        [parent displayChildViewController:parent.groupsViewController];
    } backgroundFading:YES];
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:.5f animations:^{
//        self.bubbleCenterXConstraint.constant = self.view.frame.size.width;
        self.bottomViewYConstraint.constant = -500;
        self.topControlsYConstraint.constant = -500;
        [self.view layoutIfNeeded];
    }];
}

- (void)transitionFromFires {
    [self.bubble expand];
    [self.bubble reduceWithCompletion:^{
        self.bottomViewYConstraint.constant = -500;
        self.topControlsYConstraint.constant = -100;
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:.6f animations:^{
            self.bottomViewYConstraint.constant = 0;
            self.topControlsYConstraint.constant = -29;
            [self.view layoutIfNeeded];
        }];
    } backgroundFading:YES];
    
}

@end
