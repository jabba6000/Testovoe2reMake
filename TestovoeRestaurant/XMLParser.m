//
//  XMLParser.m
//  TestovoeRestaurant
//
//  Created by Uri Fuholichev on 10/8/16.
//  Copyright © 2016 Andrei Karpenia. All rights reserved.
//

#import "XMLParser.h"
#import "DataCollector.h"

@interface XMLParser()

// The xmlParser property is the one that we’ll use to parse the XML data.
@property (nonatomic, strong) NSXMLParser *xmlParser;
// Array that will contain all of the desired data after the parsing has finished.
@property (nonatomic, strong) NSMutableArray *allOffersDataArray;
// We’ll store values we seek inside dictionary (One dictionary for each offer).
@property (nonatomic, strong) NSMutableDictionary *offerDataDictionary;
// array For Categorie's Names
@property (nonatomic, strong) NSMutableArray *categoriesNamesArray;
// The foundValue mutable string will be used to store the found characters of the elements of interest.
@property (nonatomic, strong) NSMutableString *foundValue;
// The currentElement string will be assigned with the name of the element that is parsed at any moment.
@property (nonatomic, strong) NSString *currentElement;

@end

@implementation XMLParser

- (void)performParsing{
    _categoriesNamesArray = [NSMutableArray new];
    self.xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://ufa.farfor.ru/getyml/?key=ukAXxeJYZN"]];
    [self.xmlParser setDelegate: self];
    // Initialize the mutable string that we'll use during parsing.
    self.foundValue = [[NSMutableString alloc] init];
    [self.xmlParser parse];
}

#pragma mark - NSXMLParser Delegate methods

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    // Initialize the dictionary for images and array for offers.
    self.allOffersDataArray = [[NSMutableArray alloc] init];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"Total count of offers is %lu", (unsigned long)[self.allOffersDataArray count]);
    [DataCollector sharedInstance].categoryNamesArray = _categoriesNamesArray;
    NSLog(@"Now have all CATEGORIES names in DataCollector");
    // At the end we pass all data to Data Collector object's array.
    [DataCollector sharedInstance].allDishesArray = self.allOffersDataArray;
    NSLog(@"Now have all DISHES DATA in DataCollector");
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"%@", [parseError localizedDescription]);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName containsString:@"offer"]) {
        self.offerDataDictionary = [[NSMutableDictionary alloc] init];
    }
    if ([elementName containsString:@"param"]){
        if ([[attributeDict objectForKey:@"name"] isEqualToString: @"Вес"])
            self.currentElement = elementName;
    }
    if ([elementName containsString:@"category"]){
        if ([attributeDict objectForKey:@"id"])
            self.currentElement = elementName;
    }
    // Keep the current element.
    self.currentElement = elementName;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    //When we find "offer" string it means that we dealing with new dish object, need to collect it's fields data
    if ([elementName isEqualToString:@"offer"]) {
        [self.allOffersDataArray addObject:[[NSDictionary alloc] initWithDictionary:self.offerDataDictionary]];
    }
    if ([elementName isEqualToString:@"picture"]){
        // picture - it means only string with URL of image for each dish
        NSString *picture = [self.foundValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self.offerDataDictionary setObject:[NSString stringWithString:picture] forKey:@"picture"];
        [self.offerDataDictionary setObject:@"none" forKey:@"dishImage"];
    }
    if ([elementName isEqualToString:@"price"]){
        NSString *weight = [self.foundValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self.offerDataDictionary setObject:[NSString stringWithString:weight] forKey:@"price"];
    }
    if ([elementName isEqualToString:@"name"]){
        [self.offerDataDictionary setObject:[NSString stringWithString:self.foundValue] forKey:@"name"];
        //And here we add string to dictionary of DishesImagesm, it will be replaced with image object later
        [[DataCollector sharedInstance].dishesImagesDictionary setObject:@"none" forKey:[NSString stringWithFormat:@"%@", self.foundValue]];
    }
    if ([elementName isEqualToString:@"categoryId"]){
        NSString *countId = [self.foundValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self.offerDataDictionary setObject:countId forKey:@"categoryId"];
    }
    if ([elementName isEqualToString:@"description"]){
        NSString *weight = [self.foundValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self.offerDataDictionary setObject:[NSString stringWithString:weight] forKey:@"description"];
    }
    if ([elementName isEqualToString:@"param"]){
        if([self.foundValue containsString:@"гр"]){
            NSString *weight = [self.foundValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [self.offerDataDictionary setObject:[NSString stringWithString:weight] forKey:@"weight"];
        }
    }
    if ([elementName isEqualToString:@"category"]){
        NSString *categoryName = [self.foundValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self.categoriesNamesArray addObject:categoryName];
    }
    // Clear the mutable string.
    [self.foundValue setString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    // Store the found characters if only we're interested in the current element.
    if ([self.currentElement isEqualToString:@"name"] ||
        [self.currentElement isEqualToString:@"price"] ||
        [self.currentElement isEqualToString:@"categoryId"] ||
        [self.currentElement containsString:@"param"] ||
        [self.currentElement containsString:@"category"] ||
        [self.currentElement isEqualToString:@"picture"] ||
        [self.currentElement isEqualToString:@"description"]
        ) {
        if (![string isEqualToString:@"\n"]) {
            [self.foundValue appendString:string];
        }
    }
}
@end
