//
//  TPSwipableViewController.m
//  Tipi
//
//  Created by Glenn Sonna on 03/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "TPSwipableViewController.h"
#import "TPCardAnimatedTransition.h"
#import "CardViewController.h"



/** A private UIViewControllerContextTransitioning class to be provided transitioning delegates.
 @discussion Because we are a custom UIVievController class, with our own containment implementation, we have to provide an object conforming to the UIViewControllerContextTransitioning protocol. The system view controllers use one provided by the framework, which we cannot configure, let alone create. This class will be used even if the developer provides their own transitioning objects.
 @note The only methods that will be called on objects of this class are the ones defined in the UIViewControllerContextTransitioning protocol. The rest is our own private implementation.
 */
@interface SwipeTransitionContext : NSObject <UIViewControllerContextTransitioning>
- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController goingRight:(BOOL)goingRight; /// Designated initializer.
@property (nonatomic, copy) void (^completionBlock)(BOOL didComplete); /// A block of code we can set to execute after having received the completeTransition: message.
@property (nonatomic, assign, getter=isAnimated) BOOL animated; /// Private setter for the animated property.
@property (nonatomic, assign, getter=isInteractive) BOOL interactive; /// Private setter for the interactive property.
@end


@interface TPSwipableViewController ()
//@property (nonatomic, strong) UIView *privateButtonsView;

@end

@implementation TPSwipableViewController

- (instancetype)initWithViewControllers:(NSArray *)viewControllers {
    NSParameterAssert ([viewControllers count] > 0);
    if ((self = [super init])) {
        self.viewControllers = [viewControllers copy];
    }
    return self;
}

