//
//  ApiRouteClient.h
//  MU106
//
//  Created by Alex Lifantyev on 06.11.13.
//  Copyright (c) 2013 Instup.com. All rights reserved.
//

#import "AFHTTPClient.h"

@interface ApiRouteClient : AFHTTPClient

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property BOOL hasChangesInManagedContext;

+ (id)sharedInstance;
- (id)initWithBaseURL:(NSURL *)url;
- (void)updateRoutesListWithSuccess:(void(^)(void))success andFail:(void(^)(NSError *error))failure;
- (BOOL)isNeedUpdateRoutes;
- (BOOL)saveContext;

@end