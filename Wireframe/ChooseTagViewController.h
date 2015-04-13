//
//  ChooseTagViewController.h
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NameStoryViewController.h"
#import "UserManager.h"

@interface ChooseTagViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, TagFetcherDelegate>

@property (strong, nonatomic) NSMutableArray* tags;
@property (strong, nonatomic) IBOutlet UITableView* tagsTableView;

@end
