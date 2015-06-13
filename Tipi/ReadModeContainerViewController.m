//
//  ReadModeContainerViewController.m
//  Wireframe
//
//  Created by Glenn Sonna on 05/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <AFURLSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "ShowOneGroupViewController.h"

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
    
    
    // Managers
    StoryManager* manager = [[StoryManager alloc] initWithDelegate:self];
    [manager fetchStoryWithId:self.storyId];
}

#pragma mark - Factory methods
- (ReadModeViewController *)viewControllerAtIndex:(int)i {
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
    newController.delegate = self;
    newController.page = [self.mPages objectAtIndex:i];
    newController.player = [self.audioPlayers objectAtIndex:i];
    
    id media = [self.mediaFiles objectAtIndex:i];
    
    if ([media isKindOfClass:[UIImage class]]) { // image
        newController.mediaImage = (UIImage*)media;
    } else { // video with URL
        newController.videoUrl = (NSURL*)media;
    }
    
    newController.next = [self viewControllerAtIndex:i+1];
    newController.storyTitleString = self.story.title;
    newController.totalPages = [self.story.pages count];
    
    return newController;
}


- (NSArray *)readmodeControllersWithPages:(NSArray*)pages {
    
    NSMutableArray *childViewControllers = [[NSMutableArray alloc] initWithCapacity:[pages count]];
    
    for (int i = 0; i < [pages count]; i++) {
        [childViewControllers addObject:[self viewControllerAtIndex:i]];
    }
    
    return childViewControllers;
}

