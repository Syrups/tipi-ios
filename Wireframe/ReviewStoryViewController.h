//
//  ReviewStoryViewController.h
//  Wireframe
//
//  Created by Leo on 22/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryWIPSaver.h"
#import "StoryMediaRecorder.h"
#import "AudioWave.h"

@interface ReviewStoryViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, StoryMediaRecorderDelegate, EZMicrophoneDelegate>

@property (strong, nonatomic) EZMicrophone* microphone;
@property (strong, nonatomic) UIPageViewController* pageViewController;
@property (strong, nonatomic) StoryWIPSaver* saver;
@property (strong, nonatomic) StoryMediaRecorder* recorder;
@property (strong, nonatomic) IBOutlet AudioWave* audioWave;
@property NSUInteger currentIndex;
@property BOOL lastPage;

@end
