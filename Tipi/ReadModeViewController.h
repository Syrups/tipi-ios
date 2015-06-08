//
//  ReadModeViewController.h
//  Wireframe
//
//  Created by Glenn Sonna on 05/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Page.h"


#import "TPSideCommentsView.h"

#import "FileUploader.h"
#import "StoryWIPSaver.h"
#import "StoryMediaRecorder.h"
#import "CommentAudioRecorder.h"
#import "TPCircleWaverControl.h"
#import "CardViewController.h"
#import "StoryManager.h"
#import "CommentListViewController.h"

#import "TPAlert.h"
#import "TPTiltingImageView.h"

@interface ReadModeViewController : CardViewController<FileUploaderDelegate, TPSideCommentsDelegate, TPCircleTouchDelegate, CommentCreatorDelegate, CommentAudioRecorderDelegate, TPAlertDelegate>
@property (nonatomic) int idx;
@property (strong, nonatomic) IBOutlet UILabel* storyTitle;
@property (strong, nonatomic) IBOutlet UILabel* storyPageCount;
@property (nonatomic) Page *page;
@property (nonatomic, assign) id delegate;


@property (weak, nonatomic) IBOutlet TPSideCommentsView *commentsView;

@property (strong, nonatomic)  TPTiltingImageView *mediaImageView;
@property (weak, nonatomic) IBOutlet UIImage *mediaImage;
@property (weak, nonatomic) IBOutlet UIView *overlayView;

@property (weak, nonatomic) IBOutlet TPCircleWaverControl *playerView;

@property (strong, nonatomic) CommentAudioRecorder* commentRecorder;
@property (strong, nonatomic) CommentsQueueManager *commentsQueueManager;
@property (strong, nonatomic) StoryWIPSaver* saver;

@property (strong, nonatomic) StoryManager* storyManager;


@property (nonatomic, strong) AVAudioPlayer* player;
@property (nonatomic, strong) NSTimer* audioListenTimer;

@property (strong,nonatomic) NSURL* fileURL;
@property (strong,nonatomic) NSTimer *overlayTimer;
@property (nonatomic) NSTimeInterval trueCurrentTime;
@property (nonatomic) NSTimeInterval commentTime;
@property (strong, nonatomic) NSMutableArray *commentsPlayers;

@property (strong, nonatomic) CommentListViewController* commentsViewController;


- (IBAction)quitStory:(id)sender;

- (IBAction)playSound:(id)sender;
- (void)pauseSound;


@end


@protocol ReadModeViewDelegate <NSObject>

@optional
- (void)readModeViewController:(ReadModeViewController *)controller didFinishReadingPage: (Page*) page;
@required
- (void)readModeViewController:(ReadModeViewController *)controller requestedToQuitStoryAtPage: (Page*) page;
@end

