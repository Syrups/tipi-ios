//
//  ShowGroupsViewController.m
//  Wireframe
//
//  Created by Glenn Sonna on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "ShowGroupsViewController.h"

@interface ShowGroupsViewController ()

@end



@implementation ShowGroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.mGroups = @[@1, @2, @3, @4];
    
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.separatorColor = [UIColor clearColor];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"groupCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    UIView* v1 = [cell.contentView viewWithTag:10];
    v1.layer.borderWidth = 1;
    v1.layer.borderColor = [UIColor blackColor].CGColor;
    
    UIView* v2 = [cell.contentView viewWithTag:15];
    v2.layer.borderWidth = 1;
    v2.layer.borderColor = [UIColor blackColor].CGColor;
    
    UILabel *name = (UILabel*)[cell.contentView viewWithTag:100];
    name.text = [NSString stringWithFormat:@"Group %ld", (long)indexPath.row];
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mGroups.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //self.mShowOneGroupViewController =
    //[[ShowOneGroupViewController alloc] initWithNibName:@"ShowOneGroup" bundle:nil];
    //[self presentViewController:self.mShowOneGroupViewController animated:YES completion:nil];
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
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
