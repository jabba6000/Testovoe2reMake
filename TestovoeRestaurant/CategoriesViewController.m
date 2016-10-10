//
//  CategoriesViewController.m
//  TestovoeRestaurant
//
//  Created by Uri Fuholichev on 10/8/16.
//  Copyright © 2016 Andrei Karpenia. All rights reserved.
//

#import "CategoriesViewController.h"
#import "SWRevealViewController.h"
#import "DataCollector.h"
#import "DishesViewController.h"
#import "DefineID.h"

@interface CategoriesViewController() <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *categoriesTableView;
@property (strong, nonatomic) DishesViewController *dishesVC;
@property (strong, nonatomic) NSMutableArray  *arrayToPass;

@end

@implementation CategoriesViewController

- (void)viewDidLoad {
    // Array to pass data to the next VC
    _arrayToPass = [NSMutableArray new];
    // Next lines of code are to connect with side menue controller
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController ){
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    self.categoriesTableView.delegate = self;
    self.categoriesTableView.dataSource = self;
    NSLog(@"LOADED!");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[DataCollector sharedInstance].categoryImagesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = [[DataCollector sharedInstance].categoryNamesArray objectAtIndex:indexPath.row] ;
    cell.imageView.image = [[DataCollector sharedInstance].categoryImagesArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // When we touch a cell in tableView we will be pushed to the next screen
    NSString *selectedCategoryName = [NSString stringWithString:[[DataCollector sharedInstance].categoryNamesArray  objectAtIndex:indexPath.row]];
    DefineID *definitor = [DefineID new];
    NSString *selectedCategoryID = [definitor getIDFromCategoryName:selectedCategoryName];
    //here will be the code to extract of dishes of current category (based on ID) and pass it to next VC
    self.dishesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Dishes"];
    [_arrayToPass removeAllObjects];
    // Array will contain all offers of selected category
    for (NSMutableDictionary *dict in [DataCollector sharedInstance].allDishesArray){
        if ([[dict objectForKey:@"categoryId"] isEqualToString:selectedCategoryID]){
            [_arrayToPass addObject:dict];
        }
    }
    self.dishesVC.categoryDishes = _arrayToPass;
    // To pass the data between these two view  controllers, we use DishesVC's property "categoryDishes"
    [self.navigationController pushViewController:self.dishesVC animated:YES];
}

@end
