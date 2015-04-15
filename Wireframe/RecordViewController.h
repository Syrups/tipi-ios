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
#import "AudioWave.h"
#import "PreviewBubble.h"

@interface RecordViewController : UIViewController <EZMicrophoneDelegate, StoryMediaRecorderDelegate, UIGestureRecognizerDelegate>

@property NSUInteger currentIndex;
@property (strong, nonatomic) IBOutlet UIButton* recordButton;
@property (strong, nonatomic) IBOutlet UIView* eraseWarning;
@property (strong, nonatomic) IBOutlet SRRecordButton* recordTimer;
@property (strong, nonatomic) IBOutlet UIView* replay;
@property (strong, nonatomic) StoryWIPSaver* saver;
@property (strong, nonatomic) StoryMediaRecorder* recorder;
@property (strong, nonatomic) IBOutlet AudioWave* audioWave;
@property (strong, nonatomic) IBOutlet PreviewBubble* previewBubble;

@property BOOL lastPage;


@end
