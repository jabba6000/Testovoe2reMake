//
//  DefineID.m
//  TestovoeRestaurant
//
//  Created by Uri Fuholichev on 10/8/16.
//  Copyright © 2016 Andrei Karpenia. All rights reserved.
//

#import "DefineID.h"

@implementation DefineID

//    This class converts name of category to category id

/*
 <category id="23">Добавки</category>
 <category id="10">Десерты</category>
 <category id="9">Напитки</category>
 <category id="25">Патимейкер</category>
 <category id="3">Лапша</category>
 <category id="1">Пицца</category>
 <category id="2">Сеты</category>
 <category id="18">Роллы</category>
 <category id="5">Суши</category>
 <category id="6">Супы</category>
 <category id="7">Салаты</category>
 <category id="8">Теплое</category>
 <category id="20">Закуски</category>
 */

-(NSString *)getIDFromCategoryName: (NSString *)name{
    if([name isEqualToString:@"Добавки"])
        return @"23";
    if([name isEqualToString:@"Десерты"])
        return @"10";
    if([name isEqualToString:@"Напитки"])
        return @"9";
    if([name isEqualToString:@"Патимейкер"])
        return @"25";
    if([name isEqualToString:@"Лапша"])
        return @"3";
    if([name isEqualToString:@"Пицца"])
        return @"1";
    if([name isEqualToString:@"Сеты"])
        return @"2";
    if([name isEqualToString:@"Роллы"])
        return @"18";
    if([name isEqualToString:@"Суши"])
        return @"5";
    if([name isEqualToString:@"Супы"])
        return @"6";
    if([name isEqualToString:@"Салаты"])
        return @"7";
    if([name isEqualToString:@"Теплое"])
        return @"8";
    if([name isEqualToString:@"Закуски"])
        return @"20";
    else
        return nil;
}

@end
