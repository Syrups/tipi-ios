//
//  ShowOneGroupViewController.h
//  Wireframe
//
//  Created by Glenn Sonna on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRRecordButton.h"
#import "Room.h"
#import "StoryManager.h"
#import "ReadModeContainerViewController.h"
#import "TPAlert.h"

@import AVFoundation;

@interface ShowOneGroupViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate,StoryFetcherDelegate, ReadModeContainerDelegate, TPAlertDelegate>

//@property (nonatomic) NSUInteger roomId;
@property (strong, nonatomic) Room* room;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@property (strong, nonatomic)  NSArray *mStories;
@property (strong, nonatomic) IBOutlet UIButton* roomNameButton;
@property (strong, nonatomic) User* filterUser;
@property (strong, nonatomic) NSString* filterTag;
@property (strong, nonatomic) AVPlayer *previewAudioPlayer;

@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@property (nonatomic) BOOL isPreviewMode;

@property (weak, nonatomic) IBOutlet UIView *readContainer;
@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBarTopConstraint;
@property (weak, nonatomic) ReadModeContainerViewController *readModeContainer;

@property (strong, nonatomic) IBOutlet UIView* nameArrow;
@property (strong, nonatomic) IBOutlet UILabel* errorLabel;
@property (weak, nonatomic) NSIndexPath *currentIndexPath;

- (void)applyFilters;
- (IBAction)deleteStory:(id)sender;

@end
