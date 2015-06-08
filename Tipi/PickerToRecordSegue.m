//
//  PickerToRecordSegue.m
//  Tipi
//
//  Created by Leo on 05/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "PickerToRecordSegue.h"
#import "TPLoader.h"
#import "MediaPickerViewController.h"
#import "RecordViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation PickerToRecordSegue

- (void)perform {
    MediaPickerViewController* source = (MediaPickerViewController*)self.sourceViewController;
    RecordViewController* dest = (RecordViewController*)self.destinationViewController;
    
    CGFloat origX = source.view.frame.size.width/2 - CELL_SIZE/2 - 24;
    
    NSMutableArray* hiddenCells = [NSMutableArray array];
    
    TPLoader* loader = [[TPLoader alloc] initWithFrame:source.view.frame];
    loader.backgroundColor = [UIColor clearColor];
    [source.view addSubview:loader];
    
    __block NSUInteger i = 0;
    
    [source.mediaCollectionView.visibleCells enumerateObjectsUsingBlock:^(UICollectionViewCell* cell, NSUInteger idx, BOOL *stop) {
        NSIndexPath* indexPath = [source.mediaCollectionView indexPathForCell:cell];
        
        if (![source.selectedIndexes containsObject:indexPath]) {
            [hiddenCells addObject:cell];
            [UIView animateWithDuration:.3f animations:^{
                cell.alpha = 0;
            }];
        }
    }];
    
    [source.selectedIndexes enumerateObjectsUsingBlock:^(NSIndexPath* indexPath, NSUInteger idx, BOOL *stop) {
        UICollectionViewCell* cell = [source.mediaCollectionView cellForItemAtIndexPath:indexPath];
        [UIView animateWithDuration:.5f animations:^{
            [cell.contentView viewWithTag:30].alpha = 0; // checkmark
            
            if (indexPath && ![source.selectedIndexes containsObject:indexPath]) {
                cell.alpha = 0;
                [hiddenCells addObject:cell];
            } else {
                cell.frame = CGRectMake(origX + i * (CELL_SIZE + 5), source.mediaCollectionView.contentOffset.y + source.view.frame.size.height - CELL_SIZE - 30, CELL_SIZE, CELL_SIZE);
                ++i;
            }
        } completion:^(BOOL finished) {
            
            __block UIImageView* full;
            
            [UIView animateWithDuration:.3f animations:^{
                full = [[UIImageView alloc] initWithFrame:dest.view.frame];
                NSIndexPath* firstIndex = [source.selectedIndexes objectAtIndex:0];
                NSDictionary* firstMedia = [source.medias objectAtIndex:firstIndex.row];
                ALAsset* asset = [firstMedia objectForKey:@"asset"];
                full.image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
//                [source.view addSubview:full];
                full.contentMode = UIViewContentModeScaleAspectFill;
//                
//                full.transform = CGAffineTransformMakeScale(0, 0);
//                
//                [UIView animateWithDuration:.3f animations:^{
//                    full.transform = CGAffineTransformIdentity;
//                }];
            }];
            if (idx == source.selectedIndexes.count - 1) {

                [source.navigationController pushViewController:dest animated:NO];
                
                // reset previous VC layout
                
                [loader removeFromSuperview];
                [full removeFromSuperview];
                
                [source.mediaCollectionView reloadData];
                
                for (UICollectionViewCell* cell in hiddenCells) {
                    cell.alpha = 1;
                }
            }
        }];
    }];
    
    [UIView animateWithDuration:.3f animations:^{
        source.continueButtonYConstraint.constant -= 100;
        [source.view layoutIfNeeded];
    }];
    
}

@end
