//
//  MenuListViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "MenuListViewController.h"
#import "MenuListTableViewCell.h"
#import "Parse/Parse.h"
#import "DishDetailsViewController.h"
#import "MenuManager.h"
#import "UIRefs.h"

@interface MenuListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *menuList;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSArray *dishes;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableDictionary *orderedDishesDict;
@property (strong, nonatomic) NSMutableDictionary *filteredCategoriesOfDishes;
@property (strong, nonatomic) NSArray *categories;
@property (weak, nonatomic) IBOutlet MKDropdownMenu *dropDown;
@property (strong, nonatomic) NSArray *dropDownCats;
@property (weak, nonatomic) IBOutlet UILabel *dropDownLabel;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (weak, nonatomic) IBOutlet UIView *searchLabelView;
@property (assign) NSInteger expandedSectionHeaderNumber;
@property (assign) UITableViewHeaderFooterView *expandedSectionHeader;

@property (strong) NSDictionary *sectionItems;
@property (strong) NSArray *sectionNames;
@end

@implementation MenuListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dropDown.delegate = self;
    self.dropDown.dataSource = self;
    self.menuList.dataSource = self;
    self.menuList.delegate = self;
    self.searchBar.delegate = self;
    self.searchBar.hidden = YES;
    
    self.searchLabelView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.searchLabelView.layer.borderWidth = 0.3;
    self.dropDownCats = @[@"FREQUENCY", @"RATING", @"PRICE"];
    self.selectedIndex = 0;
    self.dropDownLabel.text = @"SORT";
    self.dishes = [[MenuManager shared] dishes];
    //setting dictionary elements
    self.categories = [[[MenuManager shared] categoriesOfDishes] allKeys];
    self.orderedDishesDict = [[NSMutableDictionary alloc] initWithDictionary:[[MenuManager shared] dishesByFreq]];
    self.filteredCategoriesOfDishes = [NSMutableDictionary alloc];
    self.filteredCategoriesOfDishes = [self.filteredCategoriesOfDishes initWithDictionary:self.orderedDishesDict];
    
    self.sectionNames = [[NSArray alloc] initWithArray:self.categories];
    self.sectionItems = [[NSDictionary alloc] initWithDictionary:self.filteredCategoriesOfDishes];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.menuList scrollToRowAtIndexPath:indexPath
                         atScrollPosition:UITableViewScrollPositionTop
                                 animated:YES];
//    NSLog(@"orderedDishes")
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
    UIFont * font = [UIFont systemFontOfSize:10];

    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];

    NSAttributedString *titleForComponent = [[NSAttributedString alloc] initWithString:self.dropDownCats[row] attributes:attributes];
    return titleForComponent;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.categories.count) {
        return [self.categories objectAtIndex:section];
    }
    return @"";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.menuList deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // recast your view as a UITableViewHeaderFooterView
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.contentView.backgroundColor = [UIColor whiteColor];
    header.layer.borderColor = [UIColor grayColor].CGColor;
    header.layer.borderWidth = 0.3;
    header.textLabel.textColor = [[UIRefs shared] colorFromHexString:@"#392382"];
    UIImageView *viewWithTag = [self.view viewWithTag:10203 + section];
    if (viewWithTag) {
        [viewWithTag removeFromSuperview];
    }
    // add the arrow image
    CGSize headerFrame = self.view.frame.size;
    UIImageView *theImageView = [[UIImageView alloc] initWithFrame:CGRectMake(headerFrame.width - 80, 20, 50, 50)];
    theImageView.image = [UIImage imageNamed:@"purple-arrow"];
    theImageView.tintColor = [UIColor whiteColor];
    theImageView.tag = 10203 + section;
    [header addSubview:theImageView];
    // make headers touchabl
    header.tag = section;
    UITapGestureRecognizer *headerTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderWasTouched:)];
    [header addGestureRecognizer:headerTapGesture];
}
- (void)sectionHeaderWasTouched:(UITapGestureRecognizer *)sender {
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)sender.view;
    NSInteger section = headerView.tag;
    UIImageView *eImageView = (UIImageView *)[headerView viewWithTag:10203 + section];
    self.expandedSectionHeader = headerView;
    if (self.expandedSectionHeaderNumber == -1) {
        self.expandedSectionHeaderNumber = section;
        [self tableViewExpandSection:section withImage: eImageView];
    } else {
        if (self.expandedSectionHeaderNumber == section) {
            [self tableViewCollapeSection:section withImage: eImageView];
            self.expandedSectionHeader = nil;
        } else {
            UIImageView *cImageView  = (UIImageView *)[self.view viewWithTag:10203 + self.expandedSectionHeaderNumber];
            [self tableViewCollapeSection:self.expandedSectionHeaderNumber withImage: cImageView];
            [self tableViewExpandSection:section withImage: eImageView];
        }
    }

}
- (IBAction)pressedSearch:(id)sender {
    self.searchBar.hidden = !(self.searchBar.hidden);
    if (self.searchBar.hidden == NO)
    {
        [self.menuList setContentOffset:CGPointZero animated:YES];
    }
    else
    {
        [self.menuList setContentOffset:CGPointMake(0, self.searchBar.frame.size.height) animated:YES];
    }
}

