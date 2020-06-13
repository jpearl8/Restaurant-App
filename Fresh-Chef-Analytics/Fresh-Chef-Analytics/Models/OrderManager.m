
//  OrderManager.m
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/24/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "OrderManager.h"
#import "MenuManager.h"
#import "FCADate.h"
#import "NSDate+DayMethods.h"

@implementation OrderManager
// singleton generates a single instance and initiates itself
+ (instancetype)shared {
    static OrderManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void) fetchOpenOrderItems:(PFUser *) restaurant  withCompletion:(void (^)(NSArray * openOrders, NSError * error))fetchedOpenOrders
{
    PFQuery *openOrderQuery;
    openOrderQuery = [OpenOrder query];
    [openOrderQuery whereKey:@"restaurantId" equalTo:restaurant.objectId];
    [openOrderQuery findObjectsInBackgroundWithBlock:^(NSArray * openOrders, NSError * error) {
        if (!error)
        {
            self.allOpenOrders = openOrders;
            [self sortOrdersByTable];
            fetchedOpenOrders(self.allOpenOrders, nil);
        }
    }];
}


- (void) sortOrdersByTable
{
    self.openOrdersByTable = [[NSMutableDictionary alloc] init];
    NSArray *ordersByTable;
    for (OpenOrder *order in self.allOpenOrders)
    {
        [self addOrderToDict:order toArray:ordersByTable];
    }
}

- (void) addOrderToDict : (OpenOrder *) order toArray : (NSArray *) ordersOfTable
{
    NSString *table = [order.table stringValue];
    if (self.openOrdersByTable[table] != nil)
    {
        ordersOfTable = self.openOrdersByTable[table];
        ordersOfTable = [ordersOfTable arrayByAddingObject:order];
    }
    else
    {
        ordersOfTable = [NSArray arrayWithObject:order];
    }
    [self.openOrdersByTable setObject:ordersOfTable forKey:table];
}

- (void) fetchClosedOrderItems:(PFUser *) restaurant  withCompletion:(void (^)(NSArray * closedOrders, NSError * error))fetchedClosedOrders
{
    PFQuery *closedOrderQuery;
    closedOrderQuery = [ClosedOrder query];
    [closedOrderQuery whereKey:@"restaurant" equalTo:restaurant];
    [closedOrderQuery findObjectsInBackgroundWithBlock:^(NSArray * closedOrders, NSError * error) {
        if (!error)
        {
            self.closedOrders = closedOrders;
            fetchedClosedOrders(self.closedOrders, nil);
            [self setClosedOrdersByDate];
            [self setProfitByDate];
            [self setBusynessByDate];
            [self setTestProfitAndBusynessDicts];
        }
    }];
}

- (void)setClosedOrdersByDate
{
    self.closedOrdersByDate = [[NSMutableDictionary alloc] init];
    NSArray *ordersForDate;
    for (ClosedOrder *anOrder in self.closedOrders) {
        [self addClosedOrder:anOrder toArray:ordersForDate];
    }
    NSLog(@"Closed Orders Dict: %@", self.closedOrdersByDate);
    

    
}
    
- (void) addClosedOrder:(ClosedOrder *)anOrder toArray:(NSArray *)arrayForDate
{
    NSString *dayString = [anOrder.createdAt dateFromNSDate];
    if (self.closedOrdersByDate[dayString]) {
        arrayForDate = self.closedOrdersByDate[dayString];
        arrayForDate = [arrayForDate arrayByAddingObject:anOrder];
    } else {
        arrayForDate = [NSArray arrayWithObject:anOrder];
    }
    [self.closedOrdersByDate setObject:arrayForDate forKey:dayString];
}

//- (BOOL)isSameDay:(NSDate*)date1 otherDay:(NSDate*)date2 {
//    NSCalendar* calendar = [NSCalendar currentCalendar];
//
//    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
//    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
//    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
//
//    return [comp1 day]   == [comp2 day] &&
//    [comp1 month] == [comp2 month] &&
//    [comp1 year]  == [comp2 year];
//}



