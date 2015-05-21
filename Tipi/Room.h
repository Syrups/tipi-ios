//
//  Room.h
//  Wireframe
//
//  Created by Leo on 19/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "JSONModel.h"
#import "User.h"

@interface Room : JSONModel

@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSArray<User, Optional>* participants;
@property (strong, nonatomic) User* owner;

- (BOOL)isAdmin:(User*)user;

@end
