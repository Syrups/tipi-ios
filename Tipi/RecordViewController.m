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

@implementation RecordViewController {
    UIView* fakeNextView;
}

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
    
    [self swipableViewController:self.swipablePager didFinishedTransitionToViewController:self.swipablePager.viewControllers[0]];
    
    if ([self.recorder isComplete]) {
        self.finishButton.hidden = NO;
    }
    
    [self displayCoachmarkForDrag];
    
    
    // fun easter egg
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(applySticker:)];
    tap.numberOfTapsRequired = 3;
    tap.numberOfTouchesRequired = 2;

    [self.view addGestureRecognizer:tap];
}

- (void)applySticker:(UITapGestureRecognizer*)recognizer {
    
    UIImage* sticker = [UIImage imageNamed:[NSString stringWithFormat:@"sticker%d", arc4random_uniform(2)]];
    UIImage* image = [self currentPage].tiltingView.image;
    
    UIImage* newImage = [ImageUtils combineImage:image withImage:sticker withPosition:CGPointMake(200, 200)];
    
    TPTiltingImageView* newTiltingView = [[TPTiltingImageView alloc] initWithFrame:[self currentPage].tiltingView.frame andImage:newImage];
    [[self currentPage].tiltingView removeFromSuperview];
    [[self currentPage].view addSubview:newTiltingView];
    [[self currentPage].view sendSubviewToBack:newTiltingView];
    
    NSMutableDictionary* media = [self.saver.medias objectAtIndex:self.currentIndex];
    [media setObject:newImage forKey:@"full"];
}

- (void)displayCoachmarkForDrag {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kCookieCoachmarkKey] == nil) {
        [PKAIDecoder builAnimatedImageIn:self.coachmarkSprite fromFile:@"help-drag" withAnimationDuration:3];
        self.helpLabel.text = NSLocalizedString(@"Déplacez les vignettes pour réorganiser votre histoire", nil);
    
        [UIView animateWithDuration:.2f animations:^{
            self.overlay.alpha = .85f;
            self.helpLabel.alpha = 1;
        }];
        
        [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(displayCoachmarkForRecord) userInfo:nil repeats:NO];
    }
    
}

- (void)displayCoachmarkForRecord {
    [PKAIDecoder builAnimatedImageIn:self.coachmarkSprite fromFile:@"help-record" withAnimationDuration:3];
    self.helpLabel.text = NSLocalizedString(@"Appuyez sur l'image actuelle pour enregistrer votre voix sur celle-ci", nil);
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kCookieCoachmarkKey];
    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(hideCoachmark) userInfo:nil repeats:NO];
}

