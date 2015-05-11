//
//  RecordViewController.m
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "RecordViewController.h"
#import "RecordPageViewController.h"
#import "DoneStoryViewController.h"
#import "NameStoryViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreMotion/CoreMotion.h>

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lastPage = NO;
    
    self.saver = [StoryWIPSaver sharedSaver];
    
    self.replayButton.transform = CGAffineTransformMakeScale(0, 0);
    
    self.previewBubble.delegate = self;
    
    self.recordButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.recordButton.layer.cornerRadius = 40;
    self.recordButton.layer.borderWidth = 10;

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    RecordPageViewController* first = [self viewControllerAtIndex:self.currentIndex];
    [self addChildViewController:first];
    [self.view addSubview:first.view];
    [self.view sendSubviewToBack:first.view];
    [first didMoveToParentViewController:self];

    self.longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    self.longPressRecognizer.minimumPressDuration = 0.2f;
    
    UISwipeGestureRecognizer* swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer* swipeBack = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeBack:)];
    swipeBack.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swipe];
    [self.view addGestureRecognizer:swipeBack];
    [self.view addGestureRecognizer:self.longPressRecognizer];
    
    self.recorder = [[StoryMediaRecorder alloc] initWithStoryUUID:self.saver.uuid];
    self.recorder.delegate = self;
    
    if ([self.recorder hasRecordedAtIndex:self.currentIndex]) {
        self.replayButton.transform = CGAffineTransformMakeScale(1, 1);
        [self.recordTimer hide];
    } else {
        [self.recordTimer appear];
        self.overlay.alpha = 0;
    }
    
    if (self.currentIndex != self.saver.medias.count-1)
        [self.previewBubble updateWithImage:[(NSDictionary*)[self.saver.medias objectAtIndex:1] objectForKey:@"full"]];
    
    self.timeline = [[Timeline alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 10, self.view.frame.size.width, 10) mediaCount:self.saver.medias.count];
//    [self.view addSubview:self.timeline];
    
    self.audioWave.alpha = 0;
    
    [UIView animateWithDuration:.2f animations:^{
        self.audioWave.alpha = 1;
    }];
}

- (IBAction)replay:(id)sender {
    [self.recorder playAudio];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - StoryMediaRecorder

- (void)mediaRecorder:(StoryMediaRecorder *)recorder hasAudioReceived:(float **)buffer withBufferSize:(UInt32)bufferSize withNumberOfChannels:(UInt32)numberOfChannels {
    
    [self.audioWave updateWithBuffer:buffer bufferSize:bufferSize withNumberOfChannels:numberOfChannels];
    [self.recordTimer updateWithBuffer:buffer bufferSize:bufferSize withNumberOfChannels:numberOfChannels];
}

#pragma mark - UISwipeGestureRecognizer

- (void)handleSwipe:(UISwipeGestureRecognizer*)swipe {
    if (self.previewBubble.hidden) {
        [self.previewBubble appearWithCompletion:^{
            [self.previewBubble expandWithCompletion:^{
                [self goNextPage];
            }];
        }];
    } else {
        [self.previewBubble expandWithCompletion:^{
            [self goNextPage];
        }];
    }
    
}

- (void)handleSwipeBack:(UISwipeGestureRecognizer*)swipe {
    [self goPreviousPage];
}

#pragma mark - PreviewBubble

- (void)previewBubbleDidDragToExpand:(PreviewBubble *)bubble {
    [self.previewBubble expandWithCompletion:^{
        [self goNextPage];
    }];
}

#pragma mark - UILongPressGestureRecognizer

- (void)handleLongPress:(UILongPressGestureRecognizer*)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"begin touch");
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self.recorder startRecording];
        
        if (!self.recordTimer.appeared) {
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
        }
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"ended touch");
        [self.recorder stopRecording];
        [self.recordTimer pause];
        [self.recordTimer close];
        
        // Requeue gyroscope panning
        [self currentPage].imagePanningEnabled = YES;

        if (self.currentIndex != self.saver.medias.count-1) {
            [self.previewBubble appearWithCompletion:^{
                [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.replayButton.transform = CGAffineTransformMakeScale(1, 1);
                    self.overlay.alpha = 0.45f;
                } completion:nil];
            }];
        }
        
        [self.audioWave hide];
        
        // Open done popin if everything has been recorded
        if ([self.recorder isComplete]) {
            [self openDonePopin];
        }
        
        if ([self currentPage].moviePlayer != nil) {
            [[self currentPage].moviePlayer pause];
        }
    }
}


#pragma mark - Navigation and view controller

- (void)goNextPage {
    self.currentIndex++;
    [self presentRequestedPage];
}

