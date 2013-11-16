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
#define kSettingsFilename @"settings.plist"
#define kSettingsStoreFile @"routes.sqlite"

@interface ApiRouteClient()
    
@end

@implementation ApiRouteClient

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

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
    if([self managedObjectContext]){
        NSLog(@"managedObjectContext created");
    }

    return self;
}

- (void)updateRoutesListWithSuccess:(void(^)(void))success andFail:(void(^)(NSError *error))failure
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [self getPath:@"routes.php"
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSArray *routes = (NSArray *)responseObject;
              
              //Parse response data to array of objects
              NSEnumerator *enumerator = [routes objectEnumerator];
              id obj;
              
              NSEntityDescription *entity = [NSEntityDescription entityForName:@"Route" inManagedObjectContext:self.managedObjectContext];
              
              while ((obj = [enumerator nextObject]))
              {
                  Route *route = [[Route alloc] initWithEntity:entity andDictionary:(NSDictionary *)obj insertIntoManagedObjectContext:self.managedObjectContext];
              }
              
// Result array sorting is rest as an example
//              NSArray *result = [arrayTemp sortedArrayUsingComparator:^NSComparisonResult(Route *route1, Route *route2) {
//                  if (route1.isStarred == YES)
//                      return NSOrderedAscending;
//                  else if (route2.isStarred == YES)
//                      return NSOrderedDescending;
//                  else
//                      return NSOrderedSame;
//              }];
              
              [self saveContext];
              
              //Save last syncronization DateTime with server
              NSDictionary *dict = @{@"lastUpdatedDateTime": [NSDate date]};
              
              if ([dict writeToFile:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:kSettingsFilename] atomically:YES]) {
                  NSLog(@"Success write of settings.plist");
              } else {
                  NSLog(@"Error writing of settings.bplist");
              }
              
              success();
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failure(error);
          }
     ];
    });
    
}

- (BOOL)isNeedUpdateRoutes {
    
    //TODO: Need to check is route's list lates or not
    //Now will check existence of sqlite file
    BOOL result = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:kSettingsFilename]]) {
        result = YES;
    }

    return result;
}

- (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

#pragma mark - Core Data

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    self.hasChangesInManagedContext = NO;
    
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Routes" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [NSURL fileURLWithPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:kSettingsStoreFile]];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];

    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"ApiRouteClient:persistentSotoreCoordinator - Error adding persistentStoreCoordinator %@, %@", error, [error userInfo]);
    }
    
    return _persistentStoreCoordinator;
}

- (BOOL)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"ApiRouteClient:saveContext - Error %@, %@", error, [error userInfo]);
            return NO;
        } else {
            self.hasChangesInManagedContext = NO;
            return YES;
        }
    } else {
        return NO;
    }
}

@end