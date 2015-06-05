//
//  WalkthroughScreenViewController.h
//  Wireframe
//
//  Created by Leo on 28/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardViewController.h"

@interface WalkthroughScreenViewController : CardViewController

@property NSUInteger index;
@property (strong, nonatomic) IBOutlet UIView* screenView;
@property (strong, nonatomic) IBOutlet UIColor* backgroundColor;

@end
