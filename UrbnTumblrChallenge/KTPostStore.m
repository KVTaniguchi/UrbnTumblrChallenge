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
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
        NSString *path = [self itemArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        NSError *error = nil;
        NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
        if(![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]){
            [NSException raise:@"Open failed" format:@"Reason is %@", [error localizedDescription]];
        }
        self.context = [[NSManagedObjectContext alloc]init];
        [self.context setPersistentStoreCoordinator:psc];
        [self.context setUndoManager:nil];
    }
    return self;
}

-(NSString*)itemArchivePath{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = documentDirectories[0];
    return [documentDirectory stringByAppendingString:@"post.data"];
}

-(NSArray*)allPosts{
    return allPosts;
}

-(NSArray*)setPosts:(id)post withSequence:(NSInteger)sequence{
    [allPosts addObject:post];
    
    Post *p = [self addNewPost];
    
    if ([post objectForKey:@"caption"] != nil) {
        NSString *caption = [NSString stringWithString:[post objectForKey:@"caption"]];
       p.caption = caption;
    }
    if ([post objectForKey:@"body"] != nil) {
        NSString *body = [NSString stringWithString:[post objectForKey:@"body"]];
        p.body = body;
    }
    if ([post objectForKey:@"photos"] != nil) {
        NSArray *photoContainer = [post objectForKey:@"photos"];
        NSDictionary *photoInfo = [photoContainer objectAtIndex:0];
        NSArray *altSizes = [photoInfo objectForKey:@"alt_sizes"];
        NSDictionary *photo = [altSizes lastObject];
        NSURL *photoURL = [NSURL URLWithString:[photo objectForKey:@"url"]];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:photoURL]];
        p.image = UIImagePNGRepresentation(image);
    }
    if ([post objectForKey:@"slug"] != nil) {
        p.slug = [post objectForKey:@"slug"];
    }
    if ([post objectForKey:@"reblogged_from_name"] != nil) {
        NSString *reblogger = [post objectForKey:@"reblogged_from_name"];
        p.rebloggerName = reblogger;
    }
    if ([post objectForKey:@"blog_name"] != nil) {
        NSString *userName = [post objectForKey:@"blog_name"];
        p.userName = userName;
    }
    p.sequence = [NSNumber numberWithInteger:sequence];
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
    NSMutableArray *orderedPosts = [NSMutableArray arrayWithArray:fetchedPosts];
    NSSortDescriptor *sequenceSorter = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES];
    [orderedPosts sortUsingDescriptors:@[sequenceSorter]];
    return orderedPosts;
}

-(void)deleteAllPostsForUser:(NSString*)user{
    NSFetchRequest *request = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Post" inManagedObjectContext:self.context];
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"userName = %@", user];
    [request setPredicate:userNamePredicate];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedPosts = [[KTPostStore sharedStore].context executeFetchRequest:request error:&error];
    if (!error) {
        if (fetchedPosts.count > 0) {
            for (Post *p in fetchedPosts) {
                [self.context deleteObject:p];
            }
        }
    }
    [[KTPostStore sharedStore]saveChanges];
}

@end
