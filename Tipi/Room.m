//
//  Room.m
//  Wireframe
//
//  Created by Leo on 19/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "Room.h"

@implementation Room

- (BOOL)isAdmin:(User *)user {
    return [user.id isEqualToString:self.owner.id];
}

@end
