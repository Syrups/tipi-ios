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

@interface ReadModeViewController : UIViewController<FileUploaderDelegate, TPSideCommentsDelegate>
@property (nonatomic) int idx;
@property (nonatomic) Page *page;
@property (nonatomic, assign) id delegate;


@property (weak, nonatomic) IBOutlet TPSideCommentsView *commentsView;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIButton *playerView;

@property (strong, nonatomic) CommentsQueueManager *commentsQueueManager;
@property (strong, nonatomic) StoryWIPSaver* saver;
@property (strong, nonatomic) StoryMediaRecorder* recorder;

@property (nonatomic, strong) AVAudioPlayer* player;
@property (nonatomic, strong) NSTimer* audioListenTimer;

@property (strong,nonatomic) NSURL* fileURL;
@property (strong,nonatomic) NSTimer *overlayTimer;
@property (nonatomic) NSTimeInterval trueCurrentTime;



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