- (void)setProfitByDate
{
    self.profitByDate = [[NSMutableDictionary alloc] init];
    
    for (id date in self.closedOrdersByDate)
    {
        // loop through closed orders by day add amount*dish.price to value for each date
        float daysRevenue = 0;
        for (ClosedOrder *anOrder in self.closedOrdersByDate[date])
        {
            // find  order total
            float orderTotal = 0;
            for(int i = 0; i < anOrder.amounts.count; i++){
                // get the dish object from the dish name then get its price
                Dish *dish = [self getDishWithName:anOrder.dishes[i]];
                float dishPrice = [dish.price floatValue];
                float cost = dishPrice * [((NSNumber *)anOrder.amounts[i]) floatValue];
                orderTotal += cost;
            }
            daysRevenue += orderTotal;
        }
        [self.profitByDate setValue:@(daysRevenue) forKey:date];
    }
    NSLog(@"Profit by date: %@", self.profitByDate);
    // ***** set self.originals before adding previous dates to the dictionary *****
    NSArray *unsortedArr = [self.profitByDate allKeys];
    self.originalXLabels = [[unsortedArr sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
    self.originalProfitByDate = [[NSMutableArray alloc] init];
    for(NSString *date in self.originalXLabels){
        [self.originalProfitByDate addObject:self.profitByDate[date]];
//        [self.originalBusynessByDate addObject:self.busynessByDate[date]];
    }

    NSMutableArray *dateList = [NSMutableArray array];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1]; // used to increment day by 1 each iteration of while loop below
    //create start date
    NSDateComponents *startComps = [[NSDateComponents alloc] init];
    [startComps setDay:1];
    [startComps setMonth:7];
    [startComps setYear:2018];
    NSDate *startDate = [[NSCalendar currentCalendar] dateFromComponents:startComps];
    // create endDate
    NSDateComponents *endComps = [[NSDateComponents alloc] init];
    [endComps setDay:1];
    [endComps setMonth:8];
    [endComps setYear:2019];
    NSDate *endDate = [[NSCalendar currentCalendar] dateFromComponents:endComps];

    [dateList addObject:startDate];
    NSDate *currentDate = startDate;
    currentDate = [currentCalendar dateByAddingComponents:comps toDate:currentDate options:0];
    while ([endDate compare:currentDate] != NSOrderedAscending) {
        [dateList addObject:currentDate];
        currentDate = [currentCalendar dateByAddingComponents:comps toDate:currentDate options:0];
    }
    // For dates that are not in self.profitByDate, add a key with that date and a value of nil
    NSString *dayString;
    // keep track of last index before a value exists and add -1 each time
    BOOL preceedsData = YES;
    for (NSDate *date in dateList) {
        //make sure key and date are
        dayString = [date dateFromNSDate];
        if ([self.profitByDate objectForKey:dayString] == nil && preceedsData) {
            [self.profitByDate setValue:@(-1) forKey:dayString]; // points before any data will have value -1
        } else if ([self.profitByDate objectForKey:dayString] == nil && !preceedsData){
            [self.profitByDate setValue:@(-2) forKey:dayString]; // points with no data after points with data will have value -2
        } else {
            preceedsData = NO;
        }
    }
    
    // ***Replace profitByDate with profitByDateTest for presentation
    NSArray *unsortedArr2 = [self.profitByDate allKeys];
    self.xLabelsArray = [[unsortedArr2 sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
    for (NSString *date in self.xLabelsArray) {
        [self.profitArray addObject:self.profitByDate[date]];
//        [self.busynessArray addObject:self.busynessByDate[date]];
    }
    
//    NSLog(@"Date list: %@", dateList);
    
//    //--********* TEST FOR PROFIT TRENDS **************//
//    self.profitByDateTest = [[NSMutableDictionary alloc] init];
//    self.busynessByDateTest = [[NSMutableDictionary alloc] init];
//    NSString *dateString = @"";
//    int year = 2019;
//    int month = 1;
//    int day = 1;
//    float daysProfit = 0;
//    int daysBusyness = 0;
//    for (int i = 0; i < 384; i++) {
//        if (day >= 31) {
//            if (month >= 12) {
//                year++;
//                month = 1;
//            } else {
//                month++;
//            }
//            day = 1;
//        } else {
//            day++;
//        }
//        NSString *monthString = [NSString stringWithFormat:@"%d", month];
//        if ([monthString length] == 1) {
//            monthString = [@"0" stringByAppendingString:monthString];
//        }
//        NSString *dayString = [NSString stringWithFormat:@"%d", day];
//        if ([dayString length] == 1) {
//            dayString = [@"0" stringByAppendingString:dayString];
//        }
//        dateString = [NSString stringWithFormat:@"%d-%@-%@", year, monthString, dayString];
//        daysBusyness = roundf(daysProfit / 5.0);
//        daysProfit = 400 / day;
//
//        [self.profitByDateTest setObject:@(daysProfit) forKey:dateString];
//        [self.busynessByDateTest setObject:@(daysBusyness) forKey:dateString];
//
//    }
//    NSLog(@"Test profit dict: %@", self.profitByDateTest);
}

- (void)setTestProfitAndBusynessDicts
{
    //--********* TEST FOR PROFIT TRENDS **************//
    self.profitByDateTest = [[NSMutableDictionary alloc] init];
    self.busynessByDateTest = [[NSMutableDictionary alloc] init];
    NSString *dateString = @"";
    int year = 2019;
    int month = 1;
    int day = 1;
    float daysProfit = 0;
    int daysBusyness = 0;
    for (int i = 0; i < 384; i++) {
        if (day >= 31) {
            if (month >= 12) {
                year++;
                month = 1;
            } else {
                month++;
            }
            day = 1;
        } else {
            day++;
        }
        NSString *monthString = [NSString stringWithFormat:@"%d", month];
        if ([monthString length] == 1) {
            monthString = [@"0" stringByAppendingString:monthString];
        }
        NSString *dayString = [NSString stringWithFormat:@"%d", day];
        if ([dayString length] == 1) {
            dayString = [@"0" stringByAppendingString:dayString];
        }
        dateString = [NSString stringWithFormat:@"%d-%@-%@", year, monthString, dayString];
        daysBusyness = 1000 / (day + 5);//roundf(daysProfit / 5.0);
        daysProfit = roundf(((sinf(day) + 1.5) * day) * 1000) / 100;
        
        [self.profitByDateTest setObject:@(daysProfit) forKey:dateString];
        [self.busynessByDateTest setObject:@(daysBusyness) forKey:dateString];
    }
}

- (void)setBusynessByDate
{
    self.busynessByDate = [[NSMutableDictionary alloc] init];
    for (id date in self.closedOrdersByDate)
    {
        // loop through closed orders by day add number of customers to value for each date
        int numCustomers = 0;
        for (ClosedOrder *anOrder in self.closedOrdersByDate[date])
        {
            // find  order total
            int orderTotal = 0;
            NSLog(@"Order: %@", anOrder);
            for(int i = 0; i < anOrder.amounts.count; i++){
                orderTotal += [anOrder.numCustomers intValue];
            }
            numCustomers += orderTotal;
        }
        [self.busynessByDate setValue:@(numCustomers) forKey:date];
    }
    NSLog(@"Busyness by date:%@", self.busynessByDate);
    
    NSMutableArray *dateList = [NSMutableArray array];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1]; // used to increment day by 1 each iteration of while loop below
    //create start date
    NSDateComponents *startComps = [[NSDateComponents alloc] init];
    [startComps setDay:1];
    [startComps setMonth:7];
    [startComps setYear:2018];
    NSDate *startDate = [[NSCalendar currentCalendar] dateFromComponents:startComps];
    // create endDate
    NSDateComponents *endComps = [[NSDateComponents alloc] init];
    [endComps setDay:1];
    [endComps setMonth:8];
    [endComps setYear:2019];
    NSDate *endDate = [[NSCalendar currentCalendar] dateFromComponents:endComps];
    
    [dateList addObject:startDate];
    NSDate *currentDate = startDate;
    currentDate = [currentCalendar dateByAddingComponents:comps toDate:currentDate options:0];
    while ([endDate compare:currentDate] != NSOrderedAscending) {
        [dateList addObject:currentDate];
        currentDate = [currentCalendar dateByAddingComponents:comps toDate:currentDate options:0];
    }
    
    NSString *dayString;
    BOOL preceedsData = YES;
    for (NSDate *date in dateList) {
        //make sure key and date are
        dayString = [date dateFromNSDate];
        if ([self.busynessByDate objectForKey:dayString] == nil && preceedsData) {
            [self.busynessByDate setValue:@(-1) forKey:dayString]; // points before any data will have value -1
        } else if ([self.busynessByDate objectForKey:dayString] == nil && !preceedsData){
            [self.busynessByDate setValue:@(-2) forKey:dayString]; // points with no data after points with data will have value -2
        } else {
            preceedsData = NO;
        }
        //        NSLog(@"Day: %@, with profit: %@", dayString, self.profitByDate[dayString]);
    }
    
    
    
}

- (Dish *)getDishWithName:(NSString *)name
{
    NSArray<Dish*>*dishArray = [[NSArray alloc] init];
    
    dishArray = [[MenuManager shared] dishes];
//    for (int i = 0; i < self.closedOrders.count; i++){
    for (int j = 0; j < dishArray.count; j++)
    {
        Dish *dish = (Dish *)dishArray[j];
        if ([dish.name isEqualToString:name]){
            return dish;
        }
    }
    NSLog(@"No dish was found with name: %@", name);
    return nil;
}
//
//- (void)dict:(NSMutableDictionary *)dict toSortedArraysArr1:(NSMutableArray *)arr1 andArr2:(NSMutableArray *)arr2
//{
//    // *******Method Causes Crash currently *********//
//
//
////    arr1 = [[NSArray alloc] init];
////    arr2 = [[NSArray alloc] init];
//    NSArray *unsortedArr1 = [dict allKeys];
//    arr1 = [[unsortedArr1 sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
//    for(NSString *key in arr1){
//        [arr2 addObject:dict[key]];
////        NSLog(@"%@, %@", key, dict[key]);
//    }
//    NSLog(@"Array of Keys: %@", arr1);
//    NSLog(@"Array of Values: %@", arr2);
//}

//- (void)setArraysWithDict:(NSMutableDictionary *)dict
//{
//    NSArray *unsortedArr1 = [dict allKeys];
//    self. = [unsortedArr1 sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
//    for(NSString *key in arr1){
//        [arr2 arrayByAddingObject:dict[key]];
//        NSLog(@"%@, %@", key, dict[key]);
//    }
//}

//- (void) fetchOrdersToClose : (PFUser * ) restaurant withTable : (NSNumber *) table forWaiter : (Waiter *) waiter withCompletion : (void (^)(NSArray *orders, NSError * error))completion
//{
//
//    PFQuery *orderQuery;
//    orderQuery = [OpenOrder query];
//    [orderQuery whereKey:@"restaurantId" equalTo:restaurant.objectId];
//    //[orderQuery includeKey:@"dish"];
//    //    [orderQuery whereKey:@"table" equalTo:table];
//    [orderQuery findObjectsInBackgroundWithBlock:^(NSArray *_Nullable orders, NSError * _Nullable error) {
//        if (orders)
//        {
//            self.ordersToDelete = orders;
//
//            completion(orders, nil);
//
//        }
//        else
//        {
//            NSLog(@"Error: %@", error.localizedDescription);
//            completion(nil, error);
//        }
//    }];
//
//}
- (void) fetchDishInOrdersToClose : (OpenOrder *) temp withCompletion : (void (^)(NSArray * dishes, NSError * error))completion
{
    PFQuery *dishQuery;
    dishQuery = [Dish query];
    [dishQuery whereKey:@"objectId" equalTo:temp.dish.objectId];
    [dishQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error)
        {
            completion(objects, nil);
        }
        else
        {
            NSLog(@"Error: %@", error.localizedDescription);
            completion(nil, error);
        }
    }];
    completion(nil, nil);

}
- (void) postAllOpenOrders : (NSArray *) openOrders withCompletion : (void (^)(NSError * error))completion
{
    __block int doneWithArray = 0;
    for (OpenOrder *order in openOrders)
    {
        [OpenOrder postNewOrder:order withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (!error)
            {
                NSLog(@"Individual order posted");
                doneWithArray = doneWithArray + 1;
                if (doneWithArray >= openOrders.count){
                    completion(nil);
                }
            }
            else
            {
                NSLog(@"Error: %@", error.localizedDescription);
                completion(error);
            }
            
        }];
    }
    if (doneWithArray >= openOrders.count){
        completion(nil);
    }
}

