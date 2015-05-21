//
//  TPStoryTableViewCell.h
//  Wireframe
//
//  Created by Glenn Sonna on 13/05/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPStoryTableViewCell : UITableViewCell<UIGestureRecognizerDelegate>
@property int baseX;
@property (nonatomic)BOOL editMode;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
