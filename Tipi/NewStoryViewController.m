//
//  NewStoryViewController.m
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "NewStoryViewController.h"
#import "HomeViewController.h"
#import "StoryWIPSaver.h"
#import "ImageUtils.h"
#import "SHPathLibrary.h"
#import "AnimationLibrary.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface NewStoryViewController ()

@end

@implementation NewStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MediaLibrary* library = [[MediaLibrary alloc] init];
    library.delegate = self;
    [library fetchMediasFromLibrary];
    
    [self setupTitle];
    
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

#pragma mark - Helpers

- (void)setupTitle {
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineSpacing:6];

    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, self.titleLabel.text.length)];
    
    self.titleLabel.attributedText = attrString;
}



#pragma mark - EZMicrophone

- (void)microphone:(EZMicrophone *)microphone hasAudioReceived:(float **)buffer withBufferSize:(UInt32)bufferSize withNumberOfChannels:(UInt32)numberOfChannels {
    
    //NSUInteger scaledAmount = fabsf(buffer[0][0] * 1000);
    
    [self.wave updateWithBuffer:buffer bufferSize:bufferSize withNumberOfChannels:numberOfChannels];
    
    // enjoy
}


#pragma mark - MediaLibrary

- (void)mediaLibrary:(MediaLibrary *)library successfullyFetchedMedias:(NSArray *)medias {
    
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSUInteger randomIndex = arc4random() % [medias count];
            NSDictionary* media = [medias objectAtIndex:randomIndex];
            ALAsset* asset = (ALAsset*)[media objectForKey:@"asset"];
            UIImage* full = [ImageUtils convertImageToGrayScale:[UIImage imageWithCGImage:[[asset defaultRepresentation]fullScreenImage]]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.image = full;
                imageView.layer.opacity = .1f;
                [self.bubble.layer addSublayer:imageView.layer];
                
            });
        });
    });
    
}

#pragma mark - Navigation

- (IBAction)launchStoryBuilder:(id)sender {
    
    [self.bubble stickTopTopWithCompletion:nil];

    [UIView animateWithDuration:.3f delay:0 options:
     UIViewAnimationOptionCurveEaseOut animations:^{
         self.topControlsYConstraint.constant = -150;
         self.bottomViewYConstraint.constant = -200;
         [self.view layoutIfNeeded];
     } completion:^(BOOL finished) {
         UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StoryBuilder"];
         [self.navigationController pushViewController:vc animated:NO];
     }];
    
}

- (void)transitionFromStoryBuilder {
    [self.bubble expandWithCompletion:nil backgroundFading:NO];
    [UIView animateWithDuration:.3f delay:0 options:
     UIViewAnimationOptionCurveEaseOut animations:^{
         self.topControlsYConstraint.constant = -29;
         self.bottomViewYConstraint.constant = 0;
         [self.view layoutIfNeeded];
     } completion:nil];
}

- (void)transitionFromProfile {
    [UIView animateWithDuration:.3f delay:0 options:
     UIViewAnimationOptionCurveEaseOut animations:^{
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
    
    [UIView animateWithDuration:.3f delay:0 options:
     UIViewAnimationOptionCurveEaseOut animations:^{
         self.topControlsYConstraint.constant = -150;
         [self.view layoutIfNeeded];
         CGRect frame = profile.view.frame;
         frame.origin.y = 0;
         profile.view.frame = frame;
     } completion:nil];
}

- (IBAction)transitionToFires {
    
    [self.bubble expandWithCompletion:nil backgroundFading:YES];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:.3f animations:^{
//        self.bubbleCenterXConstraint.constant = self.view.frame.size.width;
        self.bottomViewYConstraint.constant = -200;
        self.topControlsYConstraint.constant = -200;
        self.titleLabel.alpha = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        HomeViewController* parent = (HomeViewController*)self.parentViewController;
        [parent displayChildViewController:parent.groupsViewController];
    }];
}

- (void)transitionFromFires {

    self.bottomViewYConstraint.constant = -200;
    self.topControlsYConstraint.constant = -100;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:.4f animations:^{
        self.titleLabel.alpha = 1;
        self.bottomViewYConstraint.constant = 0;
        self.topControlsYConstraint.constant = -29;
        [self.view layoutIfNeeded];
    }];
    
}

@end
