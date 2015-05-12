//
//  ShowOneGroupViewController.m
//  Wireframe
//
//  Created by Glenn Sonna on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "ShowOneGroupViewController.h"
#import "UserSession.h"
#import "ReadModeContainerViewController.h"
#import "AdminRoomViewController.h"
#import "SHPathLibrary.h"
#import "FilterViewController.h"

@interface ShowOneGroupViewController ()

@end

@implementation ShowOneGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [SHPathLibrary addBackgroundPathForstoriesToView:self.view];
    
    //self.mStories = @[@"coup de chance", @"Conférence F.A.M.E", @"Plexus Gobelins"];
  
    [self.roomNameButton setTitle:self.room.name forState:UIControlStateNormal];
    
    NSLog(@"Room is %@", self.room.id);
    
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    
    StoryManager* manager = [[StoryManager alloc] initWithDelegate:self];
    [manager fetchStoriesForRoomId:[self.room.id integerValue] filteredByTag:nil orUser:nil];
    
    
    [SHPathLibrary addRightCurveBezierPathToView:self.view
                                       withColor:[UIColor colorWithRed:35/255.0  green:12/255.0 blue:11/255.0 alpha:1]
                                        inverted:YES];
    
    if ([self.room isAdmin:CurrentUser]) {
        [self.roomNameButton addTarget:self action:@selector(didTapAdminButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UISwipeGestureRecognizer* swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeCell:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.mTableView addGestureRecognizer:swipe];
}

#pragma mark - Actions

- (IBAction)didTapAdminButton:(id)sender {
    AdminRoomViewController* vc = (AdminRoomViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"AdminRoom"];
    vc.room = self.room;
    [self presentViewController:vc animated:YES completion:nil];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)displayFiltersController:(id)sender {
    FilterViewController* vc = (FilterViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"Filter"];
    vc.room = self.room;
    
    [vc willMoveToParentViewController:self];
    [self addChildViewController:vc];
    vc.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:vc.view];
    
    [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        vc.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:nil];
    [vc didMoveToParentViewController:self];
}

- (void)didSwipeCell:(UISwipeGestureRecognizer*)swipe {
    CGPoint location = [swipe locationInView:self.mTableView];
    NSIndexPath* indexPath = [self.mTableView indexPathForRowAtPoint:location];
    
    if (indexPath) {
        UITableViewCell* cell = [self.mTableView cellForRowAtIndexPath:indexPath];
        UILabel* label = (UILabel*)[cell.contentView viewWithTag:10];
        UIButton* delete = (UIButton*)[cell.contentView viewWithTag:30];
        
        if (delete.alpha == 0) {
            [UIView animateWithDuration:.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                label.transform = CGAffineTransformMakeTranslation(100, 0);
                label.alpha = .3f;
                delete.alpha = 1;
            } completion:nil];
        } else {
            [UIView animateWithDuration:.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                label.transform = CGAffineTransformIdentity;
                label.alpha = 1;
                delete.alpha = 0;
            } completion:nil];
        }
    }
}

#pragma mark - Filters

- (void)applyFilters {
    StoryManager* manager = [[StoryManager alloc] initWithDelegate:self];
    [manager fetchStoriesForRoomId:[self.room.id integerValue] filteredByTag:self.filterTag orUser:self.filterUser];
}

#pragma mark - TableView


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cellStory";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    Story* story = [self.mStories objectAtIndex:indexPath.row];
    
   
    //NSLog(@"%@", [story toJSONString]);
    
    UILabel *name = (UILabel*)[cell.contentView viewWithTag:10];
    name.text = story.title;
    
    UILabel *desc = (UILabel*)[cell.contentView viewWithTag:20];
    desc.text = [Story NSDateToShowString: story.createdAt];
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mStories.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*self.mShowOneGroupViewController =
    [[ShowOneGroupViewController alloc] initWithNibName:@"ShowOneGroupViewController"
                                                 bundle:nil];
    [self presentViewController:self.mShowOneGroupViewController animated:YES completion:nil];*/
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showStory"]) {
        
        //TODO put in model
        NSIndexPath *indexPath = [self.mTableView indexPathForSelectedRow];
        Story* story = [self.mStories objectAtIndex:indexPath.row];
        NSUInteger selectedStory = [story.id integerValue];
        
        ReadModeContainerViewController* reveal = segue.destinationViewController;
        reveal.storyId = selectedStory;
    }
}

- (void)storyManager:(StoryManager *)manager successfullyFetchedStories:(NSArray *)stories{
    
    self.mStories = stories;
    [self.mTableView reloadData];
}

-(void)storyManager:(StoryManager *)manager failedToFetchStories:(NSError *)error{
    //error
}

-(IBAction)prepareForGoBackToOneGroup:(UIStoryboardSegue *)segue {
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