-(void)closeOpenOrdersArray:(NSArray <OpenOrder *>*)ordersToClose withDishArray:(NSArray <NSString *>*)dishNames withAmounts:(NSArray*)amounts withCompletion : (void (^)(NSError * error))completion{
    if (ordersToClose.count > 0){
        ClosedOrder *newAddition = [ClosedOrder new];
        newAddition.customerLevel = ordersToClose[0].customerLevel;
        newAddition.restaurantId = ordersToClose[0].restaurantId;;
        newAddition.table = ordersToClose[0].table;
        newAddition.numCustomers = ordersToClose[0].customerNum;
        newAddition.waiter = ordersToClose[0].waiter;
        newAddition.dishes = [[NSArray alloc] init];
        newAddition.amounts = [[NSArray alloc] init];
        newAddition.dishes = dishNames;
        newAddition.amounts = amounts;
        newAddition.restaurant = PFUser.currentUser;
        [newAddition saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error){
                NSLog(@"%@", error.localizedDescription);
                completion(error);
            }
        }];
        PFUser.currentUser[@"totalTableTops"] = [NSNumber numberWithFloat: ([(NSNumber*)PFUser.currentUser[@"totalTableTops"] floatValue] + 1)];
        PFUser.currentUser[@"totalCustomers"] = [NSNumber numberWithFloat: ([(NSNumber*)PFUser.currentUser[@"totalCustomers"] floatValue] + [ordersToClose[0].customerNum floatValue])];
        [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(error){
                NSLog(@"Error saving updates: %@", error.localizedDescription);
            }
        }];
        for (int i = 0; i < ordersToClose.count; i++){
            [ordersToClose[i] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (error){
                    NSLog(@"%@", error.localizedDescription);
                    completion(error);
                }
            }];
        }
        NSLog(@"Updated closed orders");
        completion(nil);
    }
    
    completion(nil);
}

