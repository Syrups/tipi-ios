//
//  OrganizeStoryViewController.h
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryWIPSaver.h"
#import "StoryMediaRecorder.h"
#import "OrganizerWave.h"
#import "Tipi-Swift.h"

#define CELL_SIZE 120
#define INACTIVE_CELL_OPACITY 0.3f
#define ACTIVE_CELL_ROTATION 0.05f

@interface OrganizeStoryViewController : UIViewController <UIGestureRecognizerDelegate, RAReorderableLayoutDataSource, RAReorderableLayoutDelegate>

@property (strong, nonatomic) StoryWIPSaver* saver;
@property (strong, nonatomic) StoryMediaRecorder* recorder;
@property (strong, nonatomic) IBOutlet UICollectionView* collectionView;

@end
