//
//  RoomRevealWrapperViewController.h
//  Wireframe
//
//  Created by Glenn Sonna on 02/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "SWRevealViewController.h"
#import "Room.h"

@interface RoomRevealWrapperViewController : SWRevealViewController
@property (strong, nonatomic) Room* room;
@end
