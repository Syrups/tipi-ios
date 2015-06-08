//
//  ReviewPageViewController.h
//  Wireframe
//
//  Created by Leo on 22/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardViewController.h"
#import "TPTiltingImageView.h"

@interface ReviewPageViewController : CardViewController

@property NSUInteger pageIndex;
@property (strong, nonatomic) IBOutlet UIImageView* image;
@property (strong, nonatomic) IBOutlet TPTiltingImageView* tiltingImageView;

@end
