//
//  NameStoryViewController.h
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"

@interface NameStoryViewController : UIViewController <UITextFieldDelegate, TagFetcherDelegate>

@property (strong, nonatomic) IBOutlet UITextField* titleField;
@property (strong, nonatomic) IBOutlet UIButton* latestTagLabel;

@end
