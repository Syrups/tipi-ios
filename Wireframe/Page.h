//
//  Page.h
//  Wireframe
//
//  Created by Leo on 20/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "JSONModel.h"

@interface Page : JSONModel

@property (strong, nonatomic) NSString* id;
//@property (assign, nonatomic) NSUInteger duration;
//@property (assign, nonatomic) NSUInteger position;

@end

@protocol Page <NSObject>
@end