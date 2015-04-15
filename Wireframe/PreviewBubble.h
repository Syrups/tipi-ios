//
//  PreviewBubble.h
//  Wireframe
//
//  Created by Leo on 15/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewBubble : UIView

@property BOOL hidden;
@property BOOL expanded;

- (void)updateWithImage:(UIImage*)image;
- (void)appear;
- (void)hide;
- (void)close;
- (void)expandWithCompletion:(void(^)())completionBlock;

@end
