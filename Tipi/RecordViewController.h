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

@interface RecordViewController : UIViewController <EZMicrophoneDelegate, StoryMediaRecorderDelegate, UIGestureRecognizerDelegate>

@property NSUInteger currentIndex;
@property (strong, nonatomic) OrganizeStoryViewController* organizeViewController;
@property (strong, nonatomic) IBOutlet SRRecordButton* recordTimer;
@property (strong, nonatomic) StoryWIPSaver* saver;
@property (strong, nonatomic) StoryMediaRecorder* recorder;
@property (strong, nonatomic) IBOutlet UIButton* replayButton;
@property (strong, nonatomic) UILongPressGestureRecognizer* longPressRecognizer;
@property (strong, nonatomic) IBOutlet UIView* overlay;
@property (strong, nonatomic) UIViewController* donePopin;
@property (strong, nonatomic) UIViewController* namePopin;
@property (strong, nonatomic) IBOutlet UIImageView* coachmarkSprite;
@property (strong, nonatomic) IBOutlet UILabel* helpLabel;

@property BOOL lastPage;

- (void)openNameStoryPopin;

@end
