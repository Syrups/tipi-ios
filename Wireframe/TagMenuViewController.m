//
//  TagMenuViewController.m
//  Wireframe
//
//  Created by Glenn Sonna on 04/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "TagMenuViewController.h"

@interface TagMenuViewController ()

@end



@implementation TagMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mTags = @[@"Los Angeles", @"Recettes", @"Concerts", @"Soirees JV"];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"tagItem";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    
    UILabel *name = (UILabel*)[cell.contentView viewWithTag:90];
    name.text = [self.mTags objectAtIndex:indexPath.row];
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mTags.count;
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
