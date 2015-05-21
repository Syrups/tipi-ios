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

@import AVFoundation;
@import AudioToolbox;

@interface ReadModeContainerViewController : UIViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate, ReadModeViewDelegate, StoryFetcherDelegate, EZMicrophoneDelegate, EZAudioFileDelegate>

@property (nonatomic, strong) UIPageViewController *pager;
@property (nonatomic) ReadModeViewController *currentPageViewController;
//@property (nonatomic) NSUInteger currentPageIndex;


@property (strong, nonatomic) NSArray *mPages;
@property (nonatomic ) NSUInteger storyId;
@property (nonatomic ) Story *story;
//@property (nonatomic) Page *currentPage;

@property (nonatomic, strong) NSMutableArray *soundsArray;

//@property (nonatomic, strong) AVAudioPlayer* player;
//@property (nonatomic, strong) NSTimer* audioListenTimer;


@end
