//
//  TPSwipableViewController.h
//  Tipi
//
//  Created by Glenn Sonna on 03/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

@import UIKit;
@import Foundation;
#import "PanGestureInteractiveTransition.h"

@protocol TPSwipableViewControllerDelegate;

@interface TPSwipableViewController : UIViewController

@property (nonatomic, weak) id<TPSwipableViewControllerDelegate>delegate;

@property (nonatomic, copy, readonly) NSArray *viewControllers;

@property (nonatomic, assign) UIViewController *selectedViewController;

@property PanGestureInteractiveTransition *defaultInteractionController;

- (instancetype)initWithViewControllers:(NSArray *)viewControllers;
- (void)setSelectedViewControllerViewControllerAtIndex:(NSUInteger)index;

@end

@protocol TPSwipableViewControllerDelegate <NSObject>
@optional
/** Informs the delegate that the user selected view controller by tapping the corresponding icon.
 @note The method is called regardless of whether the selected view controller changed or not and only as a result of the user tapped a button. The method is not called when the view controller is changed programmatically. This is the same pattern as UITabBarController uses.
 */
- (void)swipableViewController:(TPSwipableViewController *)containerViewController didSelectViewController:(UIViewController *)viewController;

@required
/** Informs the delegate that the user selected view controller by tapping the corresponding icon.
 @note The method is called regardless of whether the selected view controller changed or not and only as a result of the user tapped a button. The method is not called when the view controller is changed programmatically. This is the same pattern as UITabBarController uses.
 */
- (void)swipableViewController:(TPSwipableViewController *)containerViewController didFinishedTransitionToViewController:(UIViewController *)viewController;

/// Called on the delegate to obtain a UIViewControllerAnimatedTransitioning object which can be used to animate a non-interactive transition.
- (id <UIViewControllerAnimatedTransitioning>)swipableViewController:(TPSwipableViewController *)containerViewController animationControllerForTransitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;


/// Called on the delegate to obtain a UIViewControllerInteractiveTransitioning object which can be used to interact during a transition
- (id <UIViewControllerInteractiveTransitioning>)swipableViewController:(TPSwipableViewController *)swipableViewController interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>)animationController;
@end