- (void)tableViewExpandSection:(NSInteger)section withImage:(UIImageView *)imageView {
    NSArray *sectionData = self.filteredCategoriesOfDishes[self.categories[section]];
    if (sectionData.count == 0) {
        self.expandedSectionHeaderNumber = -1;
        return;
    } else {
        [UIView animateWithDuration:0.4 animations:^{
            imageView.transform = CGAffineTransformMakeRotation((180.0 * M_PI) / 180.0);
        }];
        NSMutableArray *arrayOfIndexPaths = [NSMutableArray array];
        for (int i=0; i< sectionData.count; i++) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:section];
            [arrayOfIndexPaths addObject:index];
        }
        self.expandedSectionHeaderNumber = section;

        [self.menuList beginUpdates];

        [self.menuList insertRowsAtIndexPaths:arrayOfIndexPaths withRowAnimation: UITableViewRowAnimationFade];

        [self.menuList endUpdates];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.expandedSectionHeaderNumber];
        [self.menuList scrollToRowAtIndexPath:indexPath
                             atScrollPosition:UITableViewScrollPositionTop
                                     animated:YES];
    }
}
- (void)tableViewCollapeSection:(NSInteger)section withImage:(UIImageView *)imageView {
    NSArray *sectionData = self.filteredCategoriesOfDishes[self.categories[section]];
    self.expandedSectionHeaderNumber = -1;
    if (sectionData.count == 0) {
        return;
    } else {
        [UIView animateWithDuration:0.4 animations:^{
            imageView.transform = CGAffineTransformMakeRotation((0.0 * M_PI) / 180.0);
        }];
        NSMutableArray *arrayOfIndexPaths = [NSMutableArray array];
        for (int i=0; i< sectionData.count; i++) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:section];
            [arrayOfIndexPaths addObject:index];
        }
        [self.menuList beginUpdates];
        [self.menuList deleteRowsAtIndexPaths:arrayOfIndexPaths withRowAnimation: UITableViewRowAnimationFade];
        [self.menuList endUpdates];
        [self.menuList setContentOffset:CGPointMake(0, self.searchBar.frame.size.height) animated:YES];
    }
}
- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedIndex = row;
    if(self.selectedIndex == 0){
        self.orderedDishesDict = [[MenuManager shared] dishesByFreq];
    } else if (self.selectedIndex == 1) {
        self.orderedDishesDict = [[MenuManager shared] dishesByRating];
    } else if (self.selectedIndex == 2) {
        self.orderedDishesDict = [[MenuManager shared] dishesByPrice];
    } else {
        NSLog(@"no buttons pressed");
    }
    self.dropDownLabel.text = self.dropDownCats[row];

    self.filteredCategoriesOfDishes = [NSMutableDictionary dictionaryWithDictionary:self.orderedDishesDict];
    [self.menuList reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.expandedSectionHeaderNumber];

    [self.menuList scrollToRowAtIndexPath:indexPath
                         atScrollPosition:UITableViewScrollPositionTop
                                 animated:YES];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    MenuListTableViewCell *cell = [self.menuList dequeueReusableCellWithIdentifier: @"Dish"];
    Dish *dish = self.filteredCategoriesOfDishes[self.categories[section]][indexPath.row];
    cell.dish = dish;
    cell.name.text = dish.name;
