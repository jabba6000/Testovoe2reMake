//
//  DataCollector.m
//  TestovoeRestaurant
//
//  Created by Uri Fuholichev on 10/8/16.
//  Copyright © 2016 Andrei Karpenia. All rights reserved.
//

#import "DataCollector.h"

@implementation DataCollector

+ (DataCollector *)sharedInstance {
    static dispatch_once_t pred;
    static DataCollector *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end