- (void)close {
    
    
    // disable all motion managers
    [self.swiper.viewControllers enumerateObjectsUsingBlock:^(ReadModeViewController* obj, NSUInteger idx, BOOL *stop) {
        [obj stopPage];
        [obj.mediaImageView.motionManager stopGyroUpdates];
    }];
    
    ShowOneGroupViewController* parent = (ShowOneGroupViewController*)self.parentViewController;
    parent.topBar.alpha = 1;
    parent.mTableView.alpha = 1;
    [parent.mTableView reloadData];
    
    [parent transitionFromReadMode];
    
    [UIView animateWithDuration:.3f animations:^{
        self.view.alpha = 0;
        //        self.view.transform = CGAffineTransformMakeTranslation(0, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}


- (void)setupForViewController:(ReadModeViewController*)newViewController {
    ReadModeViewController* previousController = self.currentController;
    ReadModeViewController *currentController = newViewController;
    
    NSLog(@"%d", previousController.idx);
    
    if (previousController.player.isPlaying) {
        [previousController stopPage];
    }
    
    self.currentController = currentController;
    [self.currentController playAndTrack];
    //[currentController.moviePlayer performSelector:@selector(play) withObject:nil afterDelay:.2f];
    
    // disable all motion managers
    [self.swiper.viewControllers enumerateObjectsUsingBlock:^(ReadModeViewController* obj, NSUInteger idx, BOOL *stop) {
        [obj.mediaImageView.motionManager stopGyroUpdates];
    }];
    
    if ([self.currentController.page.comments count] > 0) {
        self.currentController.commentsButton.alpha = 1;
    } else {
        self.currentController.commentsButton.alpha = 0;
    }
    
    //[currentController.player fadeInPlay];
    [currentController.mediaImageView enable];
}

#pragma mark - TPSwipableViewController

- (void)swipableViewController:(TPSwipableViewController *)containerViewController didFinishedTransitionToViewController:(UIViewController *)viewController{
    //NSLog(@"TOTOTOTOTOOT");
    [self setupForViewController:(ReadModeViewController*)viewController];
    
}

- (void)swipableViewController:(TPSwipableViewController *)containerViewController didSelectViewController:(UIViewController *)viewController{
    
}

#pragma mark - StoryManager
- (void)storyManager:(StoryManager*)manager successfullyFetchedStory:(Story *)story{
    self.story = story;
    self.mPages = self.story.pages;
    
    [self loadMediaAndAudioInPages:self.mPages atIndex:0 withCompletion:^{
        
        //Swiper
        NSArray *childViewControllers = [self readmodeControllersWithPages:self.mPages];
        self.swiper = [[TPSwipableViewController alloc] initWithViewControllers:childViewControllers];
        self.swiper.view.frame = self.view.frame;
        self.swiper.delegate = self;
        
        [self.swiper willMoveToParentViewController:self];
        [self addChildViewController:self.swiper];
        [self.view addSubview:self.swiper.view];
        [self.view sendSubviewToBack:self.swiper.view];
        
        [self.swiper didMoveToParentViewController:self];
        
        self.currentController = [self.swiper.viewControllers firstObject];
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        [self.delegate readModeContainerViewController:self didFinishedLoadingStory:self.story];
    }];
}

- (void)storyManager:(StoryManager *)manager failedToFetchStoryWithId:(NSUInteger)id{
    [TPAlert displayOnController:self.parentViewController withMessage:@"Impossible de charger l'histoire" delegate:self];
}

#pragma mark - TPAlert

- (void)alertDidAknowledge:(TPAlert *)alert {
    [self close];
}

#pragma mark - ReadModeViewController delegation

- (void)readModeViewController:(ReadModeViewController *)controller requestedToQuitStoryAtPage:(Page *)page{
    [self close];
}

- (void)readModeViewController:(ReadModeViewController *)controller didFinishReadingPage:(Page *)page {
    NSLog(@"%d / %lu", controller.idx, (unsigned long)[self.story.pages count]);
    if (controller.idx < [self.story.pages count] - 1) {
       [self.swiper setSelectedViewControllerViewControllerAtIndex:controller.idx+1];
        //ReadModeViewController* next = (ReadModeViewController*)self.swiper.viewControllers[controller.idx+1];
        //[next.player performSelector:@selector(play) withObject:nil afterDelay:.5f];
        //[next.moviePlayer performSelector:@selector(play) withObject:nil afterDelay:.5f];
    } else if (self.currentController.idx == [self.story.pages count] - 1) {
        // end
        [self performSelector:@selector(close) withObject:nil afterDelay:.5f];
    }
}

- (void)loadMediaAndAudioInPages:(NSArray *)pages atIndex:(NSUInteger)index withCompletion:(void(^)())completion{
    
    Page *page = [pages objectAtIndex:index];
    //Files
    NSString* fileUrl = page.audio.file;
    
    NSURL *mediaURL = [NSURL URLWithString:page.media.file];
    
    [self loadMediaWithURL:mediaURL atIndex:(NSUInteger)index withCompletion:^{
        [self loadAudioWithFileURL:fileUrl atIndex:(NSUInteger)index withCompletion:^(NSUInteger idx){
            NSLog(@"loadedPage %lu/%lu", (unsigned long)idx, (unsigned long)[pages count]);
            idx++;
            
            if(idx < [pages count]){
                [self loadMediaAndAudioInPages:pages atIndex:idx withCompletion:completion];
            }else{
                completion();
            }
        }];
    }];
}

- (void)loadMediaWithURL:(NSURL*)url atIndex:(NSUInteger)index withCompletion:(void(^)())completion{
    
    NSString* extension = [url pathExtension];
    
    if ([extension isEqualToString:@"jpg"]) {
        //NSLog(@"loadMediaWithURL %@",url);
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:url
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                 // progression tracking code
                                 NSLog(@"loadedImage %lu/%lu of file %@", (long)receivedSize,(long)expectedSize, url);
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (image) {
                                    // UIImage* full = [ImageUtils convertImageToGrayScale:[UIImage imageWithCGImage:[[asset defaultRepresentation]fullScreenImage]]];
                                    
                                    // error handling
                                    if (error) {
                                        [self.delegate readModeContainerViewController:self failedToCompleteLoadStory:self.story];
                                    }
                                    
                                    
                                    [self.mediaFiles addObject:image];
                                    completion();
                                }
                            }];
    } else { // video
        [FileDownLoader downloadFileWithURL:[url absoluteString] completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            
            // error handling
            if (error) {
                [self.delegate readModeContainerViewController:self failedToCompleteLoadStory:self.story];
            }
            
            
            [self.mediaFiles addObject:filePath];
            completion();
            
        }];
    }
    
    
}

- (void)loadAudioWithFileURL:(NSString*)fileUrl atIndex:(NSUInteger)index withCompletion:(void(^)(NSUInteger idx))completion{
    [FileDownLoader downloadFileWithURL:fileUrl completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        NSLog(@"%@", filePath);
        
        // error handling
        if (!filePath) {
            [self.delegate readModeContainerViewController:self failedToCompleteLoadStory:self.story];
        }
        
        NSError* err = nil;
        AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithContentsOfURL:filePath error:&err];
        
        if (err) { NSLog(@"%@", err); }
        
        [self.audioPlayers addObject:player];
        completion(index);
    }];
}


@end
