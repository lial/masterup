//
//  Route.m
//  MU106
//
//  Created by Alex Lifantyev on 30.10.13.
//  Copyright (c) 2013 Instup.com. All rights reserved.
//

#import "Route.h"

@implementation Route

@dynamic routeId;
@dynamic title;
@dynamic routeDescription;
@dynamic price;
@dynamic path;
@dynamic ownerId;
@dynamic isStarred;

- (id)initWithEntity:(NSEntityDescription *)entity andDictionary:(NSDictionary *)dictionary insertIntoManagedObjectContext:(NSManagedObjectContext *)context
{
    if (self = [super initWithEntity:entity insertIntoManagedObjectContext:context]) {
        self.routeId = [NSNumber numberWithInt:[[dictionary objectForKey:@"route_id"] intValue]];
        self.title = [dictionary objectForKey:@"route_title"];
        self.routeDescription = [dictionary objectForKey:@"route_description"];
        self.price = [NSNumber numberWithFloat:[[dictionary objectForKey:@"route_price"] floatValue]];
        self.path = [dictionary objectForKey:@"route_path"] ;
        self.ownerId = [NSNumber numberWithInt:[[dictionary objectForKey:@"owner_id"] integerValue]];
        self.isStarred = NO;
    }
    return self;
}

@end
