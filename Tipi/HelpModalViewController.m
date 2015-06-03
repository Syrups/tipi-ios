//
//  HelpModalViewController.m
//  Wireframe
//
//  Created by Leo on 24/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "HelpModalViewController.h"

@implementation HelpModalViewController

+ (HelpModalViewController *)instantiateModalViewOnParentController:(UIViewController *)controller withDelegate:(id)delegate andMessage:(NSString *)message {
    HelpModalViewController* modal = [[UIStoryboard storyboardWithName:kStoryboardStoryBuilder bundle:nil] instantiateViewControllerWithIdentifier:@"HelpModal"];
    modal.helpLabel.text = message;
    modal.view.frame = controller.view.frame;
    modal.delegate = delegate;
    [controller addChildViewController:modal];
    [controller.view addSubview:modal.view];
    [modal didMoveToParentViewController:controller];
    
    return modal;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.centerYContraint.constant = self.view.frame.size.height;
    [self.view layoutIfNeeded];
    [UIView animateKeyframesWithDuration:.6f delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.6f animations:^{
            self.centerYContraint.constant = -30;
            [self.view layoutIfNeeded];
        }];
        
        [UIView addKeyframeWithRelativeStartTime:.6f relativeDuration:.4f animations:^{
            self.centerYContraint.constant = 0;
            [self.view layoutIfNeeded];
        }];
    } completion:nil];

}

- (IBAction)acknowledge:(id)sender {
    [UIView animateKeyframesWithDuration:.5f delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.5f animations:^{
            self.centerYContraint.constant = 30;
            [self.view layoutIfNeeded];
        }];
        [UIView addKeyframeWithRelativeStartTime:.5f relativeDuration:.5f animations:^{
            self.centerYContraint.constant = -self.view.frame.size.height;
            [self.view layoutIfNeeded];
        }];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f animations:^{
            self.view.alpha = 0;
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }];
    }];
    
    if ([self.delegate respondsToSelector:@selector(modalViewControllerDidAcknowledgedMessage:)]) {
        [self.delegate modalViewControllerDidAcknowledgedMessage:self];
    }
}

- (IBAction)close:(id)sender {
    [UIView animateKeyframesWithDuration:.5f delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.5f animations:^{
            self.centerYContraint.constant = 30;
            [self.view layoutIfNeeded];
        }];
        [UIView addKeyframeWithRelativeStartTime:.5f relativeDuration:.5f animations:^{
            self.centerYContraint.constant = -self.view.frame.size.height;
            [self.view layoutIfNeeded];
        }];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f animations:^{
            self.view.alpha = 0;
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }];
    }];
    
    if ([self.delegate respondsToSelector:@selector(modalViewControllerDidDismiss:)]) {
        [self.delegate modalViewControllerDidDismiss:self];
    }
}

@end
