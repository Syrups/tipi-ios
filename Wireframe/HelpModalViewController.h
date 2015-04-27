//
//  HelpModalViewController.h
//  Wireframe
//
//  Created by Leo on 24/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpModalViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel* helpLabel;
@property (weak, nonatomic) UIViewController* currentParentController;

@end
