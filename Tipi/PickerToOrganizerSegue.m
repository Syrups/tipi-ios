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
#import "TPLoader.h"

@implementation PickerToOrganizerSegue

- (void)perform {
    
    MediaPickerViewController* source = self.sourceViewController;
    OrganizeStoryViewController* dest = self.destinationViewController;
    
    __block TPLoader* loader = [[TPLoader alloc] initWithFrame:source.view.frame];
    [source.view addSubview:loader];
//    loader.infoLabel.text = @"Chargement des photos...";
    
    CGFloat midY = source.mediaCollectionView.contentOffset.y + source.view.frame.size.height/2 - CELL_SIZE/2 - 18; // CELL_SIZE defined in OrganizeStoryViewController.h
    CGFloat origX = source.view.frame.size.width/2 - CELL_SIZE/2 - 24;
    
    __block NSUInteger i = 0;
    
    [source.mediaCollectionView.visibleCells enumerateObjectsUsingBlock:^(UICollectionViewCell* cell, NSUInteger idx, BOOL *stop) {
        NSIndexPath* indexPath = [source.mediaCollectionView indexPathForCell:cell];
        
        if (![source.selectedIndexes containsObject:indexPath]) {
            [UIView animateWithDuration:.3f animations:^{
                cell.alpha = 0;
            }];
        }
    }];
    
    [source.selectedIndexes enumerateObjectsUsingBlock:^(NSIndexPath* indexPath, NSUInteger idx, BOOL *stop) {
        UICollectionViewCell* cell = [source.mediaCollectionView cellForItemAtIndexPath:indexPath];
        [UIView animateWithDuration:.3f animations:^{
            [cell.contentView viewWithTag:30].alpha = 0; // checkmark
            
            if (indexPath && ![source.selectedIndexes containsObject:indexPath]) {
                cell.alpha = 0;
            } else {
                cell.frame = CGRectMake(origX + i * (CELL_SIZE + 10), midY, CELL_SIZE, CELL_SIZE);
                ++i;
            }
        } completion:^(BOOL finished) {
            if (idx == source.selectedIndexes.count/2) {
                NSLog(@"here");
                [source.navigationController pushViewController:dest animated:NO];
                
                dest.replayButton.transform = CGAffineTransformMakeScale(0, 0);
                [UIView animateWithDuration:.3f animations:^{
                    dest.replayButton.transform = CGAffineTransformIdentity;
                }];
                
                // reset previous VC layout
                
                [source.mediaCollectionView reloadData];
                [loader removeFromSuperview];
            }
        }];
    }];

    [UIView animateWithDuration:.3f animations:^{
        source.continueButtonYConstraint.constant -= 100;
        [source.view layoutIfNeeded];
    }];
    
}

@end
