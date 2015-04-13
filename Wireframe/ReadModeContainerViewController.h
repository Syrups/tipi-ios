//
//  ReadModeContainerViewController.h
//  Wireframe
//
//  Created by Glenn Sonna on 05/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryManager.h"
@import AVFoundation;
@import AudioToolbox;

@interface ReadModeContainerViewController : UIViewController<UIPageViewControllerDataSource, StoryFetcherDelegate>

@property (nonatomic, strong) UIPageViewController *pager;
@property (strong, nonatomic) NSArray *mPages;
@property (nonatomic ) NSUInteger storyId;
@property (nonatomic ) Story *story;
@property (nonatomic, strong) AVAudioPlayer* player;



- (void)playSound:(NSURL*)filePath;
@end
