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


@end
