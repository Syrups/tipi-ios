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
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReviewStoryPageViewController"];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    [self.pageViewController willMoveToParentViewController:self];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.view sendSubviewToBack:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    self.saver = [StoryWIPSaver sharedSaver];
    
    ReviewPageViewController* first = [self viewControllerAtIndex:self.currentIndex];
    [self.pageViewController setViewControllers:@[first] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.recorder = [[StoryMediaRecorder alloc] initWithStoryUUID:self.saver.uuid];
    self.recorder.delegate = self;
    [self.recorder setupForMediaWithIndex:0];
    [self.recorder playAudio];
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - StoryMediaRecorder

- (void)mediaRecorder:(StoryMediaRecorder *)recorder didFinishPlayingAudioAtIndex:(NSUInteger)index {
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(next) userInfo:nil repeats:NO];
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

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((ReviewPageViewController*) viewController).pageIndex;
    
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
    NSUInteger index = ((ReviewPageViewController*) viewController).pageIndex;
    
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
    
    [self.recorder setupForMediaWithIndex:index];
    [self.recorder playAudio];
}

#pragma mark - Helpers

- (ReviewPageViewController*)currentPage {
    return self.pageViewController.viewControllers[0];
}

- (void)next {
    ReviewPageViewController* vc = [self viewControllerAtIndex:self.currentIndex+1];
    
    if (vc == nil) {
        [self dismiss:nil];
        
        return;
    }
    
    __block ReviewStoryViewController* _self = self;
    
    [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        [_self pageViewController:_self.pageViewController didFinishAnimating:finished previousViewControllers:nil transitionCompleted:YES];
    }];
}

@end
