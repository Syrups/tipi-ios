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
#import "AVAudioPlayer+AVAudioPlayer_Fading.h"

@interface ReadModeViewController : CardViewController<TPSideCommentsDelegate, TPCircleTouchDelegate, CommentCreatorDelegate, CommentAudioRecorderDelegate, TPAlertDelegate, CommentListViewControllerDelegate, AVAudioPlayerDelegate>


@property (nonatomic) int idx;
@property (nonatomic) Page *page;
@property (nonatomic, assign) id delegate;

@property (nonatomic) NSString *storyTitleString;
@property (nonatomic) NSUInteger totalPages;

@property (weak, nonatomic) IBOutlet UILabel* storyTitle;
@property (weak, nonatomic) IBOutlet UIImage *mediaImage;
@property (strong, nonatomic) NSURL* videoUrl;
@property (strong, nonatomic) AVPlayer* moviePlayer;
@property (strong, nonatomic) AVPlayerLayer* moviePlayerLayer;
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UILabel *pagingLabel;

@property (strong, nonatomic) IBOutlet TPSideCommentsView *commentsView;
@property (strong, nonatomic) IBOutlet TPCircleWaverControl *playerView;
@property (strong, nonatomic) TPTiltingImageView *mediaImageView;
@property (strong, nonatomic) IBOutlet UIButton* commentsButton;
@property (strong, nonatomic) CommentAudioRecorder* commentRecorder;

@property (strong, nonatomic) StoryWIPSaver* saver;

@property (strong, nonatomic) StoryManager* storyManager;


@property (nonatomic, strong) AVAudioPlayer* player;
@property (nonatomic, strong) NSTimer* audioListenTimer;

@property (strong,nonatomic) NSURL* fileURL;
@property (strong,nonatomic) NSTimer *overlayTimer;
@property (nonatomic) NSTimeInterval commentTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* topBarYConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* commentsButtonYConstraint;

@property (strong, nonatomic) CommentListViewController* commentsViewController;


- (IBAction)quitStory:(id)sender;
- (IBAction)playSound:(id)sender;

- (void)stopPage;
- (void)pausePage;
- (void)playAndTrack;


@end


@protocol ReadModeViewDelegate <NSObject>

@optional
- (void)readModeViewController:(ReadModeViewController *)controller didFinishReadingPage: (Page*) page;
@required
- (void)readModeViewController:(ReadModeViewController *)controller requestedToQuitStoryAtPage: (Page*) page;
@end

