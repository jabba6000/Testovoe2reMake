//
//  DishCardViewController.m
//  TestovoeRestaurant
//
//  Created by Uri Fuholichev on 10/8/16.
//  Copyright © 2016 Andrei Karpenia. All rights reserved.
//

#import "DishCardViewController.h"
#import "DataCollector.h"

@interface DishCardViewController()

@property (strong, nonatomic) IBOutlet UIImageView *dishImageView;
@property (strong, nonatomic) IBOutlet UILabel *dishName;
@property (strong, nonatomic) IBOutlet UILabel *dishWeight;
@property (strong, nonatomic) IBOutlet UILabel *dishPrice;
@property (strong, nonatomic) IBOutlet UILabel *dishDescription;

@end

@implementation DishCardViewController

- (void) viewDidLoad {
    _dishName.text = [_dish objectForKey:@"name"];
    _dishWeight.text = [NSString stringWithFormat:@"Вес: %@", [_dish objectForKey:@"weight"]];
    _dishPrice.text = [NSString stringWithFormat:@"Цена: %@",[_dish objectForKey:@"price"]];
   
    if ([[_dish objectForKey:@"description"] isEqual:@""])
        _dishDescription.text = @"Описание отсутствует";
    else
        _dishDescription.text = [NSString stringWithFormat:@"Описание: %@",[_dish objectForKey:@"description"] ];
    
    if( ![[[DataCollector sharedInstance].dishesImagesDictionary objectForKey:[_dish objectForKey:@"name"]] isEqual:@"none"]) {
        // If we already have iamge to show, it will be intalled in DishCard
        _dishImageView.image = [[DataCollector sharedInstance].dishesImagesDictionary objectForKey:[_dish objectForKey:@"name"]];
    }
    else if ([[_dish objectForKey:@"picture"] isEqual:@""]){
        _dishImageView.image = [UIImage imageNamed:@"na.jpg"];
        }
    else{
        // If don't have image for dish we should perform it's dowload
        _dishImageView.image = [UIImage imageNamed:@"logo.png"];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^(void) {
            // Again, not to freeze UI, we perform download of image asynchronously
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[_dish objectForKey:@"picture"]]];
            UIImage* image = [[UIImage alloc] initWithData:imageData];
            if (image){
                // When it "arrives", we install image on the card on main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[DataCollector sharedInstance].dishesImagesDictionary setObject:image forKey:[_dish objectForKey:@"name"]];
                    _dishImageView.image = [[DataCollector sharedInstance].dishesImagesDictionary objectForKey:[_dish objectForKey:@"name"]];
                });
            }
        });
    }
}

@end
