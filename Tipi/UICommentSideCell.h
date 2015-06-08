//
//  UICommentSideCell.h
//  Wireframe
//
//  Created by Glenn Sonna on 19/05/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICommentSideCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *circleContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *circleContainerWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelWidth;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic) BOOL unRolled;

-(void)updateState;
@end
