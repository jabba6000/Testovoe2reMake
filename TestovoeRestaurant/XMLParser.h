//
//  XMLParser.h
//  TestovoeRestaurant
//
//  Created by Uri Fuholichev on 10/8/16.
//  Copyright © 2016 Andrei Karpenia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLParser : NSObject <NSXMLParserDelegate>

- (void)performParsing;

@end
