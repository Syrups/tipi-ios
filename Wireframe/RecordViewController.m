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


@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lastPage = NO;
    
    self.saver = [StoryWIPSaver sharedSaver];
    
    self.recordButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.recordButton.layer.cornerRadius = 40;
    self.recordButton.layer.borderWidth = 10;
    
//    self.pages = [NSMutableArray arrayWithObjects:@"1", @"2", @"3", nil];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordPageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    self.pageViewController.view.frame = self.view.frame;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    RecordPageViewController* first = [self viewControllerAtIndex:self.currentIndex];
    [self.pageViewController setViewControllers:@[first] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.view sendSubviewToBack:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    for (UIView* v in self.pageViewController.view.subviews) {
        if ([v isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView*)v).delegate = self;
        }
    }
    
    UILongPressGestureRecognizer* press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    press.minimumPressDuration = 0.3f;
    
    [self.view addGestureRecognizer:press];
    
    self.recorder = [[StoryMediaRecorder alloc] initWithStoryUUID:self.saver.uuid];
    self.recorder.delegate = self;
    
//    EZAudioPlotGL* audioPlot = [[EZAudioPlotGL alloc] initWithFrame:self.view.frame];
//    [self.view addSubview:audioPlot];
//    audioPlot.userInteractionEnabled = NO;
//    audioPlot.alpha = 0.5f;
//    audioPlot.backgroundColor = [UIColor whiteColor];
//    audioPlot.plotType = EZPlotTypeRolling;
//    
//    self.audioPlot = audioPlot;
    
}

#pragma mark - StoryMediaRecorder

- (void)mediaRecorder:(StoryMediaRecorder *)recorder hasAudioReceived:(float **)buffer withBufferSize:(UInt32)bufferSize withNumberOfChannels:(UInt32)numberOfChannels {
//    [self.audioPlot updateBuffer:buffer[0] withBufferSize:bufferSize];
}


- (void)handleLongPress:(UILongPressGestureRecognizer*)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"begin touch");
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self.recorder startRecording];
        [self.recordTimer reset];
        [self.recordTimer start];
        
        if ([self currentPage].moviePlayer != nil) {
            [[self currentPage].moviePlayer play];
            [[self currentPage].view.layer insertSublayer:[self currentPage].moviePlayerLayer atIndex:10];
        }
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"ended touch");
        [self.recorder stopRecording];
        [self.recordTimer pause];
        
        self.replay.hidden = NO;
        
        if ([self currentPage].moviePlayer != nil) {
            [[self currentPage].moviePlayer pause];
        }
    }
}

- (IBAction)replay:(id)sender {
    [self.recorder playAudio];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIPageViewController

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
    
    return page;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((RecordPageViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    if (index < self.saver.medias.count-1) {
        self.lastPage = NO;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((RecordPageViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.saver.medias count]) {
        
        self.lastPage = YES;
        
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}


- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    NSUInteger index = [self currentPage].pageIndex;
    self.currentIndex = index;
    
    if (index != self.saver.medias.count-1) {
        self.lastPage = NO;
    }
    
    self.replay.hidden = ![self.recorder hasRecordedAtIndex:index];
    [self.recordTimer reset];
    
    [self.recorder.player stop];
    [self.recorder setupForMediaWithIndex:index];
}

#pragma mark - UIScrollView

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.lastPage && scrollView.contentOffset.x > self.view.frame.size.width) {
        [self performSegueWithIdentifier:@"ToNameStory" sender:nil];
    }
    
    if (self.currentIndex == 0 && scrollView.contentOffset.x < -10) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Helpers

- (RecordPageViewController*)currentPage {
    return self.pageViewController.viewControllers[0];
}


@end
