//
//  Audio.h
//  Wireframe
//
//  Created by Leo on 01/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "JSONModel.h"

@interface Audio : JSONModel

@property (strong, nonatomic) NSString* file;
@property (strong, nonatomic) NSString<Optional>* duration;

@end

@protocol Audio <NSObject>
@end