//
//  NameStoryViewController.h
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import <MLPAutoCompleteTextField/MLPAutoCompleteTextField.h>

@interface NameStoryViewController : UIViewController <UITextFieldDelegate, TagFetcherDelegate, MLPAutoCompleteTextFieldDataSource, MLPAutoCompleteTextFieldDelegate>

@property (strong, nonatomic) NSArray* latestTags;
@property (strong, nonatomic) IBOutlet UITextField* titleField;
@property (strong, nonatomic) IBOutlet UIButton* latestTagLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* centerYConstraint;

@end
