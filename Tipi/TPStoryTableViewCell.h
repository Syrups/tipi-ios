//
//  TPStoryTableViewCell.h
//  Wireframe
//
//  Created by Glenn Sonna on 13/05/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPCircleWaverControl.h"
#import "TPSwipeDeleteTableViewCell.h"


@interface TPStoryTableViewCell : TPSwipeDeleteTableViewCell<UIGestureRecognizerDelegate>

@property id delegate;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet TPCircleWaverControl *recordButton;

@end
