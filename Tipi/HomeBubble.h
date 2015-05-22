//
//  HomeBubble.h
//  Wireframe
//
//  Created by Leo on 28/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeBubble : UIView

@property BOOL expanded;

- (void)appear;
- (void)expand;
- (void)reduceWithCompletion:(void(^)())completionBlock backgroundFading:(BOOL)fading;
- (void)expandWithCompletion:(void(^)())completionBlock backgroundFading:(BOOL)fading;
- (void)stickTopTopWithCompletion:(void(^)())completionBlock;

@end
