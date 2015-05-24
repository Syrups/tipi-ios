//
//  UIViewTouchUnder.m
//  Tipi
//
//  Created by Glenn Sonna on 22/05/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "UIViewTouchUnder.h"
#import "TPSideCommentsView.h"

@implementation UIViewTouchUnder

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([self isKindOfClass:[TPSideCommentsView class]]){
        NSArray *cells = [((TPSideCommentsView*)self).commentsList visibleCells];
        for (UITableViewCell* cell in  cells) {
            if ( [cell.contentView hitTest:[self convertPoint:point toView:cell.contentView] withEvent:event] != nil ) {
                return YES;
            }
        }
    }else{
        for (UIView* subview in self.subviews ) {
            if ( [subview hitTest:[self convertPoint:point toView:subview] withEvent:event] != nil ) {
                return YES;
            }
        }
    }
    
    return NO;
}

@end
