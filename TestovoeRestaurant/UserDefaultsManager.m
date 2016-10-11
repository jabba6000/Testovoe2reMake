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
        
        [DataCollector sharedInstance].dishesImagesDictionary = [self convertNSDataToUIImageDictionary];
        
        ArrayOfCategoryImages *imageArray = [ArrayOfCategoryImages new];
        [imageArray createArrayOfImages];
//        if (![reachabilityManager checkConnection]) {
//            NSLog(@"Conncetion is not avilable");
//        }
    }
    else {
        if ([reachabilityManager checkConnection]) {
            NSLog(@"App data doesn't exists");
            //Here we start synchronous download of all offers data we need. UI will be frozen during the process
            XMLParser *parser = [XMLParser new];
            [parser performParsing];
            ArrayOfCategoryImages *imageArray = [ArrayOfCategoryImages new];
            [imageArray createArrayOfImages];
            NSLog(@"Now parsed data is inside Data Collector");
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[DataCollector sharedInstance].categoryNamesArray forKey:@"NamesOfCategoriesArray"];
            //We don't save category images to array, because it rather easy to get this data from project
            [defaults setObject:[DataCollector sharedInstance].allDishesArray forKey:@"AllDishesDataArray"];
            [defaults setObject:[DataCollector sharedInstance].dishesImagesDictionary forKey:@"ImagesOfDishesDictionary"];
            NSLog(@"Now parsed data is inside NSUserDefaults");
        }
        else {
            NSLog(@"Conncetion is not available");
            if ([DataCollector sharedInstance].allDishesArray == nil)
            {
                NSLog(@"No data and no Internet connection");
            }
            else{
                [DataCollector sharedInstance].allDishesArray = [defaults objectForKey:@"AllDishesDataArray"];
                [DataCollector sharedInstance].categoryNamesArray = [defaults objectForKey:@"NamesOfCategoriesArray"];
                
                [DataCollector sharedInstance].dishesImagesDictionary = [self convertNSDataToUIImageDictionary];
                
                ArrayOfCategoryImages *imageArray = [ArrayOfCategoryImages new];
                [imageArray createArrayOfImages];
            }
        }
    }
}

- (NSMutableDictionary *)convertNSDataToUIImageDictionary {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dictWithImages  = [NSMutableDictionary new];
    NSDictionary *extractedImageData = [NSDictionary dictionaryWithDictionary:[defaults objectForKey:@"ImagesOfDishesDictionary"]];
    NSEnumerator *enumerator = [extractedImageData keyEnumerator];
    id key;
    while((key = [enumerator nextObject])) {
        if ([[extractedImageData objectForKey:key] isEqual:@"none"]){
            [dictWithImages setObject:[extractedImageData objectForKey:key] forKey:key];
            NSLog(@"%@", [dictWithImages objectForKey:key]);
        }
        else{
            UIImage *image = [UIImage imageWithData:[extractedImageData objectForKey:key]];
            [dictWithImages setObject:image forKey:key];
            NSLog(@"converted Image added to dictionary");
        }
    }
    return dictWithImages;
}

//Because it  is impossible to store UIImage inside USer Defaults we have to convert it to NSData
- (void)updateUserDefaultsWithImage: (UIImage *)img forName: (NSString*)name{
    NSMutableDictionary *temporaryDictionaryWithImages = [NSMutableDictionary new];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    temporaryDictionaryWithImages = [[defaults objectForKey:@"ImagesOfDishesDictionary"] mutableCopy];
    [defaults removeObjectForKey:@"ImagesOfDishesDictionary"];
    [temporaryDictionaryWithImages removeObjectForKey:@"dishImage"];
    NSData *imageData = UIImagePNGRepresentation(img);
    [temporaryDictionaryWithImages setObject:imageData forKey:name];
    [defaults setObject:temporaryDictionaryWithImages forKey:@"ImagesOfDishesDictionary"];
    NSLog(@"Downloaded data was added to User Defaults");
}


@end
