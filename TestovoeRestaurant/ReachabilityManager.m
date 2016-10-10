//
//  ReachabilityManager.m
//  Reachability
//
//  Created by Uri Fuholichev on 10/10/16.
//  Copyright © 2016 Andrei Karpenia. All rights reserved.
//

#import "ReachabilityManager.h"

@implementation ReachabilityManager

- (BOOL)checkConnection
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    NSLog(@"Connection is available");
    return networkStatus != NotReachable;
}

@end
