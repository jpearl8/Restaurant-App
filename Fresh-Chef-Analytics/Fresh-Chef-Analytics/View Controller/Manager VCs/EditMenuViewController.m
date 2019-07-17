//
//  EditMenuViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "EditMenuViewController.h"
#import "Dish.h"

@interface EditMenuViewController ()

@end

@implementation EditMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
}
- (IBAction)saveItem:(id)sender {
    [Dish postNewDish:self.nameField.text withType:self.typeField.text withDescription:self.descriptionView.text withPrice:[NSNumber numberWithFloat:[self.priceField.text floatValue]] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded)
        {
            // Here we should add the table view reload so new value pops up
            NSLog(@"yay");
        }
        else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
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
