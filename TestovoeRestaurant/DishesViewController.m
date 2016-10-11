//
//  DishesViewController.m
//  TestovoeRestaurant
//
//  Created by Uri Fuholichev on 10/8/16.
//  Copyright © 2016 Andrei Karpenia. All rights reserved.
//

#import "DishesViewController.h"
#import "DataCollector.h"
#import "DishCardViewController.h"

@interface DishesViewController() <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *dishesTableView;
@property (strong, nonatomic) DishCardViewController *dishCardVC;
@property (strong, nonatomic) NSMutableDictionary *dictionaryToPass;

@end

@implementation DishesViewController

- (void) viewDidLoad {
    self.dishesTableView.delegate = self;
    self.dishesTableView.dataSource= self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.categoryDishes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.tag = indexPath.row;
    UIImage *naImage = [UIImage imageNamed:@"na.jpg"];
    NSString *currentDishName = [[_categoryDishes objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    if (  [[[DataCollector sharedInstance].dishesImagesDictionary objectForKey:currentDishName] isEqual:@"none"]){
        cell.imageView.image = naImage;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^(void) {
            // Download of image will be performed asynchronously, UI won't be frozen
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.categoryDishes objectAtIndex:indexPath.row] objectForKey:@"picture"]]];
            
            UIImage* image = [[UIImage alloc] initWithData:imageData];
            if (image) {
                //When image will "arrive" UI will be updated
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (cell.tag == indexPath.row) {
                        [[DataCollector sharedInstance].dishesImagesDictionary removeObjectForKey:currentDishName];
                        [[DataCollector sharedInstance].dishesImagesDictionary setObject:image forKey:currentDishName];
                        
                        NSMutableDictionary *temporaryDictionaryWithImages = [NSMutableDictionary new];
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        temporaryDictionaryWithImages = [[defaults objectForKey:@"ImagesOfDishesDictionary"] mutableCopy];
                        [defaults removeObjectForKey:@"ImagesOfDishesDictionary"];
                        [temporaryDictionaryWithImages removeObjectForKey:@"dishImage"];
                        NSData *imageData = UIImagePNGRepresentation(image);
                        [temporaryDictionaryWithImages setObject:imageData forKey:currentDishName];
                        [defaults setObject:temporaryDictionaryWithImages forKey:@"ImagesOfDishesDictionary"];
                        NSLog(@"Data was added to User Defaults");
//
                        
                        
                        NSLog(@"Img downloaded");
                        cell.imageView.image = image;
                        [cell setNeedsLayout];
                    }
                });
            }
        });
        cell.textLabel.text = [[self.categoryDishes objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Вес: %@ Цена %@", [[self.categoryDishes objectAtIndex:indexPath.row] objectForKey:@"weight"], [[self.categoryDishes objectAtIndex:indexPath.row] objectForKey:@"price"]];
        
    }
    else if (![[[DataCollector sharedInstance].dishesImagesDictionary objectForKey:currentDishName ] isEqual:@"none"] ) {
        cell.imageView.image = [[DataCollector sharedInstance].dishesImagesDictionary objectForKey:currentDishName];
        cell.textLabel.text = [[self.categoryDishes objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Вес: %@ Цена %@", [[self.categoryDishes objectAtIndex:indexPath.row] objectForKey:@"weight"], [[self.categoryDishes objectAtIndex:indexPath.row] objectForKey:@"price"]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Here we pass selected dish's data to the next VC
    NSString *selectedDishName = [[self.categoryDishes objectAtIndex:indexPath.row] objectForKey:@"name"];
    self.dishCardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DishCard"];
    _dictionaryToPass = [NSMutableDictionary new];
    for (NSMutableDictionary *dict in [DataCollector sharedInstance].allDishesArray){
        if ([[dict objectForKey:@"name"] isEqualToString:selectedDishName]){
            _dictionaryToPass = dict;
        }
    }
    self.dishCardVC.dish = _dictionaryToPass;
    [self.navigationController pushViewController:self.dishCardVC animated:YES];
}

@end
