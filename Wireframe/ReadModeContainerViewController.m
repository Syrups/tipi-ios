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


typedef void(^fadeOutCompletion)(BOOL);

@interface ReadModeContainerViewController ()
@end

@implementation ReadModeContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mPages  = @[@1, @1, @1];
    
    // Create it.
    self.pager = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    // Point the datasource back to this UIViewController.
    self.pager.dataSource = self;
    
   
    
    
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
    newController.parent = self;
    
    return newController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    ReadModeViewController *p = (ReadModeViewController *)viewController;
    return [self viewControllerAtIndex:(p.idx - 1)];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    ReadModeViewController *p = (ReadModeViewController *)viewController;
    return [self viewControllerAtIndex:(p.idx + 1)];
}

- (void)storyManager:(StoryManager*)manager successfullyFetchedStory:(Story *)story{
    self.story = story;
    self.mPages = self.story.pages;
    
    // Start at the first page of the array?
    int initialIndex = 0;
    
    // Assuming you have a SomePageViewController which extends UIViewController so you can do custom things.
    ReadModeViewController *initialViewController = (ReadModeViewController *)[self viewControllerAtIndex:initialIndex];
    NSArray *initialViewControllers = [NSArray arrayWithObject:initialViewController];
    
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


- (void)playSound:(NSURL*)filePath {
    
    if(self.player != nil){
        
        if(self.player.isPlaying){
            
            //Same file means pause
            if([self.player.url isEqual:filePath]){
                [self doVolumeFadeAndPause];
            }else{//Different file mean stop for current and play for new
                
                [self doVolumeFadeAndStop];
                //Stop callback
                self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:filePath error:nil];
            }
        }else{//Not playing
            //DoFadeInAndPlay
            if(![self.player.url isEqual:filePath]){
                self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:filePath error:nil];
            }
            [self.player play];
        }
    }else{
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:filePath error:nil];
        [self.player play];
    }
    
}

-(void)doVolumeFadeAndStop{
  [self doVolumeFade:^(BOOL stop) {
      // Stop and get the sound ready for playing again
      [self.player stop];
      self.player.currentTime = 0;
      [self.player prepareToPlay];
      self.player.volume = 1.0;
  }];
}

-(void)doVolumeFadeAndPause{
    [self doVolumeFade:^(BOOL stop)  {
        // Stop and get the sound ready for playing again
        [self.player stop];
        self.player.currentTime = 0;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
