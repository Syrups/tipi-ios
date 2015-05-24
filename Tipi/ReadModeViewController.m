//
//  ReadModeViewController.m
//  Wireframe
//
//  Created by Glenn Sonna on 05/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "Configuration.h"
#import "ReadModeViewController.h"

#import "FileDownLoader.h"

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
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressRecognizer.minimumPressDuration = .5f;
    //)
    
    self.image.userInteractionEnabled = YES;
    [self.image addGestureRecognizer:tapOnImageView];
    
    [self.playerView addGestureRecognizer:longPressRecognizer];
    
    //Files
    NSString* url = self.page.media.file;
    NSString* fileUrl = self.page.audio.file;
    
    //TODO change placeholder and loadings
    [self.image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholder.gif"]];
    [FileDownLoader downloadFileWithURL:fileUrl completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        self.fileURL = filePath;
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.fileURL error:nil];
        
        if(self.idx <= 0){
            [self playAndTrack];
        }
        //NSLog(@"File %@ downloaded to: %@",fileUrl, filePath);
    }];
    
    //Data
    self.commentsPlayers = [NSMutableArray new];
    
    // Manager
    self.commentsView.delegate = self;
    self.commentsQueueManager = [[CommentsQueueManager alloc] initWithDelegate:self.commentsView andCapacity:10];
    
    // Recording
    self.saver = [StoryWIPSaver sharedSaver];
    self.recorder = [[StoryMediaRecorder alloc] initWithStoryUUID:self.saver.uuid];
    self.recorder.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self doVolumeFadeAndStop];
    [self.delegate readModeViewController:self requestedToQuitStoryAtPage:self.page];
}

- (IBAction)playSound:(id)sender {
    if(self.player){
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
    NSArray *mockComment = @[@1.344, @6.582200, @7.739955];
    
    //NSLog(@"__________________________%f/%f___________________________________", currentPlayerTime, self.player.duration);
    
    for ( int i = 0; i < mockComment.count; i++) {
        
        NSTimeInterval commentTime = round([[mockComment objectAtIndex:i] doubleValue]);
        
        //NSLog(@"__________________________|%f", comment);
        

        if(commentTime == currentPlayerTime){
            //NSLog(@"|___________BIM_______________|");
            [self pushCommentAtindex:i];
        }
    }
}

-(void)pushCommentAtindex:(NSInteger) index{
    //NSLog(@"|___________BIM_______________|");
    
    NSArray* mockNames = @[@"Anne", @"Andy", @"France", @"Marc"];
    NSArray* mockIds= @[@1234, @7654, @98745, @3];
    
    //int randIndex = arc4random() % [mockNames count];
    
    User* user = [User new];
    user.username = [mockNames objectAtIndex: index];
    user.id = [mockIds objectAtIndex: index];
    
    Comment* comment = [Comment new]; 
    comment.file = [NSString stringWithFormat:@"com %ld", index];
    comment.user = user;
    //[self.page.comments objectAtIndex:index];
    [self.commentsQueueManager pushInQueueComment:comment  atIndex:index];
}

#pragma mark - Sound Tracking

- (void)fileUploader:(FileUploader *)uploader successfullyUploadedFileOfType:(NSString *)type toPath:(NSString *)path withFileName:(NSString *)filename{

}

- (void)fileUploader:(FileUploader *)uploader failedToUploadFileOfType:(NSString *)type toPath:(NSString *)path{

}


#pragma mark - UILongPressGestureRecognizer

- (void)handleLongPress:(UILongPressGestureRecognizer*)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"begin touch");
        [self pauseSound];
        //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self.recorder startRecording];
        
        /*if (!self.recordTimer.appeared) {
            self.replayButton.transform = CGAffineTransformMakeScale(0, 0);
            [self.recordTimer appear];
        }
        
        [self.recordTimer reset];
        [self.recordTimer start];
        
        self.audioWave.deployed = YES;
        [self.previewBubble hideWithCompletion:^{
            
        }];
        
        // Pause gyroscope panning
        [self currentPage].imagePanningEnabled = NO;
        
        if ([self currentPage].moviePlayer != nil) {
            [[self currentPage].moviePlayer play];
            [[self currentPage].view.layer insertSublayer:[self currentPage].moviePlayerLayer atIndex:10];
        }*/
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"ended touch");
        [self.recorder stopRecording];
        //[self.recordTimer pause];
        //[self.recordTimer close];
        
        // Requeue gyroscope panning
        //[self currentPage].imagePanningEnabled = YES;
        
        /*if (self.currentIndex != self.saver.medias.count-1) {
            [self.previewBubble appearWithCompletion:^{
                [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.replayButton.transform = CGAffineTransformMakeScale(1, 1);
                    self.overlay.alpha = 0.45f;
                } completion:nil];
            }];
        }*/
        
        //[self.audioWave hide];
        
        // Open done popin if everything has been recorded
        if ([self.recorder isComplete]) {
            //[self openDonePopin];
            FileUploader* uploader = [[FileUploader alloc] init];
            uploader.delegate = self;
            
            NSString* audioPath = [NSString stringWithFormat:@"/pages/%@/comments", self.page.id];
            [uploader uploadFileWithData:[self.recorder dataOfAudioWithIndex:0] toPath:audioPath ofType:kUploadTypeAudio];
            
        }
        /*if ([self currentPage].moviePlayer != nil) {
            [[self currentPage].moviePlayer pause];
        }*/
    }
}
@end
