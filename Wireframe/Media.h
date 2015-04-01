//
//  Media.h
//  Wireframe
//
//  Created by Leo on 01/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "JSONModel.h"

@interface Media : JSONModel

@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) NSString* file;

@end

@protocol Media <NSObject>
@end