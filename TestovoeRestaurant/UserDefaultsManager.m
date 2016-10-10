//
//  UserDefaultsManager.m
//  TestovoeRestaurant
//
//  Created by Uri Fuholichev on 10/10/16.
//  Copyright © 2016 Andrei Karpenia. All rights reserved.
//

#import "UserDefaultsManager.h"
#import "DataCollector.h"
#import "ArrayOfCategoryImages.h"
#import "XMLParser.h"
#import "ReachabilityManager.h"

@implementation UserDefaultsManager

- (void)checkIfRequiredDataExists {
    ReachabilityManager *reachabilityManager = [ReachabilityManager new];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"AllDishesDataArray"]) {
        NSLog(@"App data exists");
        [DataCollector sharedInstance].allDishesArray = [defaults objectForKey:@"AllDishesDataArray"];
        [DataCollector sharedInstance].categoryNamesArray = [defaults objectForKey:@"NamesOfCategoriesArray"];
        [DataCollector sharedInstance].dishesImagesDictionary = [[defaults objectForKey:@"ImagesOfDishesDictionary"] mutableCopy];
        ArrayOfCategoryImages *imageArray = [ArrayOfCategoryImages new];
        [imageArray createArrayOfImages];
        if (![reachabilityManager checkConnection]) {
            NSLog(@"Conncetion is not avilable");
        }
    }
    else {
        if ([reachabilityManager checkConnection]) {
            NSLog(@"App data doesn't exists");
            //Here we start synchronous download of all offers data we need. UI will be frozen during the process
            XMLParser *parser = [XMLParser new];
            [parser performParsing];
            ArrayOfCategoryImages *imageArray = [ArrayOfCategoryImages new];
            [imageArray createArrayOfImages];
            NSLog(@"Now parsed data is inside Data Collcetor");
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[DataCollector sharedInstance].categoryNamesArray forKey:@"NamesOfCategoriesArray"];
            //We don't save category images to array, because it easy to get this data from project
            [defaults setObject:[DataCollector sharedInstance].allDishesArray forKey:@"AllDishesDataArray"];
            [defaults setObject:[DataCollector sharedInstance].dishesImagesDictionary forKey:@"ImagesOfDishesDictionary"];
            NSLog(@"Now parsed data is inside NSUserDefaults");
        }
        else {
            NSLog(@"Conncetion is not avilable");
        }
    }
}

@end
