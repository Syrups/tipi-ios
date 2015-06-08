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
    
//    CGSize textSize = [[self.nameLabel text] sizeWithAttributes:@{NSFontAttributeName:[self.nameLabel font]}];
//    _nameLabelWidth.constant =  textSize.width;
}

-(void)updateState{
    
    CGSize textSize = [[self.nameLabel text] sizeWithAttributes:@{NSFontAttributeName:[self.nameLabel font]}];
    [self layoutIfNeeded];
   
    _circleContainerWidth.constant = self.unRolled ? (textSize.width + 30) : 40;
    _nameLabelWidth.constant =  textSize.width;
    
    [UIView animateWithDuration:.4f animations:^{
       [self layoutIfNeeded];
        // Forces the layout of the subtree animation block and then captures all of the frame changes
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
