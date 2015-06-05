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
#import "CoachmarkManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreMotion/CoreMotion.h>
#import "AVAudioPlayer+AVAudioPlayer_Fading.h"
#import "ImageUtils.h"
#import "PKAIDecoder.h"

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentIndex = 0;
    self.saver = [StoryWIPSaver sharedSaver];
    
    [self setupSwipeablePager];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    self.longPressRecognizer.minimumPressDuration = 0.2f;
    self.longPressRecognizer.delegate = self;
    
    [self.view addGestureRecognizer:self.longPressRecognizer];
    
    self.recorder = [[StoryMediaRecorder alloc] initWithStoryUUID:self.saver.uuid];
    self.recorder.delegate = self;
    
//    [CoachmarkManager launchCoachmarkAnimationForRecordController:self withCompletion:nil];
}

- (void)setupSwipeablePager {
    NSArray *childViewControllers = [self instantiateChildViewControllers];
    self.swipablePager = [[TPSwipableViewController alloc] initWithViewControllers:childViewControllers];
    
    [self addChildViewController:self.swipablePager];
    self.swipablePager.view.frame = self.view.frame;
    [self.view addSubview:self.swipablePager.view];
    [self.view sendSubviewToBack:self.swipablePager.view];
    [self.swipablePager didMoveToParentViewController:self];
    self.swipablePager.delegate = self;
}

- (NSArray *)instantiateChildViewControllers {
    
    NSMutableArray* viewControllers = [NSMutableArray arrayWithCapacity:self.saver.medias.count];
    
    for (int i = 0; i < self.saver.medias.count; ++i) {
        RecordPageViewController* controller = [self viewControllerAtIndex:i];
//        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:controller.view.bounds];
//        controller.view.layer.masksToBounds = NO;
//        controller.view.layer.shadowColor = [UIColor blackColor].CGColor;
//        controller.view.layer.shadowOffset = CGSizeMake(5.0f, 0);
//        controller.view.layer.shadowOpacity = 0.3f;
//        controller.view.layer.shadowPath = shadowPath.CGPath;
        [viewControllers addObject:controller];
    }
    
    return viewControllers;
}

- (IBAction)replay:(id)sender {
    [self.recorder playAudio];
}

#pragma mark - StoryMediaRecorder

- (void)mediaRecorder:(StoryMediaRecorder *)recorder hasAudioReceived:(float **)buffer withBufferSize:(UInt32)bufferSize withNumberOfChannels:(UInt32)numberOfChannels {
    
    [[self currentPage].recordTimer updateWithBuffer:buffer bufferSize:bufferSize withNumberOfChannels:numberOfChannels];
}

#pragma mark - UILongPressGestureRecognizer

- (void)handleLongPress:(UILongPressGestureRecognizer*)recognizer {
    
    RecordPageViewController* current = [self currentPage];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"begin touch index: %d", self.currentIndex);
        [self.recorder startRecording];
        
//        [CoachmarkManager dismissCoachmarkAnimationForRecordController:self];
        
        if (!current.recordTimer.appeared) {
            current.replayButton.transform = CGAffineTransformMakeScale(0, 0);
            [current.recordTimer appear];
        }
        
        [current.recordTimer reset];
        [current.recordTimer start];

        if ([self currentPage].moviePlayer != nil) {
            [current.moviePlayer play];
            [current.view.layer insertSublayer:[self currentPage].moviePlayerLayer atIndex:10];
            [current.view bringSubviewToFront:current.replayButton];
            [current.view bringSubviewToFront:current.recordTimer];
        }
        
        [UIView animateWithDuration:.3f animations:^{
            current.overlay.alpha = .6f;
//            self.organizerContainerYConstraint.constant = -100;
            self.organizerContainerView.alpha = 0;
        }];
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"ended touch");
        [self.recorder stopRecording];
        [current.recordTimer pause];
        [current.recordTimer close];
        

        [PKAIDecoder builAnimatedImageInButton:current.replayButton fromFile:@"replay-appear" withColor:nil withAnimationDuration:.5f];
        current.replayButton.transform = CGAffineTransformMakeScale(1, 1);

        
        // Open done popin if everything has been recorded
        if ([self.recorder isComplete]) {
            [self openDonePopin];
        }
        
        [UIView animateWithDuration:.3f animations:^{
            current.overlay.alpha = 0;
//            self.organizerContainerYConstraint.constant = 0;
            self.organizerContainerView.alpha = 1;
        }];
        
        if ([self currentPage].moviePlayer != nil) {
            [[self currentPage].moviePlayer pause];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (CGRectContainsPoint(self.organizerContainerView.bounds, [touch locationInView:self.organizerContainerView]))
        return NO;
    
    return YES;
}

