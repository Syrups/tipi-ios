//
//  User.h
//  Wireframe
//
//  Created by Leo on 18/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "JSONModel.h"

@interface User : JSONModel

@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) NSString* token;

@end

@protocol User <NSObject>
@end
