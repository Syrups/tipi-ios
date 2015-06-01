//
//  CoachmarkManager.h
//  Tipi
//
//  Created by Leo on 01/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrganizeStoryViewController.h"
#import "RecordViewController.h"

@interface CoachmarkManager : NSObject

+ (void)launchCoachmarkAnimationForOrganizerController:(OrganizeStoryViewController*)controller;
+ (void)launchCoachmarkAnimationForRecordController:(RecordViewController *)controller;

@end
