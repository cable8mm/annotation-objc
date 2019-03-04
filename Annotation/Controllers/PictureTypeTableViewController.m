//
//  PictureTypeTableViewController.m
//  Annotation
//
//  Created by 이삼구 on 12/02/2019.
//  Copyright © 2019 doai.ai. All rights reserved.
//

#import "PictureTypeTableViewController.h"
#import "PictureCollectionViewController.h"
#import "AppDelegate.h"

@interface PictureTypeTableViewController ()
@property (nonatomic, retain) NSArray *pictureTypes;
@end

@implementation PictureTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.pictureTypes = @[@"All", @"Chest X-ray", @"Fundus Optics", @"2D pathology(breast cancer)"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];

    if(delegate.isShowedIntroduce == 0) {
        NSIndexPath *selectedCellIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView selectRowAtIndexPath:selectedCellIndexPath
                           animated:YES
                     scrollPosition:UITableViewScrollPositionNone];
        [self performSegueWithIdentifier:@"showPictureCollectionViewController" sender:self];
    }
//    [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:selectedCellIndexPath];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.pictureTypes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pictureTypeCell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *pictureType =self.pictureTypes[indexPath.row];
    cell.textLabel.text = pictureType;

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"===");
    if([segue.identifier isEqualToString:@"showPictureCollectionViewController"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        UINavigationController *navController = [segue destinationViewController];
        PictureCollectionViewController *pictureCollectionViewController = (PictureCollectionViewController *)navController.topViewController;
        pictureCollectionViewController.os_picture_type_id = (int)indexPath.row;
        pictureCollectionViewController.title = self.pictureTypes[indexPath.row];
    }
}

@end
