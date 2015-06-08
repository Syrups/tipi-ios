//
//  Comment.h
//  Wireframe
//
//  Created by Leo on 03/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "JSONModel.h"
#import "User.h"
#import "Audio.h"

@interface Comment : JSONModel

@property (strong, nonatomic) User<Optional>* user;
@property (strong, nonatomic) NSString* file;
@property NSUInteger timecode;
@property NSUInteger duration;

@end

@protocol Comment <NSObject>
@end