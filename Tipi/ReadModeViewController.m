//
//  ReadModeViewController.m
//  Wireframe
//
//  Created by Glenn Sonna on 05/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "Configuration.h"
#import "FileDownLoader.h"
#import "ReadModeViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>

#import <AVFoundation/AVFoundation.h>

typedef void(^fadeOutCompletion)(BOOL);

@interface ReadModeViewController ()
@end

@implementation ReadModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // View
    self.overlayView.alpha = 0;
    
    //(
    UITapGestureRecognizer *tapOnImageView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOverlayPlayer:)];
    tapOnImageView.numberOfTapsRequired = 1;
    //)
    
    self.player.delegate = self;
    
    self.view.clipsToBounds = YES;
    
    self.storyTitle.text = self.storyTitleString;
    self.pagingLabel.text = [NSString stringWithFormat:@"%d/%lu", (self.idx + 1), (unsigned long)self.totalPages];
    
    self.mediaImageView = [[TPTiltingImageView alloc] initWithFrame:self.view.frame andImage:self.mediaImage];
    
    if (self.videoUrl != nil) {
        AVURLAsset* asset = [AVURLAsset URLAssetWithURL:self.videoUrl options:nil];
        AVPlayerItem* item = [AVPlayerItem playerItemWithAsset:asset];
        self.moviePlayer = [AVPlayer playerWithPlayerItem:item];
        self.moviePlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.moviePlayer];
        self.moviePlayer.volume = .4f;
        self.moviePlayerLayer.frame = self.view.frame;
        self.moviePlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        [self.mediaImageView.layer addSublayer:self.moviePlayerLayer];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:item queue:nil usingBlock:^(NSNotification *note) {
            AVPlayerItem* item = [note object];
            [item seekToTime:kCMTimeZero];
            [self.moviePlayer play];
        }];
    }
    
    self.mediaImageView.image = self.mediaImage;
    self.mediaImageView.clipsToBounds = YES;
    self.mediaImageView.transform = CGAffineTransformMakeScale(1.2,1.2);
    
    self.mediaImageView.userInteractionEnabled = YES;
    [self.mediaImageView addGestureRecognizer:tapOnImageView];
    
    [self.view insertSubview:self.mediaImageView belowSubview:self.commentsView];
    
    //Player
    self.playerView.audioPlayer = self.player;
    self.playerView.delegate = self;
    [self.playerView appear];
    
    //Data
    //self.commentsPlayers = [NSMutableArray new];
    
    // Comment list child VC
    [self setupCommentListViewController];
    
    // Manager
    
    self.commentsView.delegate = self;
    self.commentsView.commentsQueueManager = [[CommentsQueueManager alloc] initWithDelegate:self.commentsView
                                                                                andCapacity:[self.page.comments count]];;
    // Recording
    self.commentRecorder = [[CommentAudioRecorder alloc] init];
    self.commentRecorder.delegate = self;
    
    self.storyManager = [[StoryManager alloc] initWithDelegate:self];
    
    if (self.idx == 0) {
        if ([self.page.comments count] == 0) {
            self.commentsButton.alpha = 0;
        }
        
        [self playAndTrack];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupCommentListViewController {
    self.commentsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CommentList"];
    self.commentsViewController.comments = self.page.comments;
    self.commentsViewController.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    self.commentsViewController.view.alpha = 0;
    [self addChildViewController:self.commentsViewController];
    [self.view addSubview:self.commentsViewController.view];
    [self.commentsViewController didMoveToParentViewController:self];
    self.commentsViewController.delegate = self;
}

-(void)startPreviewMode{
    
}

#pragma mark - AVAudioPlayer

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if ([player isEqual:self.player] && [self.delegate respondsToSelector:@selector(readModeViewController:didFinishReadingPage:)]) {
        [self.moviePlayer pause];
        
        [self.delegate readModeViewController:self didFinishReadingPage:self.page];
    }
}

#pragma mark - Comment list VC

- (IBAction)openCommentList:(id)sender {
    
    [self hideOverlay:nil];
    
    if (self.player.playing) {
        [self pausePage];
    }
    
    self.commentsViewController.view.frame = self.view.frame;
    [UIView animateWithDuration:.3f animations:^{
        self.commentsViewController.view.alpha = 1;
        
    } completion:^(BOOL finished) {
        [self.commentsViewController appear];
    }];
}

