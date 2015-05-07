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
    [manager fetchStoriesForRoomId:[self.room.id integerValue]];
    
    
    [SHPathLibrary addRightCurveBezierPathToView:self.view
                                       withColor:[UIColor colorWithRed:35/255.0  green:12/255.0 blue:11/255.0 alpha:1]
                                        inverted:YES];
    
    if ([self.room isAdmin:CurrentUser]) {
        [self.roomNameButton addTarget:self action:@selector(didTapAdminButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - Actions

- (IBAction)didTapAdminButton:(id)sender {
    AdminRoomViewController* vc = (AdminRoomViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"AdminRoom"];
    vc.room = self.room;
    [self presentViewController:vc animated:YES completion:nil];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TableView



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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
