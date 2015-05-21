//
//  Page.h
//  Wireframe
//
//  Created by Leo on 20/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "JSONModel.h"
#import "Audio.h"
#import "Media.h"
#import "Comment.h"

@interface Page : JSONModel

@property (strong, nonatomic) NSString* id;
//@property (assign, nonatomic) NSUInteger duration;
//@property (assign, nonatomic) NSUInteger position;
@property (strong, nonatomic) Audio<Optional>* audio;
@property (strong, nonatomic) Media<Optional>* media;
@property (strong, nonatomic) NSArray<Comment, Optional>* comments;

@end

@protocol Page <NSObject>
@end