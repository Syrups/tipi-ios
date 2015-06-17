//
//  CreateRoomViewController.h
//  Wireframe
//
//  Created by Leo on 28/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomManager.h"
#import "ShowGroupsViewController.h"
#import "RoomPickerViewController.h"

@interface CreateRoomViewController : UIViewController <UITextFieldDelegate, RoomCreatorDelegate>

@property (strong, nonatomic) IBOutlet UITextField* roomNameField;
@property (strong, nonatomic) ShowGroupsViewController* roomsController;
@property (strong, nonatomic) RoomPickerViewController* roomsPicker;

@end