- (void) deletingOrderswithTable : (NSNumber *) table forWaiter : (Waiter *) waiter withCustomerNum : (NSNumber *) customerNum withCompletion : (void (^)(NSError * error))completion
{
    ClosedOrder *newAddition = [ClosedOrder new];
    newAddition.restaurant = PFUser.currentUser;
    newAddition.table = table;
    newAddition.numCustomers = customerNum;
    newAddition.waiter = waiter;

    __block int doneWithArray = 0;
    __block NSString *dishName;
    __block NSNumber *dishAmount;

    NSArray *ordersToClose = self.openOrdersByTable[[table stringValue]];
    for (int i = 0; i < [ordersToClose count]; i++)
    {
        OpenOrder *temp = ordersToClose[i];
        [self fetchDishInOrdersToClose:temp withCompletion:^(NSArray *dishes, NSError *error) {
            if (dishes)
            {
                Dish * tempDish = dishes[0];
                dishName = tempDish.name;
                dishAmount = temp.amount;
                [ordersToClose[i] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded)
                    {
                        NSLog(@"Order removed");
                        [newAddition addObject:dishName forKey:@"dishes"];
                        [newAddition addObject:dishAmount forKey:@"amounts"];
                        doneWithArray++;
                        if (doneWithArray >= [ordersToClose count])
                        {
                            [newAddition saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                NSLog(@"executing something?");
                                if (!error)
                                {
                                    NSLog(@"Closed order saved");
                                    [self fetchOpenOrderItems:PFUser.currentUser
                                               withCompletion:^(NSArray * _Nonnull openOrders, NSError * _Nonnull error) {
                                        if (succeeded)
                                        {
                                            NSLog(@"Updated open orders");
                                            [self fetchClosedOrderItems:PFUser.currentUser withCompletion:^(NSArray * _Nonnull closedOrders, NSError * _Nonnull error) {
                                                if (!error)
                                                {
                                                    self.closedOrders = closedOrders;
                                                    NSLog(@"Updated closed orders");
                                                    completion(nil);
                                                }
                                                else
                                                {
                                                    completion(error);
                                                }
                                            }];
                                        }
                                        else
                                        {
                                            completion(error);
                                        }
                                    }];
                                }
                                else
                                {
                                    completion(error);
                                }
                            }];
                        }
                    }
                    else
                    {
                        NSLog(@"Error: %@", error.localizedDescription);
                        completion(error);
                    }
                }];
            }
        }];
    }
    completion(nil);
}

-(void)changeOpenOrders:(NSArray <OpenOrder *>*)oldArray withEditedArray:(nullable NSMutableArray <OpenOrder *>*)editedArray withCompletion : (void (^)(NSError * error))completion{
    __block int doneWithLoops = 0;
    __block int tally = oldArray.count;
    if (editedArray){
        tally += (int)editedArray.count;
        for (int i = 0; i < editedArray.count; i++){
            [editedArray[i] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (error){
                    NSLog(@"%@", error.localizedDescription);
                    completion(error);
                }
                else {
                    doneWithLoops = doneWithLoops + 1;
                    if (doneWithLoops >= tally){
                        completion(nil);
                    }
                }
            }];
        }
    }
    for (int i = 0; i < oldArray.count; i++){
        if (!([editedArray containsObject:oldArray[i]])){
            [oldArray[i] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (error){
                    NSLog(@"Error deleting old order");
                    completion(error);
                } else {
                    doneWithLoops = doneWithLoops + 1;
                    if (doneWithLoops >= tally){
                        completion(nil);
                    }
                }
            }];
        } else {
            doneWithLoops = doneWithLoops + 1;
        }
    }
    
    if (doneWithLoops >= tally){
        completion(nil);
    }
}
@end
