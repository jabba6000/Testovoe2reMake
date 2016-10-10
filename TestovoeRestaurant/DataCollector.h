//
//  DataCollector.h
//  TestovoeRestaurant
//
//  Created by Uri Fuholichev on 10/8/16.
//  Copyright © 2016 Andrei Karpenia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCollector : NSObject

// This singleton object will be used to collect all data, store it during the current app session and simplify transaction of data betveen ViewControllers

// Array will contain only names of categories
@property (strong, nonatomic) NSArray *categoryNamesArray;
// Array for images of categories
@property (strong, nonatomic) NSArray *categoryImagesArray;
// Array that have dictionaries with all data we need
@property (strong, nonatomic) NSArray *allDishesArray;
// Dictionary will store images of every dish
@property (strong, nonatomic) NSMutableDictionary *dishesImagesDictionary;

+(DataCollector *)sharedInstance;

@end
