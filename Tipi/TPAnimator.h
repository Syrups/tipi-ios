//
//  TPAnimator.h
//  Tipi
//
//  Created by Glenn Sonna on 10/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPAnimator : NSObject
@property (nonatomic) UINavigationControllerOperation operation;

- (instancetype)initWithOperation:(UINavigationControllerOperation)operation;
@end
