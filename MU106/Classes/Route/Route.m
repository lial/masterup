//
//  Route.m
//  MU106
//
//  Created by Alex Lifantyev on 30.10.13.
//  Copyright (c) 2013 Instup.com. All rights reserved.
//

#import "Route.h"

@implementation Route

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.routeId = [dictionary objectForKey:@"route_id"];
        self.title = [dictionary objectForKey:@"route_title"];
        self.routeDescription = [dictionary objectForKey:@"route_description"];
        self.price = [dictionary objectForKey:@"route_price"];
        self.path = [dictionary objectForKey:@"route_path"];
        self.ownerId = [dictionary objectForKey:@"owner_id"];
        self.isStarred = NO;
    }
    return self;
}

@end
