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
#import "TPSwipableViewController.h"

@interface ReviewStoryViewController : UIViewController <TPSwipableViewControllerDelegate, StoryMediaRecorderDelegate>

@property (strong, nonatomic) TPSwipableViewController* swipablePager;
@property (strong, nonatomic) StoryWIPSaver* saver;
@property (strong, nonatomic) StoryMediaRecorder* recorder;
@property NSUInteger currentIndex;
@property BOOL lastPage;

@end
