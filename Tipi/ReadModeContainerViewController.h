//
//  ReadModeContainerViewController.h
//  Wireframe
//
//  Created by Glenn Sonna on 05/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EZAudio/EZAudio.h>

#import "ReadModeViewController.h"
#import "TPSideCommentsView.h"

#import "StoryManager.h"

#import "TPSwipableViewController.h"

@import AVFoundation;
@import AudioToolbox;

@interface ReadModeContainerViewController : UIViewController<TPSwipableViewControllerDelegate, ReadModeViewDelegate, StoryFetcherDelegate, EZMicrophoneDelegate, EZAudioFileDelegate, TPAlertDelegate>

@property (weak, nonatomic) ReadModeViewController* currentController;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) NSUInteger loadedPagesCount;

@property (nonatomic, strong) TPSwipableViewController *swiper;

//@property (nonatomic) ReadModeViewController *currentPageViewController;
@property (nonatomic) CGRect textBaseFrame;
//@property (nonatomic) NSUInteger currentPageIndex;


@property (strong, nonatomic) NSArray *mPages;
@property (nonatomic ) NSUInteger storyId;
@property (nonatomic ) Story *story;
@property (nonatomic ) NSMutableArray *audioPlayers;
@property (nonatomic ) NSMutableArray *mediaFiles;
//@property (nonatomic) Page *currentPage;

@property (nonatomic, strong) NSMutableArray *soundsArray;

//@property (nonatomic, strong) AVAudioPlayer* player;
//@property (nonatomic, strong) NSTimer* audioListenTimer;

- (void)close;

@end

@protocol ReadModeContainerDelegate <NSObject>

@required
- (void)readModeContainerViewController:(ReadModeContainerViewController *)controller didFinishedLoadingStory: (Story*) story;
- (void)readModeContainerViewController:(ReadModeContainerViewController *)controller failedToCompleteLoadStory:(Story *)story;

@end
