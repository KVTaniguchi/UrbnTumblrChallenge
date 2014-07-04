//
//  KTPostStore.m
//  UrbnTumblrChallenge
//
//  Created by Kevin Taniguchi on 7/2/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import "KTPostStore.h"

@implementation KTPostStore

+(KTPostStore*)sharedStore{
    static KTPostStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil]init];
    }
    return sharedStore;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedStore];
}

-(id)init{
    self = [super init];
    if (self) {
        allPosts = [NSMutableArray new];
//        model = [NSManagedObjectModel mergedModelFromBundles:nil];
//        NSURL *documentsDirectory = [[[NSFileManager defaultManager]URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject];
//        NSURL *storeURL = [documentsDirectory URLByAppendingPathComponent:@"CoreData.sqlite"];
//        NSError *error = nil;
//        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
//        NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES, @"TaniguchiTumblr": NSPersistentStoreUbiquitousContentNameKey};
//        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
//            [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
//        }
//        self.context =[NSManagedObjectContext new];
//        [self.context setPersistentStoreCoordinator:psc];
//        [self.context setUndoManager:nil];
    }
    return self;
}

-(NSArray*)allPosts{
    return allPosts;
}

-(NSArray*)setPosts:(id)post{
    [allPosts addObject:post];
    return allPosts;
}

-(Post*)addNewPost{
    Post *newPost = [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:self.context];
    return newPost;
}

-(void)clearAllPosts{
    [allPosts removeAllObjects];
}

-(BOOL)saveChanges{
    NSError *error = nil;
    BOOL success = [[KTPostStore sharedStore].context save:&error];
    if (!success) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return success;
}

-(NSArray*)fetchAllPostsForUser:(NSString *)user{
    NSFetchRequest *request = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Post" inManagedObjectContext:self.context];
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"userName = %@", user];
    [request setPredicate:userNamePredicate];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedPosts = [[KTPostStore sharedStore].context executeFetchRequest:request error:&error];
    return fetchedPosts;
}

@end
