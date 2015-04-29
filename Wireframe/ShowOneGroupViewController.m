//
//  ShowOneGroupViewController.m
//  Wireframe
//
//  Created by Glenn Sonna on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "RoomRevealWrapperViewController.h"
#import "ShowOneGroupViewController.h"
#import "UserSession.h"
#import "ReadModeContainerViewController.h"
#import "SHPathLibrary.h"


@interface ShowOneGroupViewController ()

@end

@implementation ShowOneGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.mStories = @[@"coup de chance", @"Conférence F.A.M.E", @"Plexus Gobelins"];
    RoomRevealWrapperViewController *parent = (RoomRevealWrapperViewController*)[self revealViewController];
    self.roomId = parent.roomId;
    
    
    NSLog(@"Room is %lu", (unsigned long)self.roomId);
    
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    
    StoryManager* manager = [[StoryManager alloc] initWithDelegate:self];
    [manager fetchStoriesForRoomId:self.roomId];
    
    [self customSetup];
    
    [SHPathLibrary addRightCurveBezierPathToView:self.view
                                       withColor:[UIColor colorWithRed:35/255.0  green:12/255.0 blue:11/255.0 alpha:1]
                                        inverted:YES];
}

- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.revealTag addTarget:self.revealViewController
                           action:@selector(revealToggle:)
           forControlEvents:UIControlEventTouchUpInside];
        
        [self.revealUsers addTarget:self.revealViewController
                           action:@selector(rightRevealToggle:)
                 forControlEvents:UIControlEventTouchUpInside];
        
        self.revealViewController.rightViewRevealWidth = 120;
        self.revealViewController.rightViewRevealOverdraw = 0;
        
        self.revealViewController.rearViewRevealWidth = 120;
        self.revealViewController.rearViewRevealOverdraw = 0;
        
        //self.revealViewController.bounceBackOnOverdraw = NO;
        //self.revealViewController.bounceBackOnLeftOverdraw = NO;
        
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
}

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

-(IBAction)prepareForGoBackToOneGroup:(UIStoryboardSegue *)segue {
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
