//
//  SettingsViewController.h
//  Wireframe
//
//  Created by Leo on 28/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPAlert.h"
#import "UserManager.h"

@interface SettingsViewController : UIViewController <TPAlertDelegate, UserDeleterDelegate>

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray* rows;

@end
