//
//  RecordViewController.h
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EZAudio/EZAudio.h>
#import "StoryWIPSaver.h"
#import "StoryMediaRecorder.h"
#import "SRRecordButton.h"
#import "OrganizeStoryViewController.h"
#import "TPSwipableViewController.h"
#import "RecordPageViewController.h"

@interface RecordViewController : UIViewController <EZMicrophoneDelegate, StoryMediaRecorderDelegate, UIGestureRecognizerDelegate, TPSwipableViewControllerDelegate>

@property NSUInteger currentIndex;
@property (strong, nonatomic) TPSwipableViewController* swipablePager;
@property (strong, nonatomic) OrganizeStoryViewController* organizeViewController;
@property (strong, nonatomic) StoryWIPSaver* saver;
@property (strong, nonatomic) StoryMediaRecorder* recorder;
@property (strong, nonatomic) UILongPressGestureRecognizer* longPressRecognizer;
@property (strong, nonatomic) UIViewController* donePopin;
@property (strong, nonatomic) UIViewController* namePopin;
@property (strong, nonatomic) IBOutlet UIImageView* coachmarkSprite;
@property (strong, nonatomic) IBOutlet UILabel* helpLabel;
@property (strong, nonatomic) IBOutlet UIView* organizerContainerView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* organizerContainerYConstraint;

@property BOOL lastPage;

- (RecordPageViewController*)currentPage;
- (void)openNameStoryPopin;
- (void)moveViewControllerfromIndex:(NSUInteger)oldIndex atIndex:(NSUInteger)newIndex;


@end
