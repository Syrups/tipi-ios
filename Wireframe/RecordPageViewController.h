//
//  RecordPageViewController.h
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface RecordPageViewController : UIViewController

@property NSUInteger pageIndex;
@property BOOL recorded;

@property (strong, nonatomic) UIImage* image;
@property (strong, nonatomic) IBOutlet UIImageView* imageView;
@property (strong, nonatomic) AVPlayer* moviePlayer;
@property (strong, nonatomic) AVPlayerLayer* moviePlayerLayer;

@end
