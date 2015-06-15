//
//  DeleteRoomModalViewController.h
//  Tipi
//
//  Created by Leo on 14/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomManager.h"

@interface DeleteRoomModalViewController : UIViewController <RoomDeleterDelegate>

@property (strong, nonatomic) Room* room;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* centerYConstraint;

@end
