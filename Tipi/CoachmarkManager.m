//
//  CoachmarkManager.m
//  Tipi
//
//  Created by Leo on 01/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "CoachmarkManager.h"
#import "PKAIDecoder.h"

@implementation CoachmarkManager

+ (void)launchCoachmarkAnimationForOrganizerController:(OrganizeStoryViewController *)controller withCompletion:(void (^)())completion {
//    
//    UIView* overlay = [[UIView alloc] initWithFrame:controller.view.frame];
//    overlay.backgroundColor = RgbColorAlpha(0, 0, 0, 1);
//    overlay.alpha = 0;
//    [controller.view addSubview:overlay];
//    
//    [controller.view bringSubviewToFront:controller.coachmarkSprite];
//    [controller.view bringSubviewToFront:controller.helpLabel];
//    
//    UICollectionViewCell* cell = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
//    controller.collectionView.scrollEnabled = NO;
//    controller.coachmarkSprite.hidden = NO;
//    
//    [PKAIDecoder builAnimatedImageIn:controller.coachmarkSprite fromFile:@"help-tap" withAnimationDuration:2.8f];
//    
//    controller.helpLabel.text = @"Touchez une image pour passer en mode enregistrement";
//    
//    [UIView animateWithDuration:.2f animations:^{
//        overlay.alpha = .8f;
//        controller.helpLabel.alpha = 1;
//    }];
//    
//    // coachmark animation to tap the image
//    [UIView animateKeyframesWithDuration:4 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear|UIViewKeyframeAnimationOptionRepeat animations:^{
//        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.2f animations:^{
//            cell.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
//        }];
//        [UIView addKeyframeWithRelativeStartTime:.8f relativeDuration:.2f animations:^{
//            cell.transform = CGAffineTransformIdentity;
//        }];
//    } completion:^(BOOL finished) {
////        [PKAIDecoder builAnimatedImageIn:controller.coachmarkSprite fromFile:@"help-drag" withAnimationDuration:3];
////        
////        [UIView animateKeyframesWithDuration:3 delay:1 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
////            
////            // coachmark animation to move the image
////            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.2f animations:^{
////                controller.helpLabel.alpha = 1;
////                controller.coachmarkSprite.alpha = 1;
////                controller.helpLabel.text = @"Glissez les images pour réorganiser votre histoire";
////                cell.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(.1f), CGAffineTransformMakeTranslation(50, 0));
////            }];
////            [UIView addKeyframeWithRelativeStartTime:.3f relativeDuration:.3f animations:^{
////                cell.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(-.1f), CGAffineTransformMakeTranslation(-50, 0));
////            }];
////            [UIView addKeyframeWithRelativeStartTime:.7f relativeDuration:.2f animations:^{
////                cell.transform = CGAffineTransformMakeRotation(0);
////            }];
////            
////            [UIView addKeyframeWithRelativeStartTime:.9f relativeDuration:.1f animations:^{
////                
////            }];
////        } completion:^(BOOL finished) {
////
////            if (completion) completion();
////        }];
//    }];
}

+ (void)launchCoachmarkAnimationForRecordController:(RecordViewController *)controller withCompletion:(void (^)())completion {
    
    UIView* overlay = [[UIView alloc] initWithFrame:controller.view.frame];
    overlay.backgroundColor = RgbColorAlpha(0, 0, 0, 1);
    overlay.alpha = 0;

    [controller.view addSubview:overlay];
    [controller.view bringSubviewToFront:controller.coachmarkSprite];
    [controller.view bringSubviewToFront:controller.helpLabel];
    
    controller.helpLabel.text = @"Appuyez pour enregistrer";
 
    [PKAIDecoder builAnimatedImageIn:controller.coachmarkSprite fromFile:@"help-record" withAnimationDuration:3.2f];
    
    controller.coachmarkSprite.alpha = 0;
    [UIView animateWithDuration:.3f animations:^{
        overlay.alpha = .6f;
        controller.coachmarkSprite.alpha = 1;
        controller.helpLabel.alpha = 1;
    }];
    
}

+ (void)dismissCoachmarkAnimationForRecordController:(RecordViewController *)controller {
    [UIView animateWithDuration:.1f animations:^{
        controller.coachmarkSprite.alpha = 0;
        controller.helpLabel.alpha = 0;
    }];
}


@end
