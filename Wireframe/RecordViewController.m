//
//  RecordViewController.m
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "RecordViewController.h"
#import "RecordPageViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreMotion/CoreMotion.h>

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lastPage = NO;
    
    self.saver = [StoryWIPSaver sharedSaver];
    
    self.recordButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.recordButton.layer.cornerRadius = 40;
    self.recordButton.layer.borderWidth = 10;

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    RecordPageViewController* first = [self viewControllerAtIndex:self.currentIndex];
    [self addChildViewController:first];
    [self.view addSubview:first.view];
    [self.view sendSubviewToBack:first.view];
    [first didMoveToParentViewController:self];

    UILongPressGestureRecognizer* press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    press.minimumPressDuration = 0.3f;
    
    UISwipeGestureRecognizer* swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer* swipeBack = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeBack:)];
    swipeBack.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swipe];
    [self.view addGestureRecognizer:swipeBack];
    [self.view addGestureRecognizer:press];
    
    self.recorder = [[StoryMediaRecorder alloc] initWithStoryUUID:self.saver.uuid];
    self.recorder.delegate = self;
    
    [self.recordTimer appear];
    
    if (self.currentIndex != self.saver.medias.count-1)
        [self.previewBubble updateWithImage:[(NSDictionary*)[self.saver.medias objectAtIndex:1] objectForKey:@"full"]];
}

- (IBAction)replay:(id)sender {
    [self.recorder playAudio];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - StoryMediaRecorder

- (void)mediaRecorder:(StoryMediaRecorder *)recorder hasAudioReceived:(float **)buffer withBufferSize:(UInt32)bufferSize withNumberOfChannels:(UInt32)numberOfChannels {
    
    [self.audioWave updateWithBuffer:buffer bufferSize:bufferSize withNumberOfChannels:numberOfChannels];
}

#pragma mark - UISwipeGestureRecognizer

- (void)handleSwipe:(UISwipeGestureRecognizer*)swipe {
    [self.previewBubble expandWithCompletion:^{
        [self goNextPage];
    }];
}

- (void)handleSwipeBack:(UISwipeGestureRecognizer*)swipe {
    [self goPreviousPage];
}

#pragma mark - UILongPressGestureRecognizer

- (void)handleLongPress:(UILongPressGestureRecognizer*)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"begin touch");
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self.recorder startRecording];
        [self.recordTimer reset];
        [self.recordTimer start];
        
        self.audioWave.deployed = YES;
        [self.previewBubble hide];
        
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

        [self.previewBubble appear];
        [self.audioWave hide];
        
        if ([self currentPage].moviePlayer != nil) {
            [[self currentPage].moviePlayer pause];
        }
    }
}


#pragma mark - Navigation and view controller

- (void)goNextPage {
    self.currentIndex++;
    RecordPageViewController* next = [self viewControllerAtIndex:self.currentIndex];
    
    if (next) {
        [[self currentPage].view removeFromSuperview];
        [[self currentPage] removeFromParentViewController];
        
        if (self.currentIndex != self.saver.medias.count-1) {
            self.lastPage = NO;
        }
        
        self.replay.hidden = ![self.recorder hasRecordedAtIndex:self.currentIndex];
        self.recordTimer.hidden = [self.recorder hasRecordedAtIndex:self.currentIndex];
        [self.recordTimer reset];
        
        [self.recorder.player stop];
        [self.recorder setupForMediaWithIndex:self.currentIndex];
        
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

- (void)goPreviousPage {
    self.currentIndex--;
    RecordPageViewController* prev = [self viewControllerAtIndex:self.currentIndex];
    
    if (prev) {
        [[self currentPage].view removeFromSuperview];
        [[self currentPage] removeFromParentViewController];
        
        if (self.currentIndex != self.saver.medias.count-1) {
            self.lastPage = NO;
        }
        
        self.replay.hidden = ![self.recorder hasRecordedAtIndex:self.currentIndex];
        self.recordTimer.hidden = [self.recorder hasRecordedAtIndex:self.currentIndex];
        [self.recordTimer reset];
        
        [self.recorder.player stop];
        [self.recorder setupForMediaWithIndex:self.currentIndex];
        
        if (self.currentIndex != self.saver.medias.count-1) {
            [self.previewBubble updateWithImage:[(NSDictionary*)[self.saver.medias objectAtIndex:self.currentIndex+1] objectForKey:@"full"]];
        }
        
        [self addChildViewController:prev];
        [self.view addSubview:prev.view];
        [self.view sendSubviewToBack:prev.view];
        [prev didMoveToParentViewController:self];
        
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


#pragma mark - UIScrollView

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (self.lastPage && scrollView.contentOffset.x > self.view.frame.size.width) {
//        [self performSegueWithIdentifier:@"ToNameStory" sender:nil];
//    }
//    
//    if (self.currentIndex == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width) {
//        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
//    }
//    if (self.currentIndex == [self.pages count]-1 && scrollView.contentOffset.x > scrollView.bounds.size.width) {
//        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
//    }
//}
//
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
//{
//    if (self.currentIndex == 0 && scrollView.contentOffset.x <= scrollView.bounds.size.width) {
//        velocity = CGPointZero;
//        *targetContentOffset = CGPointMake(scrollView.bounds.size.width, 0);
//    }
//    if (self.currentIndex == [self.pages count]-1 && scrollView.contentOffset.x >= scrollView.bounds.size.width) {
//        velocity = CGPointZero;
//        *targetContentOffset = CGPointMake(scrollView.bounds.size.width, 0);
//    }
//    
//}

#pragma mark - Helpers

- (RecordPageViewController*)currentPage {
    return (RecordPageViewController*)self.childViewControllers[0];
}


@end