#pragma mark - Navigation and view controller

- (void)swipableViewController:(TPSwipableViewController *)containerViewController didFinishedTransitionToViewController:(RecordPageViewController *)viewController {

    RecordPageViewController* old = [self viewControllerAtIndex:self.currentIndex];
    old.tiltingView.enabled = NO;
    
    self.currentIndex = viewController.pageIndex;
    
    if (self.currentIndex != self.saver.medias.count-1) {
        self.lastPage = NO;
    }
    
    viewController.tiltingView.enabled = YES;
    
    viewController.replayButton.transform = ![self.recorder hasRecordedAtIndex:self.currentIndex] ? CGAffineTransformMakeScale(0, 0) : CGAffineTransformMakeScale(1, 1);
    viewController.recordTimer.hidden = [self.recorder hasRecordedAtIndex:self.currentIndex];
    [viewController.recordTimer reset];
    
    if (![self.recorder hasRecordedAtIndex:self.currentIndex] && !viewController.recordTimer.appeared) {
        [viewController.recordTimer appear];
    }
    
    viewController.overlay.alpha = 0;
    [self.recorder.player fadeOutAndPause];
    [self.recorder setupForMediaWithIndex:self.currentIndex];
    
    OrganizeStoryViewController* organizer = (OrganizeStoryViewController*)[self.childViewControllers objectAtIndex:0];
    
//    CGPoint oldContentOffset = organizer.collectionView.contentOffset;
//    CGFloat delta = oldIndex < self.currentIndex ? CELL_SIZE + 15 : -CELL_SIZE - 15;
//    [organizer.collectionView setContentOffset:CGPointMake(oldContentOffset.x + delta, oldContentOffset.y) animated:YES];
}

- (RecordPageViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.saver.medias count] == 0) || (index >= [self.saver.medias count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    RecordPageViewController *page = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordPage"];
    
    page.next = [self viewControllerAtIndex:index+1];
    page.pageIndex = index;
    
    page.replayButton.transform = CGAffineTransformMakeScale(0, 0);
    
    NSDictionary* media = [self.saver.medias objectAtIndex:index];
    
    if ([[media objectForKey:@"type"] isEqualToString:ALAssetTypeVideo]) {
        NSURL *url= (NSURL*)[media objectForKey:@"url"];
        
        AVURLAsset* asset = [AVURLAsset URLAssetWithURL:url options:nil];
        AVPlayerItem* item = [AVPlayerItem playerItemWithAsset:asset];
        page.moviePlayer=[AVPlayer playerWithPlayerItem:item];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:item queue:nil usingBlock:^(NSNotification *note) {
            AVPlayerItem* item = [note object];
            [item seekToTime:kCMTimeZero];
            [page.moviePlayer play];
        }];
        
        UIImage* full = [(NSDictionary*)[self.saver.medias objectAtIndex:index] objectForKey:@"full"];
        page.image = full;
        
        
        AVPlayerLayer* playerLayer = [AVPlayerLayer playerLayerWithPlayer:page.moviePlayer];
        page.moviePlayerLayer = playerLayer;
        page.moviePlayer.volume = 0;
        playerLayer.frame = self.view.frame;
        [page.view.layer insertSublayer:playerLayer atIndex:0];
        
        [page.view bringSubviewToFront:page.replayButton];
        [page.view bringSubviewToFront:page.recordTimer];
    } else {
        page.image = [(NSDictionary*)[self.saver.medias objectAtIndex:index] objectForKey:@"full"];
    }
        
    return page;
}

#pragma mark - Navigation

- (void)moveViewControllerfromIndex:(NSUInteger)oldIndex atIndex:(NSUInteger)newIndex {
    
    if (self.currentIndex == oldIndex) {
        self.currentIndex = newIndex;
    } else {
        if (oldIndex < newIndex) {
            self.currentIndex--;
        } else {
            self.currentIndex++;
        }
    }
    
    [self.swipablePager moveViewController:[self.swipablePager.viewControllers objectAtIndex:oldIndex] fromIndex:oldIndex atIndex:newIndex];
}

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
    if (self.currentIndex >= self.swipablePager.viewControllers.count)
        return nil;
    return (RecordPageViewController*)self.swipablePager.viewControllers[self.currentIndex];
}

@end
