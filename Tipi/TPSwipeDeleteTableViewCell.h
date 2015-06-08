//
//  TPSwipeDeleteTableViewCell.h
//  Tipi
//
//  Created by Glenn Sonna on 08/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPSwipeDeleteTableViewCell : UITableViewCell

@property int baseX;
@property (nonatomic) BOOL editMode;
@property (nonatomic) BOOL isSwipeDeleteEnabled;

@property (weak, nonatomic) IBOutlet UIView *aboveView;
@property (weak, nonatomic) IBOutlet UIView *belowView;

@end
