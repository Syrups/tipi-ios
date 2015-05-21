//
//  WaveToBottomTransitionAnimator.h
//  Wireframe
//
//  Created by Glenn Sonna on 06/05/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WaveToBottomTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@property (weak) id<UIViewControllerContextTransitioning> transitionContext;
@end
