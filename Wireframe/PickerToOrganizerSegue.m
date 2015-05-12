//
//  PickerToOrganizerSegue.m
//  Wireframe
//
//  Created by Leo on 12/05/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "PickerToOrganizerSegue.h"
#import "OrganizeStoryViewController.h"
#import "MediaPickerViewController.h"

@implementation PickerToOrganizerSegue

- (void)perform {
    MediaPickerViewController* source = self.sourceViewController;
    OrganizeStoryViewController* dest = self.destinationViewController;
    
    NSUInteger count = source.mediaCollectionView.visibleCells.count;
    
    [source.mediaCollectionView.visibleCells enumerateObjectsUsingBlock:^(UICollectionViewCell* cell, NSUInteger idx, BOOL *stop) {
        
        [UIView animateWithDuration:.4f delay:(count - idx)*.03f options:UIViewAnimationOptionCurveEaseIn animations:^{
            cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y + 500, cell.frame.size.width, cell.frame.size.height);
        } completion:^(BOOL finished) {
            if (idx == source.mediaCollectionView.visibleCells.count-1) {
                [source.navigationController pushViewController:dest animated:NO];
                [dest animateAppearance];
            }
        }];
    }];
}

@end