//    cell.rating.text = [dish.rating stringValue];
    cell.rating.text = [NSString stringWithFormat:@"%@",[[MenuManager shared] averageRating:dish]];
//    cell.orderFrequency.text = [dish.orderFrequency stringValue];
    cell.orderFrequency.text = [[dish.orderFrequency stringValue] stringByAppendingString:@" sold"];
    cell.price.text = [@"$" stringByAppendingString:[NSString stringWithFormat:@"%.2f", [dish.price floatValue]]];
    cell.selectedIndex = self.selectedIndex;
//    cell.ratingCategory = dish.ratingCategory;
    cell.ratingCategory = [[MenuManager shared] getRankOfType:@"rating" ForDish:dish];
    //    cell.freqCategory = dish.freqCategory;
    cell.freqCategory = [[MenuManager shared] getRankOfType:@"freq" ForDish:dish];;
    //    cell.profitCategory = dish.profitCategory;
    cell.profitCategory = [[MenuManager shared] getRankOfType:@"profit" ForDish:dish];
    if(dish.image != nil){
        PFFileObject *dishImageFile = (PFFileObject *)dish.image;
        [dishImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if(!error){
                cell.image.image = [UIImage imageWithData:imageData];
            }
        }];
    } else {
        cell.image.image = [UIImage imageNamed:@"image_placeholder"];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ((self.menuList.frame.size.height - 30) / [self.categories count]/2);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.sectionNames.count > 0) {
        self.menuList.backgroundView = nil;
        return self.sectionNames.count;
    } else {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        messageLabel.text = @"Retrieving data.\nPlease wait.";
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:20];
        [messageLabel sizeToFit];
        self.menuList.backgroundView = messageLabel;
        return 0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.expandedSectionHeaderNumber == section) {
        NSMutableArray *arrayOfItems = self.filteredCategoriesOfDishes[self.sectionNames[section]];
        return arrayOfItems.count;
    } else {
        return 0;
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            return [[evaluatedObject[@"name"] lowercaseString] containsString:[searchText lowercaseString]];
        }];
        for (NSString *category in self.categories)
        {
            NSArray *filteredCategory = [[NSArray alloc] initWithArray:self.orderedDishesDict[category]];
            filteredCategory = [filteredCategory filteredArrayUsingPredicate:predicate];
            [self.filteredCategoriesOfDishes setValue:filteredCategory forKey:category];
        }
        [self.menuList reloadData];

    }
    else {
        self.filteredCategoriesOfDishes = [NSMutableDictionary dictionaryWithDictionary:self.orderedDishesDict];
        [self.menuList reloadData];

    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:MenuListTableViewCell.class]){
        MenuListTableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.menuList indexPathForCell:tappedCell];
        NSInteger section = indexPath.section;
        if (indexPath.row >= 0){
            Dish *dish = self.filteredCategoriesOfDishes[self.categories[section]][indexPath.row];
            UINavigationController *navController = [segue destinationViewController];
            DishDetailsViewController *dishDetailsVC = (DishDetailsViewController *)navController.topViewController;
            dishDetailsVC.dish = dish;
        }
    }
}


@end
