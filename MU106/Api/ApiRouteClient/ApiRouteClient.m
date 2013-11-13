//
//  ApiRouteClient.m
//  MU106
//
//  Created by Alex Lifantyev on 06.11.13.
//  Copyright (c) 2013 Instup.com. All rights reserved.
//

#import "ApiRouteClient.h"
#import "AFNetworking.h"
#import "Classes.h"

#define kApiBaseUrl @"http://itomy.ch/"

@implementation ApiRouteClient

+ (id)sharedInstance
{
    static ApiRouteClient *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[ApiRouteClient alloc] initWithBaseURL:[NSURL URLWithString:kApiBaseUrl]];
    });
    
    return __sharedInstance;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    } else {
        self = nil;
    }
    
    return self;
}

- (void)updateRoutesListWithSuccess:(void(^)(NSArray *routes))success andFail:(void(^)(NSError *error))failure
{
    [self getPath:@"routes.php"
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSMutableArray *arrayTemp = [[NSMutableArray alloc] init];
              NSArray *routes = (NSArray *)responseObject;
              
              //Parse response data to array of objects
              NSEnumerator *enumerator = [routes objectEnumerator];
              id obj;
              while ((obj = [enumerator nextObject]))
              {
                  Route *route = [[Route alloc] initWithDictionary:(NSDictionary *)obj];
                  [arrayTemp addObject:route];
              }
              
              //Result array sorting
              NSArray *result = [arrayTemp sortedArrayUsingComparator:^NSComparisonResult(Route *route1, Route *route2) {
                  if (route1.isStarred == YES)
                      return NSOrderedAscending;
                  else if (route2.isStarred == YES)
                      return NSOrderedDescending;
                  else
                      return NSOrderedSame;
              }];
              
              success((NSArray *)result);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failure(error);
          }
     ];
    
}

@end