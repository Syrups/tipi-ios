//
//  ReadStoryTransitionAnimator.h
//  Tipi
//
//  Created by Glenn Sonna on 02/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPAnimator.h"

@interface ReadStoryTransitionAnimator : TPAnimator <UIViewControllerAnimatedTransitioning>

@property (weak) id<UIViewControllerContextTransitioning> transitionContext;

@end
