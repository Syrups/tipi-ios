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


@interface RecordViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate, EZMicrophoneDelegate, StoryMediaRecorderDelegate>

@property NSUInteger currentIndex;
@property (strong, nonatomic) UIPageViewController* pageViewController;
@property (strong, nonatomic) NSMutableArray* pages;
@property (strong, nonatomic) IBOutlet UIButton* recordButton;
@property (strong, nonatomic) IBOutlet UIView* eraseWarning;
@property (strong, nonatomic) IBOutlet SRRecordButton* recordTimer;
@property (strong, nonatomic) IBOutlet UIView* replay;
@property (strong, nonatomic) StoryWIPSaver* saver;
@property (strong, nonatomic) StoryMediaRecorder* recorder;
@property (strong, nonatomic) EZAudioPlotGL* audioPlot;

@property BOOL lastPage;


@end