- (void)loadView {
    
    // Add  container and buttons views.
    
    UIView *rootView = [[UIView alloc] init];
    rootView.backgroundColor = [UIColor blackColor];
    rootView.opaque = YES;
    
    self.privateContainerView = [[UIView alloc] init];
    self.privateContainerView.backgroundColor = [UIColor blackColor];
    self.privateContainerView.opaque = YES;
    
    //self.privateButtonsView = [[UIView alloc] init];
    //self.privateButtonsView.backgroundColor = [UIColor clearColor];
    //self.privateButtonsView.tintColor = [UIColor colorWithWhite:1 alpha:0.75f];
    
    [self.privateContainerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    //[self.privateButtonsView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [rootView addSubview:self.privateContainerView];
    //[rootView addSubview:self.privateButtonsView];
    
    // Container view fills out entire root view.
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateContainerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateContainerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateContainerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateContainerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    // Place buttons view in the top half, horizontally centered.
    /*[rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateButtonsView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:[self.viewControllers count] * kButtonSlotWidth]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateButtonsView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.privateContainerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateButtonsView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kButtonSlotHeight]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateButtonsView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.privateContainerView attribute:NSLayoutAttributeCenterY multiplier:0.4f constant:0]];*/
    
    
    __weak typeof(self) wself = self;
    self.defaultInteractionController = [[PanGestureInteractiveTransition alloc]
                                         initWithGestureRecognizerInView:self.privateContainerView
                                         recognizedBlock:^(UIPanGestureRecognizer *recognizer) {
                                             
                                             BOOL leftToRight = [recognizer velocityInView:recognizer.view].x > 0;
                                             
                                             NSUInteger currentVCIndex = [self.viewControllers indexOfObject:self.selectedViewController];
                                             if (!leftToRight && currentVCIndex != self.viewControllers.count-1) {
                                                 NSUInteger newIndex = currentVCIndex+1;
                                                 [wself setSelectedViewController:self.viewControllers[newIndex]];
                                             } else if (leftToRight && currentVCIndex > 0) {
                                                 NSUInteger newIndex = currentVCIndex-1;
                                                 [wself setSelectedViewController:self.viewControllers[newIndex]];
                                             }
                                         }];
    
    self.view = rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedViewController = (self.selectedViewController ?: self.viewControllers[0]);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.selectedViewController;
}

-(void)setSelectedViewController:(UIViewController *)selectedViewController {
    NSParameterAssert (selectedViewController);
    [self _transitionToChildViewController:selectedViewController];
    _selectedViewController = selectedViewController;
    //[self _updateButtonSelection];
}

- (void)setSelectedViewControllerViewControllerAtIndex:(NSUInteger)index{
    UIViewController *selectedViewController = self.viewControllers[index];
    self.selectedViewController = selectedViewController;
}

- (void)moveViewController:(UIViewController *)viewController fromIndex:(NSUInteger)oldIndex atIndex:(NSUInteger)newIndex {
    NSLog(@"%lu", (unsigned long)self.viewControllers.count);
    NSMutableArray* viewControllers = [self.viewControllers mutableCopy];
    
    [viewControllers removeObjectAtIndex:oldIndex];
    [viewControllers insertObject:viewController atIndex:newIndex];
    
    for (int i = 0 ; i < viewControllers.count ; i++) {
        CardViewController* vc = (CardViewController*)[viewControllers objectAtIndex:i];
        [vc setPageIndex:i];
        
    }
    
    self.viewControllers = [viewControllers copy];
}

/*
- (void)_updateButtonSelection {
    [self.privateButtonsView.subviews enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        button.selected = (self.viewControllers[idx] == self.selectedViewController);
    }];
}*/


- (void)_transitionToChildViewController:(UIViewController *)toViewController {
    
    UIViewController *fromViewController = self.selectedViewController;
    if (toViewController == fromViewController || ![self isViewLoaded]) {
        return;
    }
    
    UIView *toView = toViewController.view;
    [toView setTranslatesAutoresizingMaskIntoConstraints:YES];
    toView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    toView.frame = self.privateContainerView.bounds;
    
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    
    // If this is the initial presentation, add the new child with no animation.
    if (!fromViewController) {
        [self.privateContainerView addSubview:toViewController.view];
        [toViewController didMoveToParentViewController:self];
        [self _finishTransitionToChildViewController:toViewController];
        return;
    }
    
    // Animate the transition by calling the animator with our private transition context. If we don't have a delegate, or if it doesn't return an animated transitioning object, we will use our own, private animator.
    
    id<UIViewControllerAnimatedTransitioning>animator = nil;
    if ([self.delegate respondsToSelector:@selector (swipableViewController:animationControllerForTransitionFromViewController:toViewController:)]) {
        animator = [self.delegate swipableViewController:self animationControllerForTransitionFromViewController:fromViewController toViewController:toViewController];
    }
    BOOL animatorIsDefault = (animator == nil);
    animator = (animator ?: [[TPCardAnimatedTransition alloc] init]);
    
    // Because of the nature of our view controller, with horizontally arranged buttons, we instantiate our private transition context with information about whether this is a left-to-right or right-to-left transition. The animator can use this information if it wants.
    NSUInteger fromIndex = [self.viewControllers indexOfObject:fromViewController];
    NSUInteger toIndex = [self.viewControllers indexOfObject:toViewController];
    SwipeTransitionContext *transitionContext = [[SwipeTransitionContext alloc] initWithFromViewController:fromViewController toViewController:toViewController goingRight:toIndex > fromIndex];
    
    transitionContext.animated = YES;
    
    // At the start of the transition, we need to find out if it should be interactive or not. We do this by trying to fetch an interaction controller.
    id<UIViewControllerInteractiveTransitioning> interactionController = [self _interactionControllerForAnimator:animator animatorIsDefault:animatorIsDefault];
    
    transitionContext.interactive = (interactionController != nil);
    transitionContext.completionBlock = ^(BOOL didComplete) {
        
        if (didComplete) {
            [fromViewController.view removeFromSuperview];
            [fromViewController removeFromParentViewController];
            [toViewController didMoveToParentViewController:self];
            [self _finishTransitionToChildViewController:toViewController];
            
        } else {
            [toViewController.view removeFromSuperview];
        }
        
        if ([animator respondsToSelector:@selector (animationEnded:)]) {
            [animator animationEnded:didComplete];
        }
        //self.privateButtonsView.userInteractionEnabled = YES;
    };
    
    //self.privateButtonsView.userInteractionEnabled = NO;
    // Prevent user tapping buttons mid-transition, messing up state
    
    if ([transitionContext isInteractive]) {
        [interactionController startInteractiveTransition:transitionContext];
    } else {
        [animator animateTransition:transitionContext];
        [self _finishTransitionToChildViewController:toViewController];
    }
}

- (void)_finishTransitionToChildViewController:(UIViewController *)toViewController {
    _selectedViewController = toViewController;
    
    if ([self.delegate respondsToSelector:@selector (swipableViewController:didFinishedTransitionToViewController:)]) {
        [self.delegate swipableViewController:self didFinishedTransitionToViewController:toViewController];
    }
    //[self _updateButtonSelection];
}

- (id<UIViewControllerInteractiveTransitioning>)_interactionControllerForAnimator:(id<UIViewControllerAnimatedTransitioning>)animationController animatorIsDefault:(BOOL)animatorIsDefault {
    
    if (self.defaultInteractionController.recognizer.state == UIGestureRecognizerStateBegan) {
        self.defaultInteractionController.animator = animationController;
        return self.defaultInteractionController;
    } else if (!animatorIsDefault && [self.delegate respondsToSelector:@selector(swipableViewController:interactionControllerForAnimationController:)]) {
        return [self.delegate swipableViewController:self interactionControllerForAnimationController:animationController];
    } else {
        return nil;
    }
}

@end



#pragma mark - Private Transitioning Classes

@interface SwipeTransitionContext ()
@property (nonatomic, strong) NSDictionary *privateViewControllers;
@property (nonatomic, assign) CGRect privateDisappearingFromRect;
@property (nonatomic, assign) CGRect privateAppearingFromRect;
@property (nonatomic, assign) CGRect privateDisappearingToRect;
@property (nonatomic, assign) CGRect privateAppearingToRect;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, assign) UIModalPresentationStyle presentationStyle;
@end

