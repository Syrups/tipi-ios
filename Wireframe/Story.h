//
//  Story.h
//  Wireframe
//
//  Created by Leo on 19/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "JSONModel.h"

@interface Story : JSONModel

@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) NSString* title;

@end
