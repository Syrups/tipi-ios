//
//  TPSwipableViewController.h
//  Tipi
//
//  Created by Glenn Sonna on 03/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanGestureInteractiveTransition.h"

@protocol TPSwipableViewControllerDelegate;

@interface TPSwipableViewController : UIViewController

@property (nonatomic, strong) UIView *privateContainerView;

@property (nonatomic, weak) id<TPSwipableViewControllerDelegate>delegate;

@property (nonatomic, copy) NSArray *viewControllers;

@property (nonatomic, assign) UIViewController *selectedViewController;

@property PanGestureInteractiveTransition *defaultInteractionController;

- (instancetype)initWithViewControllers:(NSArray *)viewControllers;
- (void)setSelectedViewControllerViewControllerAtIndex:(NSUInteger)index;
- (void)moveViewController:(UIViewController*)viewController fromIndex:(NSUInteger)oldIndex atIndex:(NSUInteger)newIndex;

@end

@protocol TPSwipableViewControllerDelegate <NSObject>


@required
/** Informs the delegate that the user selected view controller by tapping the corresponding icon.
 @note The method is called regardless of whether the selected view controller changed or not and only as a result of the user tapped a button. The method is not called when the view controller is changed programmatically. This is the same pattern as UITabBarController uses.
 */

- (void)swipableViewController:(TPSwipableViewController *)containerViewController didFinishedTransitionToViewController:(UIViewController *)viewController;

@optional
/** Informs the delegate that the user selected view controller by tapping the corresponding icon.
 @note The method is called regardless of whether the selected view controller changed or not and only as a result of the user tapped a button. The method is not called when the view controller is changed programmatically. This is the same pattern as UITabBarController uses.
 */
- (void)swipableViewController:(TPSwipableViewController *)containerViewController didSelectViewController:(UIViewController *)viewController;

@optional
/// Called on the delegate to obtain a UIViewControllerAnimatedTransitioning object which can be used to animate a non-interactive transition.
- (id <UIViewControllerAnimatedTransitioning>)swipableViewController:(TPSwipableViewController *)containerViewController animationControllerForTransitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;

@optional
/// Called on the delegate to obtain a UIViewControllerInteractiveTransitioning object which can be used to interact during a transition
- (id <UIViewControllerInteractiveTransitioning>)swipableViewController:(TPSwipableViewController *)swipableViewController interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>)animationController;
@end
