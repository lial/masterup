//
//  ApiRouteClient.h
//  MU106
//
//  Created by Alex Lifantyev on 06.11.13.
//  Copyright (c) 2013 Instup.com. All rights reserved.
//

#import "AFHTTPClient.h"

@interface ApiRouteClient : AFHTTPClient

+ (id)sharedInstance;
- (id)initWithBaseURL:(NSURL *)url;

- (void)updateRoutesListWithSuccess:(void(^)(NSArray *routes))success andFail:(void(^)(NSError *error))failure;

@end