- (void)goPreviousPage {
    self.currentIndex--;
    [self presentRequestedPage];
}

- (void)presentRequestedPage {
    RecordPageViewController* next = [self viewControllerAtIndex:self.currentIndex];
    
    if (next) {
        [[self currentPage].view removeFromSuperview];
        [[self currentPage] removeFromParentViewController];
        
        if (self.currentIndex != self.saver.medias.count-1) {
            self.lastPage = NO;
        }
        
        self.replayButton.transform = ![self.recorder hasRecordedAtIndex:self.currentIndex] ? CGAffineTransformMakeScale(0, 0) : CGAffineTransformMakeScale(1, 1);
        self.recordTimer.hidden = [self.recorder hasRecordedAtIndex:self.currentIndex];
        [self.recordTimer reset];
        
        if (![self.recorder hasRecordedAtIndex:self.currentIndex] && !self.recordTimer.appeared) {
            [self.recordTimer appear];
        }
        
        self.overlay.alpha = 0;
        [self.recorder.player stop];
        [self.recorder setupForMediaWithIndex:self.currentIndex];
        [self.timeline updateWithIndex:self.currentIndex];
        
        if (self.currentIndex != self.saver.medias.count-1) {
            [self.previewBubble updateWithImage:[(NSDictionary*)[self.saver.medias objectAtIndex:self.currentIndex+1] objectForKey:@"full"]];
        }
        
        [self addChildViewController:next];
        [self.view addSubview:next.view];
        [self.view sendSubviewToBack:next.view];
        [next didMoveToParentViewController:self];
        
        [self.previewBubble close];
    }
}

- (RecordPageViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.saver.medias count] == 0) || (index >= [self.saver.medias count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    RecordPageViewController *page = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordPage"];
    page.pageIndex = index;
    
    NSDictionary* media = [self.saver.medias objectAtIndex:index];
    
    if ([[media objectForKey:@"type"] isEqualToString:ALAssetTypeVideo]) {
        NSURL *url= (NSURL*)[media objectForKey:@"url"];
        
        AVURLAsset* asset = [AVURLAsset URLAssetWithURL:url options:nil];
        AVPlayerItem* item = [AVPlayerItem playerItemWithAsset:asset];
        page.moviePlayer=[AVPlayer playerWithPlayerItem:item];
        NSLog(@"%@", url);
        
        [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:item queue:nil usingBlock:^(NSNotification *note) {
            AVPlayerItem* item = [note object];
            [item seekToTime:kCMTimeZero];
            [page.moviePlayer play];
        }];
        
        page.image = [(NSDictionary*)[self.saver.medias objectAtIndex:index] objectForKey:@"full"];
        
        
        AVPlayerLayer* playerLayer = [AVPlayerLayer playerLayerWithPlayer:page.moviePlayer];
        page.moviePlayerLayer = playerLayer;
        page.moviePlayer.volume = 0;
        playerLayer.frame = self.view.frame;
        [page.view.layer insertSublayer:playerLayer atIndex:0];
    } else {
        page.image = [(NSDictionary*)[self.saver.medias objectAtIndex:index] objectForKey:@"full"];
    }
    
//    [self.previewBubble updateWithImage:[(NSDictionary*)[self.saver.medias objectAtIndex:index+1] objectForKey:@"full"]];
    
    return page;
}

#pragma mark - Navigation

- (void)openDonePopin {
    DoneStoryViewController* done = (DoneStoryViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"DoneStory"];
    
    [self addChildViewController:done];
    done.view.frame = self.view.frame;
    done.view.alpha = 0;
    [self.view addSubview:done.view];
    [done didMoveToParentViewController:self];
    
    self.donePopin = done;
    
    [UIView animateWithDuration:.3f animations:^{
        done.view.alpha = 1;
    }];
}

- (void)openNameStoryPopin {
    NameStoryViewController* done = (NameStoryViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"NameStory"];
    
    [self addChildViewController:done];
    done.view.frame = self.view.frame;
    done.view.alpha = 0;
    [self.view addSubview:done.view];
    [done didMoveToParentViewController:self];
    
    [self.donePopin.view removeFromSuperview];
    [self.donePopin removeFromParentViewController];
    
    self.namePopin = done;
    
    [UIView animateWithDuration:.3f animations:^{
        done.view.alpha = 1;
    }];
}

#pragma mark - Helpers

- (RecordPageViewController*)currentPage {
    return (RecordPageViewController*)self.childViewControllers[0];
}

#pragma mark - Stuff

- (IBAction)applySepiaFilter:(id)sender {
    [[self currentPage] applySepiaFilter];
}

@end
