//
//  CustomPopUpViewController.m
//  Fresh-Chef-Analytics
//
//  Created by selinons on 8/1/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "CustomPopUpViewController.h"
#import "EditMenuViewController.h"
#import "UITextView+Placeholder.h"
#import "UIRefs.h"

@interface CustomPopUpViewController ()
@property (strong, nonatomic) IBOutlet UIView *viewClear;
@property (strong, nonatomic) Dish *theNewDish;
@property (strong, nonatomic) UIButton *chooseLibrary;

@end

@implementation CustomPopUpViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.chooseLibrary = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chooseLibrary addTarget:self
                           action:@selector(didTapLibrary:)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.chooseLibrary setTitle:@"Choose from Library" forState:UIControlStateNormal];
    self.chooseLibrary.frame = CGRectMake(300, 212, 100, 40.0);
    self.chooseLibrary.backgroundColor = [[UIRefs shared] colorFromHexString:[UIRefs shared].purpleAccent];
    [self.view addSubview:self.chooseLibrary];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.chooseLibrary.hidden = NO;
    }
    else
    {
        self.chooseLibrary.hidden = YES;
    }
    self.viewClear.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.3];
    self.descriptionView.placeholder = @"Dish description";
    self.descriptionView.placeholderColor = [UIColor lightGrayColor];
    // Do any additional setup after loading the view.
}

- (IBAction)saveItem:(id)sender {
    self.theNewDish = [Dish postNewDish:self.nameField.text withType:self.typeField.text withDescription:self.descriptionView.text withPrice:[NSNumber numberWithFloat:[self.priceField.text floatValue]] withImage:self.dishView.image withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded)
        {
            // Here we should add the table view reload so new value pops up

        }
        else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [self didAddItem:self.theNewDish];
    
}
- (IBAction)didTapLibrary:(id)sender
{
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
}

- (IBAction)didTapDishImage:(id)sender {
    
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
        self.dishView.image = editedImage;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)keyboardBye:(id)sender {
    [self.view endEditing:YES];

}

- (void) didAddItem: (Dish *) dish
{
    NSArray *dishesOfType;
    [[MenuManager shared] addDishToDict:dish toArray:dishesOfType];
    if ([self.presentingViewController isKindOfClass:[EditMenuViewController class]])
    {
        EditMenuViewController *editMVC = (EditMenuViewController*)self.presentingViewController;
        editMVC.categories = [[[MenuManager shared] categoriesOfDishes] allKeys];
//        editMVC.categories = [editMVC.categories arrayByAddingObject:self.theNewDish.type];
        editMVC.sectionNames = editMVC.categories;
        [editMVC.tableView reloadData];
    }
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)didTapCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    EditMenuViewController *editMVC = [segue destinationViewController];
//    editMVC.categories = [editMVC.categories arrayByAddingObject:self.theNewDish.type];
//    [editMVC.tableView reloadData];
//}


@end
