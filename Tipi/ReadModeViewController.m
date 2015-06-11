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

@import AVFoundation;

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
    
    if(self.idx == 0){
        [self playSound];
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
        [self.delegate readModeViewController:self didFinishReadingPage:self.page];
    }
}

#pragma mark - Comment list VC

- (IBAction)openCommentList:(id)sender {
    
    [self hideOverlay:nil];
    
    if (self.player.playing)
        [self pauseSound];
    
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
    
    [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.overlayView.alpha = self.overlayView.alpha == 0 ? 1.0 : 0;
    } completion:^(BOOL finished) {
        self.overlayTimer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(hideOverlay:) userInfo:nil
                                                   repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:self.overlayTimer forMode:NSRunLoopCommonModes];
    }];
}

- (void)hideOverlay:(NSTimer *)timer{
    
    [UIView animateWithDuration:.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.overlayView.alpha = 0;
    } completion:nil];
}

#pragma mark - Sound Playing
- (IBAction)quitStory:(id)sender {
//    [self doVolumeFadeAndStop];
    [self.player stop];
    [self.delegate readModeViewController:self requestedToQuitStoryAtPage:self.page];
}

- (IBAction)playSound:(id)sender {
    if(self.player){
        NSLog(@"play");
        [self playSound];
    }
}

- (void)playSound{
    if(self.player.isPlaying){
        [self doVolumeFadeAndPause];
    }
    else{
        [self playAndTrack];
    }
}

- (void)pauseSound{
    if(self.player != nil){
        if(self.player.isPlaying){
            [self doVolumeFadeAndPause];
            //TODO pauseComment
        }
    }
}

- (void)playAndTrackAtTime:(NSTimeInterval) time{
    [self.player playAtTime:time];
    self.audioListenTimer = [NSTimer
                             scheduledTimerWithTimeInterval:0.1
                             target:self selector:@selector(listenForComment:)
                             userInfo:nil repeats:YES];
}

- (void)playAndTrack{
    [self.player play];
    self.audioListenTimer = [NSTimer
                             scheduledTimerWithTimeInterval:0.1
                             target:self selector:@selector(listenForComment:)
                             userInfo:nil repeats:YES];
}


#pragma mark - Sound Playing/Processing

-(void)doVolumeFadeAndStop{
    [self doVolumeFade:^(BOOL stop) {
        // Stop and get the sound ready for playing again
        [self.player stop];
        self.player.currentTime = 0;
        self.trueCurrentTime = 0;
        
        [self.player prepareToPlay];
        self.player.volume = 1.0;
    }];
}

-(void)doVolumeFadeAndPause{
    self.trueCurrentTime = self.player.currentTime;
    [self doVolumeFade:^(BOOL stop)  {
        // Stop and get the sound ready for playing again
        [self.playerView pause];
        [self.player pause];
        [self.player prepareToPlay];
        self.player.volume = 1.0;
    }];
}

-(void)doVolumeFade: (fadeOutCompletion) completion{
    if (self.player.volume > 0.1) {
        self.player.volume = self.player.volume - 0.1;
        [self performSelector:@selector(doVolumeFade:) withObject:completion afterDelay:0.1];
    } else {
        completion(YES);
    }
}


#pragma mark - Sound Tracking

- (void)listenForComment:(NSTimer*)timer{
    //[self updateDisplay];
    
    double currentPlayerTime = round(self.player.currentTime);
    
    //self.page.comments = @[@6.582200, @7.739955];
    //NSArray *mockComment = @[@1.344, @6.582200, @7.739955];
    
    //NSLog(@"__________________________%f/%f___________________________________", currentPlayerTime, self.player.duration);
    
    for ( int i = 0; i < self.page.comments.count; i++) {
         Comment* comment = [self.page.comments objectAtIndex:i];
    
        //NSLog(@"__________________________|%f", comment.timecode);

        if(comment.timecode == currentPlayerTime){
            
            /*User* user = [User new];
            user.username = @"Alceste";
            user.id = @"1234";
            
            comment.user = user;*/
            
            [self.commentsView.commentsQueueManager pushInQueueComment:comment  atIndex:i];
        }
    }
}


+(Comment*)mockCommentForIndex:(NSInteger)index{
    
    //int randIndex = arc4random() % [mockNames count];

    NSArray* mockNames = @[@"Anne", @"Andy", @"France", @"Marc"];
    NSArray* mockIds= @[@1234, @7654, @98745, @3];
    
    User* user = [User new];
    user.username = [mockNames objectAtIndex: index];
    user.id = [mockIds objectAtIndex: index];
    
    Comment* comment = [Comment new];
    comment.file = [NSString stringWithFormat:@"com %ld", index];
    comment.user = user;
    return comment;

}

#pragma mark - Sound Tracking

- (void)circleWaverControl:(TPCircleWaverControl *)control didReceveivedLongPressGestureRecognizer:(UILongPressGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
         NSLog(@"begin touch");
        
        [self.overlayTimer invalidate];
        [self.playerView pause];
        self.commentTime = self.player.currentTime;
        
        self.playerView.microphone = self.commentRecorder.microphone;
        self.playerView.nowRecording = YES;
        [self.commentRecorder startRecording];
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"ended touch");
        [self.commentRecorder stopRecording];
        [self.storyManager addCommentOnPage:self.page atTime:self.commentTime withAudioFile:[self.commentRecorder pathForAudioFile]];
    }
}

#pragma mark - StoryManager
- (void)storyManager:(StoryManager *)manager successfullyCreatedComment:(Comment *)story{
    [TPAlert displayOnController:self withMessage:@"Votre commentaire à été enregistré avec succès !" delegate:self];
}

- (void)storyManagerFailedToCreateComment:(StoryManager *)manager{
    [TPAlert displayOnController:self withMessage:@"Votre commentaire n'a pu être enregistré, veuillez réessayer" delegate:self];
}

- (void)alertDidAknowledge:(TPAlert *)alert{
    self.playerView.mode = TPCircleModeListen;
    self.playerView.nowRecording = NO;
    [self.playerView play];
}

#pragma mark - TPCircleWaverControl
- (void)circleWaverControl:(TPCircleWaverControl *)control didReceveivedTapGestureRecognizer:(UITapGestureRecognizer *)recognizer{
    if(control.audioPlayer.isPlaying){
        [control pause];
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
    [self doVolumeFadeAndPause];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:[songPlayer currentItem]];
}

- (void)sideCommentsView:(TPSideCommentsView *)manager didDeselectComment:(Comment*)comment{
    [self.playerView play];
}

- (void)sideCommentsView:(TPSideCommentsView *)manager comment:(Comment *)comment didFinishedPlaying:(BOOL)finished{
    if (finished && self.player.currentTime < self.player.duration) {
        [self playSound];
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
