//
//  ReviewStoryViewController.m
//  Wireframe
//
//  Created by Leo on 22/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "ReviewStoryViewController.h"
#import "ReviewPageViewController.h"

@implementation ReviewStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentIndex = 0;

    self.saver = [StoryWIPSaver sharedSaver];
    
    [self setupSwipeablePager];
    
    self.recorder = [[StoryMediaRecorder alloc] initWithStoryUUID:self.saver.uuid];
    self.recorder.delegate = self;
    [self.recorder setupForMediaWithIndex:0];
    [self.recorder playAudio];

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

- (NSArray*)instantiateChildViewControllers {
    NSMutableArray* viewControllers = [NSMutableArray array];
    for (int i = 0 ; i < self.saver.medias.count ; ++i) {
        ReviewPageViewController* vc = (ReviewPageViewController*)[self viewControllerAtIndex:i];
        vc.pageIndex = i;
        vc.next = (ReviewPageViewController*)[self viewControllerAtIndex:i+1];
        [viewControllers addObject:vc];
    }
    
    return [viewControllers copy];
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - StoryMediaRecorder

- (void)mediaRecorder:(StoryMediaRecorder *)recorder didFinishPlayingAudioAtIndex:(NSUInteger)index {
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(next) userInfo:nil repeats:NO];
}

- (void)mediaRecorder:(StoryMediaRecorder *)recorder hasAudioReceived:(float **)buffer withBufferSize:(UInt32)bufferSize withNumberOfChannels:(UInt32)numberOfChannels {
    // todo
}

#pragma mark - UIPageViewController

- (ReviewPageViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.saver.medias count] == 0) || (index >= [self.saver.medias count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    ReviewPageViewController *page = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordPage"];
    page.pageIndex = index;
    page.image = [(NSDictionary*)[self.saver.medias objectAtIndex:index] objectForKey:@"full"];
    
    return page;
}

- (void)swipableViewController:(TPSwipableViewController *)containerViewController didFinishedTransitionToViewController:(UIViewController *)viewController {
    
    [self.recorder setupForMediaWithIndex:self.currentIndex];
    [self.recorder playAudio];
}


#pragma mark - Helpers

- (ReviewPageViewController*)currentPage {
    return self.swipablePager.viewControllers[0];
}

- (void)next {
    ReviewPageViewController* vc = [self viewControllerAtIndex:self.currentIndex+1];
    
    if (vc == nil) {
        [self dismiss:nil];
        
        return;
    }
    
    self.currentIndex++;
    
    [self.swipablePager setSelectedViewController:[self.swipablePager.viewControllers objectAtIndex:self.currentIndex]];
}

@end
