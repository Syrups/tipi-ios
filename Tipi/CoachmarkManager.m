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

+ (void)launchCoachmarkAnimationForOrganizerController:(OrganizeStoryViewController *)controller {
    
    UIView* overlay = [[UIView alloc] initWithFrame:controller.view.frame];
    overlay.backgroundColor = RgbColorAlpha(0, 0, 0, 1);
    overlay.alpha = 0;
    [controller.view addSubview:overlay];
    
    [controller.view bringSubviewToFront:controller.coachmarkSprite];
    [controller.view bringSubviewToFront:controller.helpLabel];
    
    UICollectionViewCell* cell = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    controller.collectionView.scrollEnabled = NO;
    controller.coachmarkSprite.hidden = NO;
    
    [PKAIDecoder builAnimatedImageIn:controller.coachmarkSprite fromFile:@"help-tap" withAnimationDuration:2.8f];
    
    controller.helpLabel.text = @"Touchez une image pour passer en mode enregistrement";
    
    // coachmark animation to tap the image
    [UIView animateKeyframesWithDuration:4 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.2f animations:^{
            overlay.alpha = .8f;
            controller.helpLabel.alpha = 1;
            cell.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
        }];
        [UIView addKeyframeWithRelativeStartTime:.8f relativeDuration:.2f animations:^{
            cell.transform = CGAffineTransformIdentity;
        }];
    } completion:^(BOOL finished) {
        [PKAIDecoder builAnimatedImageIn:controller.coachmarkSprite fromFile:@"help-drag" withAnimationDuration:3];
        
        [UIView animateKeyframesWithDuration:2 delay:1 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            
            // coachmark animation to move the image
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.2f animations:^{
                
                controller.helpLabel.text = @"Glissez les images pour réorganiser votre histoire";
                cell.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(.1f), CGAffineTransformMakeTranslation(50, 0));
            }];
            [UIView addKeyframeWithRelativeStartTime:.3f relativeDuration:.3f animations:^{
                cell.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(-.1f), CGAffineTransformMakeTranslation(-50, 0));
            }];
            [UIView addKeyframeWithRelativeStartTime:.7f relativeDuration:.2f animations:^{
                cell.transform = CGAffineTransformMakeRotation(0);
            }];
            
            [UIView addKeyframeWithRelativeStartTime:.9f relativeDuration:.1f animations:^{
                overlay.alpha = 0;
                controller.helpLabel.alpha = 0;
                controller.collectionView.scrollEnabled = YES;
            }];
        } completion:^(BOOL finished) {
            controller.coachmarkSprite.hidden = YES;
            controller.coachmarkSprite.animationImages = [NSArray array];
        }];
    }];
}

+ (void)launchCoachmarkAnimationForRecordController:(RecordViewController *)controller {
    UIView* overlay = [[UIView alloc] initWithFrame:controller.view.frame];
    overlay.backgroundColor = RgbColorAlpha(0, 0, 0, 1);
    overlay.alpha = 0;
    [controller.view addSubview:overlay];
    
    [controller.view bringSubviewToFront:controller.coachmarkSprite];
    [controller.view bringSubviewToFront:controller.helpLabel];
    
    controller.helpLabel.text = @"Maintenez appuyé sur l'écran pour enregistrer votre voix";
 
    [PKAIDecoder builAnimatedImageIn:controller.coachmarkSprite fromFile:@"help-record" withAnimationDuration:3.2f];
    
    // coachmark animation to tap the image
    [UIView animateKeyframesWithDuration:4 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.2f animations:^{
            overlay.alpha = .8f;
            controller.helpLabel.alpha = 1;
        }];
        [UIView addKeyframeWithRelativeStartTime:.8f relativeDuration:.2f animations:^{
            overlay.alpha = 0;
            controller.helpLabel.alpha = 0;
        }];
    } completion:^(BOOL finished) {
        controller.coachmarkSprite.hidden = YES;
        controller.coachmarkSprite.animationImages = [NSArray array];
    }];
}


@end