- (void)commentListViewController:(CommentListViewController *)viewController didSelectComment:(Comment *)comment {
    
}

#pragma mark - Side Comments View
- (void)sideCommentsView:(TPSideCommentsView *)manager didSelectedComment:(Comment *)comment withFile:(NSString *)fileUrl{
    
}

- (void)sideCommentsView:(TPSideCommentsView *)manager didDeselectedComment:(Comment *)comment withFile:(NSString *)fileUrl{
    
}

#pragma mark - Overlay View
- (void)showOverlayPlayer:(UITapGestureRecognizer *)recognizer {
    
    //CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    [self.overlayTimer invalidate];
    
    self.topBarYConstraint.constant = -100;
    self.commentsButtonYConstraint.constant = -100;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.overlayView.alpha = self.overlayView.alpha == 0 ? 1.0 : 0;
        self.topBarYConstraint.constant = -20;
        self.commentsButtonYConstraint.constant = 30;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.overlayTimer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(hideOverlay:) userInfo:nil
                                                   repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:self.overlayTimer forMode:NSRunLoopCommonModes];
    }];
}

- (void)hideOverlay:(NSTimer *)timer{
    
    [UIView animateWithDuration:.3f delay:0 options:0 animations:^{
        self.overlayView.alpha = 0;
        self.topBarYConstraint.constant = -100;
        self.commentsButtonYConstraint.constant = -100;
        [self.view layoutIfNeeded];
    } completion:nil];
}

#pragma mark - Sound Playing
- (IBAction)quitStory:(id)sender {
    [self.player fadeOutAndStop];
    [self.delegate readModeViewController:self requestedToQuitStoryAtPage:self.page];
}

- (IBAction)playSound:(id)sender {
    if(self.player){
        if(self.player.isPlaying){
            [self pausePage];
        }
        else{
            [self playAndTrack];
        }
    }
}

-(void)stopPage{
    //NSLog(@"stopPage %d", self.idx);
    //[self.player fadeOutAndStop];
    [self.player stop];
    [self.audioListenTimer invalidate];
    self.audioListenTimer = false;
}

- (void)pausePage{
     //NSLog(@"pausePage %d", self.idx);
    if(self.player  && self.player.isPlaying){
        [self.audioListenTimer invalidate];
        [self.player fadeOutPause];
        if(self.moviePlayer)[self.moviePlayer pause];
        
    }
}

- (void)playAndTrack{
    //NSLog(@"playAndTrack %d", self.idx);
    [self.playerView play];
    if(self.moviePlayer)[self.moviePlayer play];
    
    self.audioListenTimer = [NSTimer
                             scheduledTimerWithTimeInterval:0.1
                             target:self selector:@selector(listenForComment:)
                             userInfo:nil repeats:YES];
}

#pragma mark - Sound Tracking

- (void)listenForComment:(NSTimer*)timer{
    
    double currentPlayerTime = round(self.player.currentTime);
    
    //NSLog(@"__________________________%f/%f___________________________________", currentPlayerTime, self.player.duration);
    
    [self.page.comments enumerateObjectsUsingBlock:^(Comment* comment, NSUInteger idx, BOOL *stop) {
        //NSLog(@"__________________________|%f", comment.timecode);
        
        if(comment.timecode == currentPlayerTime){
            [self.commentsView.commentsQueueManager pushComment:comment  atIndex:idx];
        }
    }];
}


+(Comment*)mockCommentForIndex:(NSInteger)index{
    
    //int randIndex = arc4random() % [mockNames count];
    
    NSArray* mockNames = @[@"Anne", @"Andy", @"France", @"Marc"];
    NSArray* mockIds= @[@1234, @7654, @98745, @3];
    
    User* user = [User new];
    user.username = [mockNames objectAtIndex: index];
    user.id = [mockIds objectAtIndex: index];
    
    Comment* comment = [Comment new];
    comment.file = [NSString stringWithFormat:@"com %d", index];
    comment.user = user;
    return comment;
    
}

#pragma mark - Sound Tracking

