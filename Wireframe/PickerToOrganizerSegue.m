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
    CGFloat midY = source.view.frame.size.height/2 - CELL_SIZE/2; // CELL_SIZE defined in OrganizeStoryViewController.h
    CGFloat origX = source.view.frame.size.width;
    
    __block NSUInteger i = 0;
    
    [source.mediaCollectionView.visibleCells enumerateObjectsUsingBlock:^(UICollectionViewCell* cell, NSUInteger idx, BOOL *stop) {

        
        NSIndexPath* indexPath = [source.mediaCollectionView indexPathForCell:cell];
        
        [UIView animateWithDuration:.4f animations:^{
            [cell.contentView viewWithTag:30].alpha = 0; // checkmark
            
            if (indexPath && ![source.selectedIndexes containsObject:indexPath]) {
                cell.alpha = 0;
            } else {
                cell.frame = CGRectMake(origX + i * CELL_SIZE, midY, CELL_SIZE, CELL_SIZE);

                ++i;
            }
        } completion:^(BOOL finished) {
            if (idx == source.mediaCollectionView.visibleCells.count-1) {
                [source.navigationController pushViewController:dest animated:NO];
            }
        }];
        
    }];
}

@end
