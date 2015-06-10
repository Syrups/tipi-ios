//
//  DeleteStoryModalViewController.h
//  Tipi
//
//  Created by Leo on 10/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryManager.h"

@interface DeleteStoryModalViewController : UIViewController <StoryDeleterDelegate>

@property (strong, nonatomic) Story* story;
@property (strong, nonatomic) Room* room;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* centerYConstraint;

@end