- (void)circleWaverControl:(TPCircleWaverControl *)control didReceveivedLongPressGestureRecognizer:(UILongPressGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        NSLog(@"begin touch");
        
        [self.overlayTimer invalidate];
        [self.moviePlayer pause];
        [self.playerView pauseWithFade:YES];
        self.commentTime = self.player.currentTime;
        
        self.playerView.microphone = self.commentRecorder.microphone;
        self.playerView.nowRecording = YES;
        [self.commentRecorder startRecording];
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"ended touch");
        
        [self.commentRecorder stopRecording];
        
        AVAudioPlayer* avAudioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:[self.commentRecorder pathForAudioFile]] error:nil];
        
        double duration = avAudioPlayer.duration;
        avAudioPlayer = nil;
        
        NSLog(@"%f seconds", duration);
        
        [self.playerView pauseWithFade:NO];
        self.playerView.nowRecording = NO;
        [self.storyManager addCommentOnPage:self.page atTime:self.commentTime duration:(int)duration withAudioFile:[self.commentRecorder pathForAudioFile]];
    }
}

#pragma mark - StoryManager
- (void)storyManager:(StoryManager *)manager successfullyCreatedComment:(Comment *)story{
    [TPAlert displayOnController:self withMessage:NSLocalizedString(@"Votre commentaire à été enregistré avec succès !", nil) delegate:self];
}

- (void)storyManagerFailedToCreateComment:(StoryManager *)manager{
    [TPAlert displayOnController:self withMessage:NSLocalizedString(@"Votre commentaire n'a pu être enregistré, veuillez réessayer", nil) delegate:self];
}

- (void)alertDidAknowledge:(TPAlert *)alert{
    self.playerView.mode = TPCircleModeListen;
    self.playerView.nowRecording = NO;
    [self.playerView play];
}

#pragma mark - TPCircleWaverControl
- (void)circleWaverControl:(TPCircleWaverControl *)control didReceveivedTapGestureRecognizer:(UITapGestureRecognizer *)recognizer{
    if(control.audioPlayer.isPlaying){
        [control pauseWithFade:YES];
    }else{
        [control play];
    }
}

-(void)circleWaverControl:(TPCircleWaverControl *)control didEndRecordingWithMicrophone:(EZMicrophone *)microphone{
}


#pragma mark - CommentAudioRecorder
- (void)commentRecorder:(CommentAudioRecorder *)recorder didFinishPlayingAudioAtIndex:(NSUInteger)index{
}

- (void)commentRecorder:(CommentAudioRecorder *)recorder hasAudioReceived:(float **)buffer withBufferSize:(UInt32)bufferSize withNumberOfChannels:(UInt32)numberOfChannels{
}


#pragma mark - TPSideCommentsView
- (void)sideCommentsView:(TPSideCommentsView *)manager didSelectComment :(Comment*)comment{
    [self pausePage];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:[songPlayer currentItem]];
}

- (void)sideCommentsView:(TPSideCommentsView *)manager didDeselectComment:(Comment*)comment{
    [self playAndTrack];
}

- (void)sideCommentsView:(TPSideCommentsView *)manager comment:(Comment *)comment didFinishedPlaying:(BOOL)finished{
    if (finished && self.player.currentTime < self.player.duration) {
        [self playAndTrack];
    }
}

/*- (void)playAtIndex:(NSInteger)index
 {
 [self.commentsPlayer removeAllItems];
 for (int i = index; i <playerItems.count; i ++) {
 AVPlayerItem* obj = [playerItems objectAtIndex:i];
 if ([self.commentsPlayer canInsertItem:obj afterItem:nil]) {
 [obj seekToTime:kCMTimeZero];
 [self.commentsPlayer insertItem:obj afterItem:nil];
 }
 }
 }*/

/*
 - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
 
 if (object == self.simplePlayer  && [keyPath isEqualToString:@"status"]) {
 if (self.simplePlayer .status == AVPlayerStatusFailed) {
 NSLog(@"AVPlayer Failed");
 
 } else if (self.simplePlayer.status == AVPlayerStatusReadyToPlay && self.autoStart) {
 NSLog(@"AVPlayerStatusReadyToPlay");
 [self.simplePlayer  play];
 
 
 } else if (self.simplePlayer.status == AVPlayerItemStatusUnknown) {
 NSLog(@"AVPlayer Unknown");
 }
 }
 }
 
 - (void)simplerPlayerItemDidReachEnd:(NSNotification *)notification {
 
 }*/

@end
