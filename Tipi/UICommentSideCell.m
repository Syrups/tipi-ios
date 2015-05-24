//
//  UICommentSideCell.m
//  Wireframe
//
//  Created by Glenn Sonna on 19/05/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "UICommentSideCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation UICommentSideCell

- (void)awakeFromNib {
    // Initialization code
    self.unRolled = NO;
   
}

-(void)updateState{
    
    self.unRolled = !self.unRolled;
    
    [self.contentView layoutIfNeeded]; // Ensures that all pending layout operations have been completed
    [UIView animateWithDuration:.5f animations:^{
        self.circleContainerWidth.constant = self.unRolled ? 100 : 40;
        self.capLabel.alpha = self.unRolled ? 0 : 1;
        self.fullNameLabel.alpha = self.unRolled ? 1 : 0;
        
        [self.contentView layoutIfNeeded]; // Forces the layout of the subtree animation block and then captures all of the frame changes
    }];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
