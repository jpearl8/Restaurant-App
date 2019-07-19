//
//  EditWaitViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "EditWaitViewController.h"
#import "Waiter.h"
#import "WaiterManager.h"
#import "EditWaiterCell.h"

@interface EditWaitViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *roster;
@end

@implementation EditWaitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.roster = [[WaiterManager shared] roster];
    // Do any additional setup after loading the view.
}
- (IBAction)saveWaiter:(id)sender {
    Waiter *newWaiter = [Waiter addNewWaiter:self.nameField.text withYears:[NSNumber numberWithFloat:[self.yearsField.text floatValue]] withImage:self.profileImage.image withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded)
        {
            NSLog(@"yay");
        }
        else
        {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [self didAddWaiter:newWaiter];
}

- (IBAction)didTapWaiterImage:(id)sender {
    NSLog(@"tapped camera image");
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    // if camera is available, use it, else, use camera roll
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    self.profileImage.image = editedImage;
    // Dismiss UIImagePickerController to go back to original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) didAddWaiter: (Waiter *) waiter
{
    [[WaiterManager shared] addWaiter:waiter];
    self.roster = [[WaiterManager shared] roster];
    [self.tableView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditWaiterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditWaiterCell" forIndexPath:indexPath];
    Waiter *waiter = self.roster[indexPath.row];
    cell.waiter = waiter;
    cell.waiterName.text = waiter.name;
    cell.waiterYearsAt.text = [NSString stringWithFormat:@"%@", waiter.yearsWorked];
    cell.waiterRating.text = [NSString stringWithFormat:@"%@", waiter.rating];
    cell.waiterTableTops.text = [NSString stringWithFormat:@"%@", waiter.tableTops];
    cell.waiterNumCustomers.text = [NSString stringWithFormat:@"%@", waiter.numOfCustomers];
    cell.waiterTips.text = [NSString stringWithFormat:@"%@", waiter.tipsMade];
    if(waiter.image!=nil){
        [waiter.image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if(!error){
                cell.profileImage.image = [UIImage imageWithData:imageData];
            } else {
                NSLog(@"Error setting waiter image with error: %@", error.localizedDescription);
            }
        }];
    } else {
        cell.profileImage.image = nil;
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.roster.count;
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
