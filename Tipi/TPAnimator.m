//
//  TPAnimator.m
//  Tipi
//
//  Created by Glenn Sonna on 10/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "TPAnimator.h"

@implementation TPAnimator

- (instancetype)initWithOperation:(UINavigationControllerOperation)operation
{
    self = [super init];
    if (self) {
        self.operation = operation;
    }
    return self;
}
@end
