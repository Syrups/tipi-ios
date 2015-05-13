//
//  TPStoryTableViewCell.m
//  Wireframe
//
//  Created by Glenn Sonna on 13/05/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "TPStoryTableViewCell.h"

@implementation TPStoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

-(void)layoutSubviews{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureRecognizer:)];
    panGesture.delegate = self;
    [self addGestureRecognizer:panGesture];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.baseX = self.transform.tx;
}


- (void)setEditMode:(BOOL)editMode{
    
    UILabel* label = (UILabel*)[self.contentView viewWithTag:10];
    UIButton* delete = (UIButton*)[self.contentView viewWithTag:30];
    
    [UIView animateWithDuration:.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        label.transform = !editMode? CGAffineTransformIdentity : CGAffineTransformMakeTranslation(100, 0);
        label.alpha = !editMode?1 : .3f;
        delete.alpha = !editMode?0 : 1;
    } completion:^(BOOL finished) {
        _editMode = editMode;
    }];
}

- (void)swipeGestureRecognizer:(UIPanGestureRecognizer*)gestureRecognizer {
    
    
    UILabel* label = (UILabel*)[self.contentView viewWithTag:10];
    UIButton* delete = (UIButton*)[self.contentView viewWithTag:30];
    
    CGPoint translation = [gestureRecognizer translationInView:self];
    CGPoint velocity = [gestureRecognizer velocityInView:self];
    
    BOOL toRight = velocity.x > 0;
    BOOL toLeft = velocity.x < 0;
    
    int endX = (self.baseX + 100);
    int midEndX = endX / 2;
    
    //NSLog(@"Panned with translation point: %@: %@", NSStringFromCGPoint(translation), toRight ? @"->" : @"<-");
    
    switch(gestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan :{
            [UIView animateWithDuration:.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                label.transform = CGAffineTransformIdentity;
                label.alpha = 1;
                delete.alpha = 0.5;
            } completion:nil];
            //[self setEditMode:NO];
        }
            break;
        case UIGestureRecognizerStateChanged :{
            
            if ((toRight && label.transform.tx < endX)){
                label.transform = CGAffineTransformMakeTranslation(translation.x, 0);
            }else if(toLeft && (label.transform.tx > self.baseX)){
                label.transform = CGAffineTransformMakeTranslation(translation.x, 0);
            }
        }
            break;
        case UIGestureRecognizerStateEnded :
            [self setEditMode:(label.transform.tx > midEndX)];
            break;
            
        default :
            
            break;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer
{
    CGPoint translation = [panGestureRecognizer translationInView:[self superview] ];
    return (fabs(translation.x) / fabs(translation.y) > 1) ? YES : NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


@end