- (void)hideCoachmark {
    [UIView animateWithDuration:.2f animations:^{
        self.overlay.alpha = 0;
        self.helpLabel.alpha = 0;
    } completion:^(BOOL finished) {
        self.coachmarkSprite.animationImages = [NSArray array];
    }];
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
        controller.view.frame = self.view.frame;
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

- (IBAction)finish:(id)sender {
    [self openDonePopin];
}

#pragma mark - StoryMediaRecorder

- (void)mediaRecorder:(StoryMediaRecorder *)recorder hasAudioReceived:(float **)buffer withBufferSize:(UInt32)bufferSize withNumberOfChannels:(UInt32)numberOfChannels {
    
    [[self currentPage].recordTimer updateWithBuffer:buffer bufferSize:bufferSize withNumberOfChannels:numberOfChannels];
}

#pragma mark - UILongPressGestureRecognizer

- (void)handleLongPress:(UILongPressGestureRecognizer*)recognizer {
    
    RecordPageViewController* current = [self currentPage];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        self.overlay.alpha = 0;
        self.coachmarkSprite.alpha = 0;
        self.coachmarkSprite.animationImages = [NSArray array];
        self.helpLabel.alpha = 0;
        
        
        NSLog(@"begin touch index: %lu", (unsigned long)self.currentIndex);
        [self.recorder startRecording];
        
//        [CoachmarkManager dismissCoachmarkAnimationForRecordController:self];
        
        if (!current.recordTimer.appeared) {
            current.replayButton.transform = CGAffineTransformMakeScale(0, 0);
            current.recordTimer.hidden = NO;
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
            self.finishButton.hidden = NO;
        }
        
        // hint
        
        [UIView animateWithDuration:.3f animations:^{
            current.overlay.alpha = 0;
//            self.organizerContainerYConstraint.constant = 0;
            
//            if (current.pageIndex != self.saver.medias.count-1)
//                current.view.transform = CGAffineTransformMakeTranslation(-35, 0);
//            
//            fakeNextView = [[self viewControllerAtIndex:self.currentIndex+1] view];
//            fakeNextView.transform = CGAffineTransformMakeScale(.9f, .9f);
//            [self.swipablePager.privateContainerView addSubview:fakeNextView];
//            [self.swipablePager.privateContainerView sendSubviewToBack:fakeNextView];
            
            self.organizerContainerView.alpha = 1;
        }];
        
        if ([self currentPage].moviePlayer != nil) {
            [[self currentPage].moviePlayer pause];
        }
        
        [UIView animateWithDuration:.3f animations:^{
            current.overlay.alpha = 0;
            self.organizerContainerView.alpha = 1;
        }];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (CGRectContainsPoint(CGRectMake(0, self.view.frame.size.height - CELL_SIZE - 30, self.view.frame.size.width, CELL_SIZE + 30), [touch locationInView:self.view]))
        return NO;
    
    return YES;
}

#pragma mark - Navigation and view controller


- (void)swipableViewController:(TPSwipableViewController *)containerViewController didFinishedTransitionToViewController:(RecordPageViewController *)viewController {
    

    RecordPageViewController* old = [self viewControllerAtIndex:self.currentIndex];
    [old.tiltingView disable];
    
    self.currentIndex = viewController.pageIndex;
    
    if (self.currentIndex != self.saver.medias.count-1) {
        self.lastPage = NO;
    }
    
    [viewController.tiltingView enable];
    
    viewController.replayButton.transform = ![self.recorder hasRecordedAtIndex:self.currentIndex] ? CGAffineTransformMakeScale(0, 0) : CGAffineTransformMakeScale(1, 1);
    viewController.recordTimer.hidden = [self.recorder hasRecordedAtIndex:self.currentIndex];
    [viewController.recordTimer reset];
    
    if (![self.recorder hasRecordedAtIndex:self.currentIndex] && !viewController.recordTimer.appeared) {
        [viewController.recordTimer appear];
    }
    
    viewController.overlay.alpha = 0;
    [self.recorder.player fadeOutPause];
    [self.recorder setupForMediaWithIndex:self.currentIndex];
        
}

- (RecordPageViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.saver.medias count] == 0) || (index >= [self.saver.medias count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    RecordPageViewController *page = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordPage"];
//    page.view.frame = self.view.frame;
    page.next = [self viewControllerAtIndex:index+1];
    page.pageIndex = index;
    
    [PKAIDecoder builAnimatedImageInButton:page.replayButton fromFile:@"replay-appear" withColor:nil withAnimationDuration:.5f];
    
//    page.replayButton.transform = CGAffineTransformMakeScale(0, 0);
    
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
        
        NSMutableDictionary* media = [self.saver.medias objectAtIndex:index];
        
        if ([media objectForKey:@"full"] == nil) {
            ALAsset* a = (ALAsset*)[media objectForKey:@"asset"];
            
            if (index == 0) {
                UIImage* full = [UIImage imageWithCGImage:[[a defaultRepresentation] fullScreenImage]];
                full = [ImageUtils compressImage:full withQuality:.5f];
                [media setObject:full forKey:@"full"];
                page.image = full;
            }
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                UIImage* full = [UIImage imageWithCGImage:[[a defaultRepresentation] fullScreenImage]];
                full = [ImageUtils compressImage:full withQuality:.5f];
                [media setObject:full forKey:@"full"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    page.image = full;
                });
            });
            
        } else {
            page.image = (UIImage*)[media objectForKey:@"full"];
        }
        
        
        
        AVPlayerLayer* playerLayer = [AVPlayerLayer playerLayerWithPlayer:page.moviePlayer];
        page.moviePlayerLayer = playerLayer;
        page.moviePlayer.volume = 0;
        playerLayer.frame = self.view.frame;
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [page.view.layer insertSublayer:playerLayer atIndex:0];
        
        [page.view bringSubviewToFront:page.replayButton];
        [page.view bringSubviewToFront:page.recordTimer];
    } else {
        NSMutableDictionary* media = [self.saver.medias objectAtIndex:index];
        
        if ([media objectForKey:@"full"] == nil) {
            ALAsset* a = (ALAsset*)[media objectForKey:@"asset"];
            
            UIImage* full = [UIImage imageWithCGImage:[[a defaultRepresentation] fullScreenImage]];
            full = [ImageUtils compressImage:full withQuality:.5f];
            [media setObject:full forKey:@"full"];
            page.image = full;
            
            
        } else {
            page.image = (UIImage*)[media objectForKey:@"full"];
        }
    }
        
    return page;
}

#pragma mark - Navigation

- (void)moveViewControllerfromIndex:(NSUInteger)oldIndex atIndex:(NSUInteger)newIndex {
    
//    NSLog(@"%d ----> %d", oldIndex, newIndex);
    
    if (self.currentIndex == oldIndex) {
        self.currentIndex = newIndex;
    } else {
        if (oldIndex > self.currentIndex && newIndex <= self.currentIndex) {
            self.currentIndex++;
        }
        if (oldIndex < self.currentIndex && newIndex >= self.currentIndex) {
            self.currentIndex--;
        }
    }
    
//    NSLog(@"New current index: %d", self.currentIndex);
    
    [self.swipablePager moveViewController:[self.swipablePager.viewControllers objectAtIndex:oldIndex] fromIndex:oldIndex atIndex:newIndex];
}

- (void)removeViewControllerAtIndex:(NSUInteger)index {
    NSMutableArray* mutableControllers = [self.swipablePager.viewControllers mutableCopy];
    
    for (CardViewController* vc in mutableControllers) {
        if (vc.pageIndex > index) {
            vc.pageIndex = vc.pageIndex - 1;
        }
    }
    
    [mutableControllers removeObjectAtIndex:index];
    
    [self.recorder deleteAudioFileWithIndex:index];
    
    if (self.currentIndex > index) self.currentIndex--;
    
    self.swipablePager.viewControllers = [mutableControllers copy];
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
