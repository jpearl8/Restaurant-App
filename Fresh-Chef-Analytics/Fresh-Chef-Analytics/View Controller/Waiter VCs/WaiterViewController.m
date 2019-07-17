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

@interface WaiterViewController () <UITableViewDelegate, UITableViewDataSource>
    @property (weak, nonatomic) IBOutlet UITableView *menuItems;
    @property (strong, nonatomic) NSArray <Dish *>*dishes;
@end

@implementation WaiterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuItems.delegate = self;
    self.menuItems.dataSource = self;
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dishes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WaitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Orders"];
    Dish *dish = self.dishes[indexPath.row];
    cell.dish = dish;
    cell.name.text = dish.name;
    cell.type.text = dish.type;
    cell.description.text = dish.description;
    PFFileObject *dishImageFile = (PFFileObject *)dish.image;
    [dishImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if(!error){
            cell.image.image = [UIImage imageWithData:imageData];
        }
    }];
    return cell;
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
