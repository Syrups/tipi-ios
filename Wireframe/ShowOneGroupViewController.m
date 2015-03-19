//
//  ShowOneGroupViewController.m
//  Wireframe
//
//  Created by Glenn Sonna on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "ShowOneGroupViewController.h"
#import "SWRevealViewController.h"


@interface ShowOneGroupViewController ()

@end

@implementation ShowOneGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mStories = @[@"coup de chance", @"Conférence F.A.M.E", @"Plexus Gobelins"];
    
    NSLog(@"%lu", (unsigned long)self.roomId);
    
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    [self customSetup];
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
    
    for (UIView* v in cell.contentView.subviews) {
        //if([v class])
        v.layer.borderWidth = 1;
        v.layer.borderColor = [UIColor blackColor].CGColor;
    }
    
    
    UILabel *name = (UILabel*)[cell.contentView viewWithTag:10];
    name.text = [self.mStories objectAtIndex:indexPath.row];
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mStories.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*self.mShowOneGroupViewController =
    [[ShowOneGroupViewController alloc] initWithNibName:@"ShowOneGroupViewController"
                                                 bundle:nil];
    [self presentViewController:self.mShowOneGroupViewController animated:YES completion:nil];*/
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
