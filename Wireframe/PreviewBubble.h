//
//  PreviewBubble.h
//  Wireframe
//
//  Created by Leo on 15/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewBubble : UIView

@property (weak) id delegate;
@property BOOL hidden;
@property BOOL expanded;

- (void)updateWithImage:(UIImage*)image;
- (void)appearWithCompletion:(void(^)())completionBlock;
- (void)hideWithCompletion:(void(^)())completionBlock;
- (void)close;
- (void)expandWithCompletion:(void(^)())completionBlock;

@end

@protocol PreviewBubbleDelegate <NSObject>

- (void)previewBubbleDidDragToExpand:(PreviewBubble*)bubble;

@end
