//
//  UIRoomTableViewCell.h
//  Wireframe
//
//  Created by Glenn Sonna on 20/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPSwipeDeleteTableViewCell.h"

@interface UIRoomTableViewCell : TPSwipeDeleteTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picto;
@property (weak, nonatomic) IBOutlet UILabel *roomName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@end
