//
//  OrdersManagerViewController.m
//  Fresh-Chef-Analytics
//
//  Created by rgallardo on 7/24/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//
#import "MKDropdownMenu.h"
#import "OrdersManagerViewController.h"
#import "ManagerOrderTableViewCell.h"
#import "OrderManager.h"

@interface OrdersManagerViewController () <MKDropdownMenuDelegate, MKDropdownMenuDataSource>

@property (strong, nonatomic) NSMutableDictionary *openOrdersByTable;
@property (strong, nonatomic) NSArray *closedOrders;
@property (strong, nonatomic) NSArray *tables;

@property (weak, nonatomic) IBOutlet UIView *openContainer;
@property (weak, nonatomic) IBOutlet UIView *closedContainer;
@property (strong, nonatomic) NSString *whichOrders;
@property (weak, nonatomic) IBOutlet MKDropdownMenu *dropDown;
@property (strong, nonatomic) NSArray *dropDownCats;
@property (weak, nonatomic) IBOutlet UILabel *dropDownLabel;
@property (assign, nonatomic) NSInteger selectedIndex;

@end

@implementation OrdersManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dropDown.delegate = self;
    self.dropDown.dataSource = self;
    self.openOrdersByTable = [[OrderManager shared] openOrdersByTable];
    self.closedOrders = [[OrderManager shared] closedOrders];
    self.tables = [self.openOrdersByTable allKeys];
    self.whichOrders = @"Open";
    self.dropDownCats = @[@"Open Orders", @"Closed Orders"];
    self.selectedIndex = 0;
    self.dropDownLabel.text = @"Open Orders";
}

- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu
{
    return 1;
}
- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component
{
    return [self.dropDownCats count];
}
- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    UIFont * font = [UIFont systemFontOfSize:13
                     ];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    
    NSAttributedString *titleForComponent = [[NSAttributedString alloc] initWithString:self.dropDownCats[row] attributes:attributes];
    return titleForComponent;
}
- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedIndex = row;
    self.dropDownLabel.text = self.dropDownCats[row];
    
    [self showContainer:self];
}


- (IBAction)showContainer:(id)sender {
    

    if (self.selectedIndex == 0)
    {

        [UIView animateWithDuration:0.5 animations:^{
            self.openContainer.alpha = 1;
            self.closedContainer.alpha = 0;
        }];
    }
    else if (self.selectedIndex == 1)
    {

        [UIView animateWithDuration:0.5 animations:^{
            self.openContainer.alpha = 0;
            self.closedContainer.alpha = 1;
        }];
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

//- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    <#code#>
//}
//
//- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    <#code#>
//}

@end
