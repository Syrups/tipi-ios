//
//  RecordViewController.m
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "RecordViewController.h"
#import "RecordPageViewController.h"

@interface RecordViewController ()

@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lastPage = NO;
    
    self.recordButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.recordButton.layer.cornerRadius = 40;
    self.recordButton.layer.borderWidth = 10;
    
    self.pages = [NSMutableArray arrayWithObjects:@"1", @"2", @"3", nil];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordPageViewController"];
    self.pageViewController.dataSource = self;
    
    RecordPageViewController* first = [self viewControllerAtIndex:0];
    [self.pageViewController setViewControllers:@[first] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.view sendSubviewToBack:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    for (UIView* v in self.pageViewController.view.subviews) {
        if ([v isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView*)v).delegate = self;
        }
    }
    
    UILongPressGestureRecognizer* press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(record:)];
    
    [self.recordButton addGestureRecognizer:press];
}

- (void)record:(UILongPressGestureRecognizer*)recognizer {
    RecordPageViewController* current = [self currentPage];
    
    if (current.recorded) {
        current.recorded = NO;
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            [UIView animateWithDuration:0.6f delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAutoreverse animations:^{
                self.eraseWarning.alpha = 1;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.4f animations:^{
                    self.eraseWarning.alpha = 0;
                }];
            }];
            self.replay.hidden = YES;
        } else if (recognizer.state == UIGestureRecognizerStateEnded) {
            [UIView animateWithDuration:0.3f animations:^{
                self.eraseWarning.alpha = 0;
            }];
        }
    } else {
        if (recognizer.state == UIGestureRecognizerStateEnded) {
            self.replay.hidden = NO;
            current.recorded = YES;
        }
        
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIPageViewController

- (RecordPageViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pages count] == 0) || (index >= [self.pages count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    RecordPageViewController *page = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordPage"];
    page.pageIndex = index;
    
    return page;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((RecordPageViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    if (index < self.pages.count-1) {
        self.lastPage = NO;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((RecordPageViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pages count]) {
        
        self.lastPage = YES;
        
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pages count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

#pragma mark - UIScrollView

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.lastPage && scrollView.contentOffset.x > self.view.frame.size.width+10) {
        [self performSegueWithIdentifier:@"ToNameStory" sender:nil];
    }
}

#pragma mark - Helpers

- (RecordPageViewController*)currentPage {
    return self.pageViewController.viewControllers[0];
}

@end
