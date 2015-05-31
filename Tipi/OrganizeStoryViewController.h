//
//  OrganizeStoryViewController.h
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXReorderableCollectionViewFlowLayout.h"
#import "StoryWIPSaver.h"
#import "StoryMediaRecorder.h"
#import "OrganizerWave.h"

#define CELL_SIZE 190
#define INACTIVE_CELL_OPACITY 0.3f
#define ACTIVE_CELL_ROTATION 0.05f

@interface OrganizeStoryViewController : UIViewController <LXReorderableCollectionViewDataSource, UICollectionViewDelegate, LXReorderableCollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@property (strong, nonatomic) StoryWIPSaver* saver;
@property (strong, nonatomic) StoryMediaRecorder* recorder;
@property (strong, nonatomic) IBOutlet UICollectionView* collectionView;
@property (strong, nonatomic) IBOutlet UILabel* pageLabel;
@property (strong, nonatomic) IBOutlet OrganizerWave* wave;
@property (strong, nonatomic) IBOutlet UIButton* replayButton;
@property (strong, nonatomic) IBOutlet UIButton* finishButton;
@property (strong, nonatomic) UIViewController* donePopin;
@property (strong, nonatomic) UIViewController* namePopin;
@property (strong, nonatomic) IBOutlet UIView* overlay;
@property (strong, nonatomic) IBOutlet UILabel* helpLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* topControlsYConstraint;

- (void)animateAppearance;

@end