@implementation SwipeTransitionContext

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController goingRight:(BOOL)goingRight {
    NSAssert ([fromViewController isViewLoaded] && fromViewController.view.superview, @"The fromViewController view must reside in the container view upon initializing the transition context.");
    
    if ((self = [super init])) {
        self.presentationStyle = UIModalPresentationCustom;
        self.containerView = fromViewController.view.superview;
        self.privateViewControllers = @{
                                        UITransitionContextFromViewControllerKey:fromViewController,
                                        UITransitionContextToViewControllerKey:toViewController,
                                        };
        
        // Set the view frame properties which make sense in our specialized ContainerViewController context. Views appear from and disappear to the sides, corresponding to where the icon buttons are positioned. So tapping a button to the right of the currently selected, makes the view disappear to the left and the new view appear from the right. The animator object can choose to use this to determine whether the transition should be going left to right, or right to left, for example.
        CGFloat travelDistance = (goingRight ? -self.containerView.bounds.size.width : self.containerView.bounds.size.width);
        self.privateDisappearingFromRect = self.privateAppearingToRect = self.containerView.bounds;
        self.privateDisappearingToRect = CGRectOffset (self.containerView.bounds, travelDistance, 0);
        self.privateAppearingFromRect = CGRectOffset (self.containerView.bounds, -travelDistance, 0);
    }
    
    return self;
}

- (CGRect)initialFrameForViewController:(UIViewController *)viewController {
    if (viewController == [self viewControllerForKey:UITransitionContextFromViewControllerKey]) {
        return self.privateDisappearingFromRect;
    } else {
        return self.privateAppearingFromRect;
    }
}

- (CGRect)finalFrameForViewController:(UIViewController *)viewController {
    if (viewController == [self viewControllerForKey:UITransitionContextFromViewControllerKey]) {
        return self.privateDisappearingToRect;
    } else {
        return self.privateAppearingToRect;
    }
}

- (UIViewController *)viewControllerForKey:(NSString *)key {
    return self.privateViewControllers[key];
}

- (void)completeTransition:(BOOL)didComplete {
    if (self.completionBlock) {
        self.completionBlock (didComplete);
    }
}

- (BOOL)transitionWasCancelled { return NO; } // Our non-interactive transition can't be cancelled (it could be interrupted, though)

// Supress warnings by implementing empty interaction methods for the remainder of the protocol:

- (void)updateInteractiveTransition:(CGFloat)percentComplete {}
- (void)finishInteractiveTransition {}
- (void)cancelInteractiveTransition {}

@end