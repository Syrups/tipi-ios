//
//  ReadModeContainerViewController.m
//  Wireframe
//
//  Created by Glenn Sonna on 05/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <AFURLSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>


#import "ReadModeContainerViewController.h"
#import "ReadModeViewController.h"
#import "Configuration.h"
#import "FileDownLoader.h"



@interface ReadModeContainerViewController ()
@end

@implementation ReadModeContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.audioPlayers = [NSMutableArray new];
    self.mediaFiles = [NSMutableArray new];
    
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
    newController.player = [self.audioPlayers objectAtIndex:i];
    newController.mediaImage = [self.mediaFiles objectAtIndex:i];
    newController.delegate = self;
    
    return newController;
}


#pragma mark - UIPageViewController
/*
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
}*/

#pragma mark - TPSwipableViewController

- (void)swipableViewController:(TPSwipableViewController *)containerViewController didFinishedTransitionToViewController:(UIViewController *)viewController{
}

- (void)swipableViewController:(TPSwipableViewController *)containerViewController didSelectViewController:(UIViewController *)viewController{
}

#pragma mark - StoryManager
- (void)storyManager:(StoryManager*)manager successfullyFetchedStory:(Story *)story{
    self.story = story;
    self.mPages = self.story.pages;
    
    [self loadMediaAndAudioInPages:self.mPages withCompletion:^{
   
        
        //Pager
        // Start at the first page of the array?
        /*int initialIndex = 0;
        
        // Assuming you have a SomePageViewController which extends UIViewController so you can do custom things.
        self.currentPageViewController = (ReadModeViewController *)[self viewControllerAtIndex:initialIndex];
        
        NSArray *initialViewControllers = [NSArray arrayWithObject:self.currentPageViewController];
        
        // animated:NO is important so the view just pops into existence.
        // direction: doesn't matter because it's not animating in.
        [self.pager setViewControllers:initialViewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        [self.pager willMoveToParentViewController:self];
        [self addChildViewController:self.pager];
        [self.view addSubview:self.pager.view];
        [self.view sendSubviewToBack:self.pager.view];
    
        [self.pager didMoveToParentViewController:self];*/
        
       
        
        //Swiper
        NSArray *childViewControllers = [self readmodeControllersWithPages:self.mPages];
        self.swiper = [[TPSwipableViewController alloc] initWithViewControllers:childViewControllers];
        self.swiper.view.frame = self.view.frame;
        [self.swiper willMoveToParentViewController:self];
        [self addChildViewController:self.swiper];
        [self.view addSubview:self.pager.view];
        [self.view sendSubviewToBack:self.pager.view];
    
        [self.swiper didMoveToParentViewController:self];
        
        
         self.edgesForExtendedLayout = UIRectEdgeNone;
        
         [self.delegate readModeContainerViewController:self didFinishedLoadingStory:self.story];
    }];
}

- (NSArray *)readmodeControllersWithPages:(NSArray*)pages {
    
    NSMutableArray *childViewControllers = [[NSMutableArray alloc] initWithCapacity:[pages count]];
    
    for (int i = 0; i < [pages count]; i++) {
        [childViewControllers addObject:[self viewControllerAtIndex:i]];
    }
    
    return childViewControllers;
}


- (void)storyManager:(StoryManager *)manager failedToFetchStoryWithId:(NSUInteger)id{
    
}

- (void)readModeViewController:(ReadModeViewController *)controller requestedToQuitStoryAtPage:(Page *)page{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)loadMediaAndAudioInPages:(NSArray *)pages withCompletion:(void(^)())completion{
   
    int i = 1;
    for (Page* page in pages) {
        
        //Files
        NSString* fileUrl = page.audio.file;
        
        NSURL *mediaURL = [NSURL URLWithString:page.media.file];
        
        [self loadMediaWithURL:mediaURL withCompletion:^{
            [self loadAudioWithFileURL:fileUrl withCompletion:^{
                 NSLog(@"loadedPage %d/%lu", i, [pages count]);
                if(i >= [pages count]){
                    completion();
                }
            }];
        }];
        
        i++;
    }
}

- (void)loadMediaWithURL:(NSURL*)url withCompletion:(void(^)())completion{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:url
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             // progression tracking code
                             NSLog(@"loadedImage %lu/%lu of file %@", receivedSize,expectedSize, url);
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if (image) {
                                [self.mediaFiles addObject:image];
                                completion();
                            }
                        }];
    
}

- (void)loadAudioWithFileURL:(NSString*)fileUrl withCompletion:(void(^)())completion{
    [FileDownLoader downloadFileWithURL:fileUrl completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        [self.audioPlayers addObject:[[AVAudioPlayer alloc] initWithContentsOfURL:filePath error:nil]];
        completion();
    }];
}


@end
