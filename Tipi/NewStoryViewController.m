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
#import "TPLoader.h"
#import "TPTiltingImageView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "TPAlert.h"
#import <UIView+MTAnimation.h>

#define RANDOM_IMAGES_COUNT 5

@implementation NewStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTitle];
    
    
    self.view.alpha = 0;
    
//    self.microphone = [[EZMicrophone alloc] initWithMicrophoneDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

//    [self.microphone stopFetchingAudio];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self transitionFromFires];
    
    MediaLibrary* library = [[MediaLibrary alloc] init];
    library.delegate = self;
    [library fetchMediasFromLibrary];
    
//    [self reloadBackgroundImage];
    
    if ([[StoryWIPSaver sharedSaver] saved]) {
        [self.mainButton setTitle:@"Continue story" forState:UIControlStateNormal];
        self.secondaryButton.hidden = NO;
    }
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

- (IBAction)reloadBackgroundImage {
    
    if (self.randomMedias == nil) return;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSUInteger randomIndex = arc4random() % ([self.randomMedias count] - 1);
        NSDictionary* media = [self.randomMedias firstObject];
        ALAsset* asset = (ALAsset*)[media objectForKey:@"asset"];
        UIImage* full = [ImageUtils convertImageToGrayScale:[UIImage imageWithCGImage:[[asset defaultRepresentation]fullScreenImage]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
            imageView.image = full;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.opacity = .05f;
            [self.bubble replaceImageLayerWithLayer:imageView.layer];
            
            [self.view sendSubviewToBack:self.bubble];
            
            self.titleLabel.alpha = 0;
            self.titleLabel.transform = CGAffineTransformMakeTranslation(0, 80);
            self.bottom.transform = CGAffineTransformMakeTranslation(0, self.bottom.frame.size.height);

            [UIView animateWithDuration:.3f animations:^{
                self.view.alpha = 1;
                self.titleLabel.alpha = 1;
            } completion:nil];
            
            [UIView mt_animateWithViews:@[self.bottom, self.titleLabel] duration:.5f delay:0 timingFunction:kMTEaseOutBack animations:^{
                self.titleLabel.transform = CGAffineTransformIdentity;
                self.bottom.transform = CGAffineTransformIdentity;
            } completion:nil];
        });
    });
    
}

#pragma mark - EZMicrophone

- (void)microphone:(EZMicrophone *)microphone hasAudioReceived:(float **)buffer withBufferSize:(UInt32)bufferSize withNumberOfChannels:(UInt32)numberOfChannels {
    
    //NSUInteger scaledAmount = fabsf(buffer[0][0] * 1000);
    
    // enjoy
}


#pragma mark - MediaLibrary

- (void)mediaLibrary:(MediaLibrary *)library successfullyFetchedMedias:(NSArray *)medias {
    
    if ([medias count] > RANDOM_IMAGES_COUNT) {
        self.randomMedias = [medias subarrayWithRange:NSMakeRange(0, RANDOM_IMAGES_COUNT)];
    } else {
        self.randomMedias = medias;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self reloadBackgroundImage];
    });
}

- (void)mediaLibrary:(MediaLibrary *)library failedToFetchMediasWithError:(NSError *)error {
    [TPAlert displayOnController:self withMessage:@"Vous devez d'abord autoriser l'application à accéder à vos photos" delegate:nil];
}

#pragma mark - Navigation

- (IBAction)launchStoryBuilder:(id)sender {
    
    [self.bubble stickTopTopWithCompletion:^{
        UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StoryBuilder"];
        UINavigationController* storyBuilderNav = [self.storyboard instantiateViewControllerWithIdentifier:@"StoryBuilderNav"];
        UIViewController* picker = [self.storyboard instantiateViewControllerWithIdentifier:@"MediaPicker"];
        
        [vc addChildViewController:storyBuilderNav];
        storyBuilderNav.view.frame = vc.view.frame;
        [vc.view addSubview:storyBuilderNav.view];
        [vc.view sendSubviewToBack:storyBuilderNav.view];
        [storyBuilderNav didMoveToParentViewController:vc];
        
        
//
        [storyBuilderNav setViewControllers:@[picker]];
//

//        [picker.view sendSubviewToBack:self.bubble];
//
        [self.navigationController pushViewController:vc animated:NO];
    }];

    [UIView animateWithDuration:.4f delay:0 options:
     UIViewAnimationOptionCurveEaseOut animations:^{
         self.topControlsYConstraint.constant = -150;
         self.bottomViewYConstraint.constant = -200;
         self.titleLabel.alpha = 0;
         [self.view layoutIfNeeded];
     } completion:nil];
    
}

- (void)transitionFromStoryBuilder {
    [self.bubble expandWithCompletion:nil backgroundFading:NO];
    [UIView animateWithDuration:.3f delay:0 options:
     UIViewAnimationOptionCurveEaseOut animations:^{
         self.topControlsYConstraint.constant = -29;
         self.bottomViewYConstraint.constant = 0;
         self.titleLabel.alpha = 1;
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
    
    self.titleLabel.transform = CGAffineTransformMakeTranslation(0, 150);
    self.bottom.transform = CGAffineTransformMakeTranslation(0, self.bottom.frame.size.height + 50);
    
    [UIView mt_animateWithViews:@[self.bottom, self.titleLabel] duration:.6f delay:0 timingFunction:kMTEaseOutBack animations:^{
        self.titleLabel.transform = CGAffineTransformIdentity;
        self.bottom.transform = CGAffineTransformIdentity;
    } completion:nil];
    
    [UIView animateWithDuration:.3f animations:^{
        self.titleLabel.alpha = 1;
        self.bottomViewYConstraint.constant = 0;
        self.topControlsYConstraint.constant = -29;
        [self.view layoutIfNeeded];
    }];
    
}


@end
