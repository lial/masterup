//
//  RoutePoint.m
//  MU106
//
//  Created by Alex Lifantyev on 24.11.13.
//  Copyright (c) 2013 Instup.com. All rights reserved.
//

#import "RoutePoint.h"

@implementation RoutePoint

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self =[super init]) {
        self.unitId = [NSNumber numberWithInt:[[dictionary objectForKey:@"unit_id"] intValue]];
        self.unitNumber = [NSNumber numberWithInt:[[dictionary objectForKey:@"unit_nm"] intValue]];
        self.x1 = [NSNumber numberWithFloat:[[dictionary objectForKey:@"unit_x1"] floatValue]];
        self.y1 = [NSNumber numberWithFloat:[[dictionary objectForKey:@"unit_y1"] floatValue]];
        self.x2 = [NSNumber numberWithFloat:[[dictionary objectForKey:@"unit_x2"] floatValue]];
        self.y2 = [NSNumber numberWithFloat:[[dictionary objectForKey:@"unit_y2"] floatValue]];
        self.angle = [NSNumber numberWithInt:[[dictionary objectForKey:@"unit_angle"] intValue]];
        self.unitSpeed = [NSNumber numberWithInt:[[dictionary objectForKey:@"unit_speed"] intValue]];
        self.unitTitle = [dictionary objectForKey:@"unit_title"];
        self.routeId = [NSNumber numberWithInt:[[dictionary objectForKey:@"route_id"] intValue]];
        self.routeTitle = [dictionary objectForKey:@"route_title"];
    }
    
    return  self;
}

@end
