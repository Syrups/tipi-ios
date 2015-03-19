//
//  BaseManager.m
//  Wireframe
//
//  Created by Leo on 18/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "BaseManager.h"

@implementation BaseManager

- (id)initWithDelegate:(id)delegate {
    self = [super init];
    
    if (self) {
        self.delegate = delegate;
    }
    
    return self;
}

@end
