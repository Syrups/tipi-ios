//
//  WaveToBottomTransitionAnimator.h
//  Wireframe
//
//  Created by Glenn Sonna on 06/05/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPAnimator.h"

@interface WaveToBottomTransitionAnimator : TPAnimator <UIViewControllerAnimatedTransitioning>
@property (weak) id<UIViewControllerContextTransitioning> transitionContext;

@end
