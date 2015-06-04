//
//  RecordPageViewController.h
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>
#import "CardViewController.h"
#import "SRRecordButton.h"

@interface RecordPageViewController : CardViewController

@property BOOL recorded;

@property (strong, nonatomic) UIImage* image;
@property (strong, nonatomic) IBOutlet UIImageView* imageView;
@property (strong, nonatomic) AVPlayer* moviePlayer;
@property (strong, nonatomic) AVPlayerLayer* moviePlayerLayer;
@property (strong, nonatomic) CMMotionManager* motionManager;
@property BOOL imagePanningEnabled;

@property (strong, nonatomic) IBOutlet SRRecordButton* recordTimer;
@property (strong, nonatomic) IBOutlet UIButton* replayButton;
@property (strong, nonatomic) IBOutlet UIView* overlay;

@end
