//
//  RoutePoint.h
//  MU106
//
//  Created by Alex Lifantyev on 24.11.13.
//  Copyright (c) 2013 Instup.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoutePoint : NSObject

@property (retain, nonatomic) NSNumber *unitId;
@property (retain, nonatomic) NSNumber *unitNumber;
@property (retain, nonatomic) NSNumber *x1;
@property (retain, nonatomic) NSNumber *y1;
@property (retain, nonatomic) NSNumber *x2;
@property (retain, nonatomic) NSNumber *y2;
@property (retain, nonatomic) NSNumber *angle;
@property (retain, nonatomic) NSNumber *unitSpeed;
@property (retain, nonatomic) NSString *unitTitle;
@property (retain, nonatomic) NSNumber *routeId;
@property (retain, nonatomic) NSString *routeTitle;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
