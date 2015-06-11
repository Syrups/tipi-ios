//
//  WaveSwipeTransitionAnimator.h
//  Wireframe
//
//  Created by Glenn Sonna on 18/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

@import UIKit;
#import <Foundation/Foundation.h>
#import "TPAnimator.h"


@interface WaveSwipeTransitionAnimator : TPAnimator <UIViewControllerAnimatedTransitioning>

@property (weak) id<UIViewControllerContextTransitioning> transitionContext;

@end
