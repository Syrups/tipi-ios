//
//  AbortModalViewController.h
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbortModalViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView* popin;
@property (strong, nonatomic) IBOutlet UIButton* saveButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* popinVerticalCenterConstraint;

@property (weak, nonatomic) UIViewController* currentParentController;

@end
