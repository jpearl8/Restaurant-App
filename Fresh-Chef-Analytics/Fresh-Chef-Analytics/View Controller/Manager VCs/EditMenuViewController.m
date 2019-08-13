//
//  EditMenuViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "EditMenuViewController.h"
#import "UIRefs.h"

@interface EditMenuViewController ()

@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (assign) NSInteger expandedSectionHeaderNumber;
@property (assign) UITableViewHeaderFooterView *expandedSectionHeader;

@property (weak, nonatomic) IBOutlet UIView *headerView;

@end

@implementation EditMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pngguru.com-id-bymze"]];
    [self updateLocalFromData];
    self.addButton.layer.shadowRadius  = 1.5f;
    self.addButton.layer.shadowColor   = [UIColor colorWithRed:176.f/255.f green:199.f/255.f blue:226.f/255.f alpha:1.f].CGColor;
    self.addButton.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    self.addButton.layer.shadowOpacity = 0.9f;
    self.addButton.layer.masksToBounds = NO;
    
    UIEdgeInsets shadowInsets     = UIEdgeInsetsMake(0, 0, -1.5f, 0);
    UIBezierPath *shadowPath      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(self.addButton.bounds, shadowInsets)];
    self.categories = [[[MenuManager shared] categoriesOfDishes] allKeys];

    self.addButton.layer.shadowPath    = shadowPath.CGPath;
    self.sectionNames = self.categories;
    self.sectionItems = self.categoriesOfDishes;
    if (self.categoriesOfDishes.count != nil)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
    }

    // Do any additional setup after loading the view.
}

- (void)editMenuCell:(EditMenuCell *)editMenuCell didTap:(Dish *)dish
{
    [[MenuManager shared] removeDishFromTable:dish withCompletion:^(NSMutableDictionary * _Nonnull categoriesOfDishes, NSError * _Nonnull error) {
        if (error==nil)
        {
            self.categoriesOfDishes = categoriesOfDishes;
            self.categories = [self.categoriesOfDishes allKeys];
            self.sectionNames = self.categories;
            self.sectionItems = self.categoriesOfDishes;
            
            //[self updateLocalFromData];
            [self.tableView reloadData];
        }
        else
        {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    EditMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditMenuCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.cellView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    cell.cellView.layer.borderWidth = 0.3;
    
    Dish *dish = self.categoriesOfDishes[self.categories[section]][indexPath.row];
    cell.dish = dish;
    cell.dishName.text = dish.name;
    // set image if the dish has one
    if(dish.image!=nil){
        [dish.image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if(!error){
                cell.dishView.image = [UIImage imageWithData:imageData];
            } else {
                NSLog(@"Error setting cell dish image with error: %@", error.localizedDescription);
            }
        }];
    } else {
        cell.dishView.image = [UIImage imageNamed:@"image_placeholder"];
    }
    cell.dishView.layer.cornerRadius = cell.dishView.frame.size.width/2;
    cell.dishPrice.text = [@"$" stringByAppendingString:[NSString stringWithFormat:@"%.2f", [dish.price floatValue]]];
    cell.dishDescription.text = dish.dishDescription;
    return cell;
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
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
//    CGSize headerFrame = self.view.frame.size;
    UIImageView *theImageView = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.frame.size.width-tableView.sectionHeaderHeight, 0, tableView.sectionHeaderHeight, tableView.sectionHeaderHeight)];
    theImageView.image = [UIImage imageNamed:@"purple-arrow-down"];
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
- (void)tableViewExpandSection:(NSInteger)section withImage:(UIImageView *)imageView {
    NSArray *sectionData = self.categoriesOfDishes[self.categories[section]];
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
        
        [self.tableView beginUpdates];
        
        [self.tableView insertRowsAtIndexPaths:arrayOfIndexPaths withRowAnimation: UITableViewRowAnimationFade];
        
        [self.tableView endUpdates];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.expandedSectionHeaderNumber];
        [self.tableView scrollToRowAtIndexPath:indexPath
                             atScrollPosition:UITableViewScrollPositionTop
                                     animated:YES];
    }
}
- (void)tableViewCollapeSection:(NSInteger)section withImage:(UIImageView *)imageView {
    NSArray *sectionData = self.categoriesOfDishes[self.categories[section]];
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
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:arrayOfIndexPaths withRowAnimation: UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        [self.tableView setContentOffset:CGPointZero animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (self.tableView.frame.size.height / [self.categories count]);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.sectionNames.count > 0) {
        self.tableView.backgroundView = nil;
        return self.sectionNames.count;
    } else {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        messageLabel.text = @"Retrieving data.\nPlease wait.";
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:20];
        [messageLabel sizeToFit];
        self.tableView.backgroundView = messageLabel;
        return 0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.expandedSectionHeaderNumber == section) {
        NSMutableArray *arrayOfItems = self.categoriesOfDishes[self.sectionNames[section]];
        return arrayOfItems.count;
    } else {
        return 0;
    }
}
- (void) updateLocalFromData
{
    self.categoriesOfDishes = [[MenuManager shared] categoriesOfDishes];
    self.categories = [self.categoriesOfDishes allKeys];
}
- (IBAction)dismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Table View Protocol Methods

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
