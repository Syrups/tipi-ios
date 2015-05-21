//
//  ReadModeContainerViewController.m
//  Wireframe
//
//  Created by Glenn Sonna on 05/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "ReadModeContainerViewController.h"
#import "ReadModeViewController.h"
#import "Configuration.h"
#import <AFURLSessionManager.h>




@interface ReadModeContainerViewController ()
@end

@implementation ReadModeContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Mock
    self.mPages  = @[];
    
    // Page
    self.pager = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pager.dataSource = self;
    self.pager.delegate = self;
    
    // Managers
    StoryManager* manager = [[StoryManager alloc] initWithDelegate:self];
    [manager fetchStoryWithId:self.storyId];

}

// Factory method
- (UIViewController *)viewControllerAtIndex:(int)i {
    // Asking for a page that is out of bounds??
    if (i<0) {
        return nil;
    }
    if (i>=self.mPages.count) {
        return nil;
    }
    
    // Assuming you have SomePageViewController.xib
    ReadModeViewController *newController = [self.storyboard instantiateViewControllerWithIdentifier: @"ReadMode"];
    newController.idx = i;
    newController.page = [self.mPages objectAtIndex:i];
    newController.delegate = self;
    
    return newController;
}


#pragma mark - UIPageViewController

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    ReadModeViewController *p = (ReadModeViewController *)viewController;
    return [self viewControllerAtIndex:(p.idx - 1)];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    ReadModeViewController *p = (ReadModeViewController *)viewController;
    return [self viewControllerAtIndex:(p.idx + 1)];
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    [self.currentPageViewController pauseSound];
    self.currentPageViewController = (ReadModeViewController*)[self.pager.viewControllers objectAtIndex:0];
}


#pragma mark - StoryManager
- (void)storyManager:(StoryManager*)manager successfullyFetchedStory:(Story *)story{
    self.story = story;
    self.mPages = self.story.pages;
    
    // Start at the first page of the array?
    int initialIndex = 0;
    
    // Assuming you have a SomePageViewController which extends UIViewController so you can do custom things.
    self.currentPageViewController = (ReadModeViewController *)[self viewControllerAtIndex:initialIndex];
    
    NSArray *initialViewControllers = [NSArray arrayWithObject:self.currentPageViewController];
    
    // animated:NO is important so the view just pops into existence.
    // direction: doesn't matter because it's not animating in.
    [self.pager setViewControllers:initialViewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Tell the child view to get ready
    [self.pager willMoveToParentViewController:self];
    
    // Actually add the child view controller
    [self addChildViewController:self.pager];
    
    // Don't forget to add the new root view to the current view hierarchy!
    [self.view addSubview:self.pager.view];
    [self.view sendSubviewToBack:self.pager.view];
    
    // And make sure to activate!
    [self.pager didMoveToParentViewController:self];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}



- (void)storyManager:(StoryManager *)manager failedToFetchStoryWithId:(NSUInteger)id{
    
}

- (void)readModeViewController:(ReadModeViewController *)controller requestedToQuitStoryAtPage:(Page *)page{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
