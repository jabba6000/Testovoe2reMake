//
//  UserDefaultsManager.h
//  TestovoeRestaurant
//
//  Created by Uri Fuholichev on 10/10/16.
//  Copyright © 2016 Andrei Karpenia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UserDefaultsManager : NSObject

- (void)checkIfRequiredDataExists;
- (void)updateUserDefaultsWithImage: (UIImage *)img forName: (NSString*)name;

@end
