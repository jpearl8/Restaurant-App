//
//  WaiterViewController.m
//  
//
//  Created by jpearl on 7/16/19.
//


/* TODO:
get dish items from restaurant table
hookup search bar
pass final array on submit button of data table
 */
#import "WaiterViewController.h"
#import "Dish.h"
#import "WaitTableViewCell.h"
#import "Parse/Parse.h"

@interface WaiterViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *menuItems;
@property (strong, nonatomic) NSArray <Dish *>*dishes;
@property (strong, nonatomic) NSArray <Dish *>*filteredDishes;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation WaiterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuItems.delegate = self;
    self.menuItems.dataSource = self;
    self.searchBar.delegate = self;
    // Do any additional setup after loading the view.
    
    [self runDishQuery];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(runDishQuery) forControlEvents:UIControlEventValueChanged];
    [self.menuItems insertSubview:refreshControl atIndex:0];
    self.menuItems.rowHeight = UITableViewAutomaticDimension;
    // construct query
   
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredDishes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WaitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Orders"];
    Dish *dish = self.filteredDishes[indexPath.row];
    cell.dish = dish;
    cell.name.text = dish.name;
    cell.type.text = dish.type;
    cell.dishDescription.text = dish.dishDescription;
    PFFileObject *dishImageFile = (PFFileObject *)dish.image;
    [dishImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if(!error){
            cell.image.image = [UIImage imageWithData:imageData];
        }
    }];
    return cell;
}


-(void)runDishQuery{
    PFQuery *dishQuery = [Dish query];
    [dishQuery includeKey:@"restaurantID"];
    // id test = [PFUser currentUser].objectId;
    NSString *test = @"XuLMO3Jh3r";
    [dishQuery whereKey:@"restaurantID" containsString:test];
    // fetch data asynchronously
    [dishQuery findObjectsInBackgroundWithBlock:^(NSArray<Dish *> * _Nullable dishes, NSError * _Nullable error) {
        if (error){
            NSLog(@"%@", error);
        }
        if (dishes.count != 0) {
            // do something with the data fetched
            NSLog(@"%@", dishes);
            self.dishes = dishes;
            self.filteredDishes = dishes;
            [self.menuItems reloadData];
            [self.refreshControl endRefreshing];
        }
        else {
            NSLog(@"no error but nothin here");
            [self.refreshControl endRefreshing];
        }
    }];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject[@"name"] containsString:searchText];
        }];
        self.filteredDishes = [self.dishes filteredArrayUsingPredicate:predicate];
    }
    else {
        self.filteredDishes = self.dishes;
    }
    [self.menuItems reloadData];
}
- (IBAction)onSubmit:(id)sender{
    NSArray *cells = [self.menuItems visibleCells];
    for (WaitTableViewCell *cell in cells)
    {
       // UILabel *labelF = [cell name];
        NSLog(@"%d", cell.orderAmount);
    }
}



//#pragma mark - Navigation
//
////// In a storyboard-based application, you will often want to do a little preparation before navigation
////- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
////    // Get the new view controller using [segue destinationViewController].
////    // Pass the selected object to the new view controller.
////}
////*/

@end
