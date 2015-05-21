//
//  Story.m
//  Wireframe
//
//  Created by Leo on 19/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "Story.h"


@implementation Story

+(JSONKeyMapper*)keyMapper{
    return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
}

+ (NSString *)NSDateToShowString:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yy"];
    return [formatter stringFromDate:date];
}

@end
