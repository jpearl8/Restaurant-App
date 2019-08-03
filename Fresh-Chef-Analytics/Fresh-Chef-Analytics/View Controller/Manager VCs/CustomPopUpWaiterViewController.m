//
//  CustomPopUpWaiterViewController.m
//  Fresh-Chef-Analytics
//
//  Created by selinons on 8/1/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "CustomPopUpWaiterViewController.h"
#import "EditWaitViewController.h"

@interface CustomPopUpWaiterViewController ()
@property (strong, nonatomic) Waiter *theNewWaiter;
@end

@implementation CustomPopUpWaiterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.profileImage.layer.cornerRadius = 0.5 * self.profileImage.bounds.size.height;
    self.profileImage.layer.masksToBounds = YES;}
- (IBAction)saveWaiter:(id)sender {
    self.theNewWaiter = [Waiter addNewWaiter:self.nameField.text withYears:[NSNumber numberWithFloat:[self.yearsField.text floatValue]] withImage:self.profileImage.image withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded)
        {
            NSLog(@"yay");
        }
        else
        {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [self didAddWaiter:self.theNewWaiter];
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
    if (editedImage != nil)
    {
        self.profileImage.image = editedImage;

    }
    // Dismiss UIImagePickerController to go back to original view controller
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) didAddWaiter: (Waiter *) waiter
{
    [[WaiterManager shared] addWaiter:waiter];
    if ([self.presentingViewController isKindOfClass:[EditWaitViewController class]])
    {
        EditWaitViewController *editWVC = (EditWaitViewController*)self.presentingViewController;
        editWVC.roster = [[WaiterManager shared] roster];
        [editWVC.tableView reloadData];
        [self dismissViewControllerAnimated:YES completion:nil];
    }

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
