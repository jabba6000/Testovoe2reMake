//
//  ArrayOfCategoryImages.m
//  TestovoeRestaurant
//
//  Created by Uri Fuholichev on 10/8/16.
//  Copyright © 2016 Andrei Karpenia. All rights reserved.
//

#import "ArrayOfCategoryImages.h"
#import "DataCollector.h"

@implementation ArrayOfCategoryImages

- (void)createArrayOfImages {
    // Array of random pictures from http://www.iconbeast.com/
    NSArray *arrayWithImages = [[NSArray alloc] initWithObjects:
                                [UIImage imageNamed:@"airplane.png"],
                                [UIImage imageNamed:@"antique-vase.png"],
                                [UIImage imageNamed:@"basketball.png"],
                                [UIImage imageNamed:@"box-3d.png"],
                                [UIImage imageNamed:@"briefcase.png"],
                                [UIImage imageNamed:@"brightness.png"],
                                [UIImage imageNamed:@"cooking-utensil.png"],
                                [UIImage imageNamed:@"flower.png"],
                                [UIImage imageNamed:@"scale.png"],
                                [UIImage imageNamed:@"shopping-bag.png"],
                                [UIImage imageNamed:@"tic-tac-toe.png"],
                                [UIImage imageNamed:@"tree.png"],
                                [UIImage imageNamed:@"water.png"],
                                nil];
    [DataCollector sharedInstance].categoryImagesArray = arrayWithImages;
    NSLog(@"Now have all CATEGORIES images in DataCollector");
}

@end
