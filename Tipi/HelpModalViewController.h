//
//  HelpModalViewController.h
//  Wireframe
//
//  Created by Leo on 24/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpModalViewController : UIViewController

+ (HelpModalViewController*)instantiateModalViewOnParentController:(UIViewController*)controller withDelegate:(id)delegate andMessage:(NSString*)message;

@property (weak, nonatomic) id delegate;
@property (strong, nonatomic) IBOutlet UILabel* helpLabel;
@property (weak, nonatomic) UIViewController* currentParentController;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* centerYContraint;

@end

@protocol HelpModalViewControllerDelegate <NSObject>

- (void)modalViewControllerDidAcknowledgedMessage:(HelpModalViewController*)controller;
- (void)modalViewControllerDidDismiss:(HelpModalViewController *)controller;

@end
