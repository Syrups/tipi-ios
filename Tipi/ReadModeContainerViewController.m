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
    newController.page = [self.mPages objectAtIndex:i];
    newController.player = [self.audioPlayers objectAtIndex:i];
    newController.mediaImage = [self.mediaFiles objectAtIndex:i];
    newController.delegate = self;
    newController.next = [self viewControllerAtIndex:i+1];
    
    
    return newController;
}


- (NSArray *)readmodeControllersWithPages:(NSArray*)pages {
    
    NSMutableArray *childViewControllers = [[NSMutableArray alloc] initWithCapacity:[pages count]];
    
    for (int i = 0; i < [pages count]; i++) {
        [childViewControllers addObject:[self viewControllerAtIndex:i]];
    }
    
    return childViewControllers;
}


#pragma mark - TPSwipableViewController

- (void)swipableViewController:(TPSwipableViewController *)containerViewController didFinishedTransitionToViewController:(UIViewController *)viewController{
    ReadModeViewController *currentController = (ReadModeViewController *)viewController;
    
    if(currentController.player.isPlaying){
        [currentController pauseSound];
    }
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
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        [self.delegate readModeContainerViewController:self didFinishedLoadingStory:self.story];
    }];
}

- (void)storyManager:(StoryManager *)manager failedToFetchStoryWithId:(NSUInteger)id{
    
}

- (void)readModeViewController:(ReadModeViewController *)controller requestedToQuitStoryAtPage:(Page *)page{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)loadMediaAndAudioInPages:(NSArray *)pages atIndex:(NSUInteger)index withCompletion:(void(^)())completion{
    
    
    Page *page = [pages objectAtIndex:index];
    //Files
    NSString* fileUrl = page.audio.file;
    
    NSURL *mediaURL = [NSURL URLWithString:page.media.file];
    
    [self loadMediaWithURL:mediaURL atIndex:(NSUInteger)index withCompletion:^{
        [self loadAudioWithFileURL:fileUrl atIndex:(NSUInteger)index withCompletion:^(NSUInteger idx){
            NSLog(@"loadedPage %lu/%lu", (unsigned long)idx, [pages count]);
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
    //NSLog(@"loadMediaWithURL %@",url);
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

- (void)loadAudioWithFileURL:(NSString*)fileUrl atIndex:(NSUInteger)index withCompletion:(void(^)(NSUInteger idx))completion{
    [FileDownLoader downloadFileWithURL:fileUrl completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        
        [self.audioPlayers addObject:[[AVAudioPlayer alloc] initWithContentsOfURL:filePath error:nil]];
        completion(index);
    }];
}


@end
