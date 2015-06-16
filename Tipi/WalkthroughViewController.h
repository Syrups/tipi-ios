//
//  WalkthroughViewController.h
//  Wireframe
//
//  Created by Leo on 28/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPSwipableViewController.h"

@interface WalkthroughViewController : UIViewController <TPSwipableViewControllerDelegate>

@property NSUInteger currentIndex;
@property (strong, nonatomic) TPSwipableViewController* tps;

@end
