//
//  BCDatabaseManager.m
//  BadCertificates
//
//  Created by Cody Kolodziejzyk on 2/11/14.
//  Copyright (c) 2014 Cody Kolodziejzyk. All rights reserved.
//

#import "BCDatabaseManager.h"
#import "Emotion.h"
#import "Noun.h"
#import "Adjective.h"
#import <stdlib.h>
#import <time.h>

@interface BCDatabaseManager ()

@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation BCDatabaseManager

@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (BCDatabaseManager *)sharedInstance
{
	static BCDatabaseManager *sharedInstance = nil;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		sharedInstance = [[BCDatabaseManager alloc] init];
	});
	
	return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // merge shipped emotions
        [self mergeEmotionsPlist];
        // merge shipped adjectives
        [self mergeAdjectivesPlist];
        // merge shipped nouns
        [self mergeNounsPlist];
    }
    return self;
}

#pragma mark - Methods

- (NSString *)getAdjective
{
    Adjective *randomAdjective = (Adjective *)[self getRandomObjectForEntityName:@"Adjective"];
    return [randomAdjective adjective];
}

- (NSString *)getNoun
{
    Noun *randomNoun = (Noun *)[self getRandomObjectForEntityName:@"Noun"];
    return [randomNoun noun];
}

- (NSString *)getEmotion
{
    Emotion *randomEmotion = (Emotion *)[self getRandomObjectForEntityName:@"Emotion"];
    return [randomEmotion emotion];
}

- (void)addEmotions:(NSArray *)emotions
{
	NSManagedObjectContext *context = [self managedObjectContext];
    for (NSDictionary *emo in emotions) {
        if (![self duplicateExistsWithEntity:@"Emotion" propertyName:@"emotion" value:emo[@"emotion"]]) {
            Emotion *emotion = [NSEntityDescription
                                insertNewObjectForEntityForName:@"Emotion"
                                inManagedObjectContext:context];
            [emotion setEmotion:emo[@"emotion"]];
            DLog(@"Inserted emotion: %@", emotion.emotion);
        }
    }
    [self saveContext];
}

- (void)addAdjectives:(NSArray *)adjectives
{
	NSManagedObjectContext *context = [self managedObjectContext];
    for (NSDictionary *adj in adjectives) {
        if (![self duplicateExistsWithEntity:@"Adjective" propertyName:@"adjective" value:adj[@"adjective"]]) {
            Adjective *adjective = [NSEntityDescription
                                insertNewObjectForEntityForName:@"Adjective"
                                inManagedObjectContext:context];
            [adjective setAdjective:adj[@"adjective"]];
            [adjective setDirty:[NSNumber numberWithBool:NO]];
            DLog(@"Inserted adjective: %@", adjective.adjective);
        }
    }
    [self saveContext];
}

- (void)addNouns:(NSArray *)nouns
{
	NSManagedObjectContext *context = [self managedObjectContext];
    for (NSDictionary *nounTemp in nouns) {
        if (![self duplicateExistsWithEntity:@"Noun" propertyName:@"noun" value:nounTemp[@"noun"]]) {
            Noun *noun = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"Noun"
                                    inManagedObjectContext:context];
            [noun setNoun:nounTemp[@"noun"]];
            [noun setDirty:[NSNumber numberWithBool:NO]];
            DLog(@"Inserted Noun: %@", noun.noun);
        }
    }
    [self saveContext];
}

#pragma mark - Helpers

- (NSManagedObject *)getRandomObjectForEntityName:(NSString *)name
{
    // Get the entity description
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:name
                                                         inManagedObjectContext:self.managedObjectContext];
    
    // Create the fetch request to get all messages matching the IDs
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setIncludesSubentities:NO];
    [fetchRequest setEntity:entityDescription];
    
    // Get total number of elements
    NSUInteger num = [self.managedObjectContext countForFetchRequest:fetchRequest error:nil];
    
    // calculcate random offset
    NSUInteger offset = num - (1 + arc4random() % num);
    
    // perform fina fetch request
    NSFetchRequest *finalFetch = [[NSFetchRequest alloc] init];
    [finalFetch setEntity:entityDescription];
    [finalFetch setFetchOffset:offset];
    [finalFetch setFetchLimit:1];
    
    NSError *err = nil;
    NSArray *sampledEntities = [self.managedObjectContext executeFetchRequest:finalFetch error:&err];
    
    if (!err && sampledEntities.count) {
        return sampledEntities[0];
    }
    
    return nil;
}

- (BOOL)duplicateExistsWithEntity:(NSString *)entityName propertyName:(NSString *)propertyName value:(NSString *)value
{
    NSString *val = value;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    [request setFetchLimit:1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", propertyName, val];
    [request setPredicate:predicate];
    
    NSError *err = nil;
    NSUInteger num = [self.managedObjectContext countForFetchRequest:request error:&err];
    if (!err && num == 0) {
        return NO;
    }
    
    DLog(@"duplicate found of property %@: %@", propertyName, value);
    return YES;
}

#pragma mark - Utilities

- (void)mergeEmotionsPlist
{
    NSMutableArray *cachedEmotions = [NSMutableArray new];
    for (NSString *emo in [self plistDataWithName:@"feelings"]) {
        NSDictionary *dict = @{@"emotion": [emo lowercaseString]};
        [cachedEmotions addObject:dict];
    }
    [self addEmotions:cachedEmotions];
}

- (void)mergeAdjectivesPlist
{
    NSMutableArray *cachedAdjectives = [NSMutableArray new];
    for (NSString *adj in [self plistDataWithName:@"adjectives"]) {
        NSDictionary *dict = @{@"adjective": adj, @"dirty" : @NO};
        [cachedAdjectives addObject:dict];
    }
    [self addAdjectives:cachedAdjectives];
}

- (void)mergeNounsPlist
{
    NSMutableArray *cachedNouns = [NSMutableArray new];
    for (NSString *noun in [self plistDataWithName:@"nouns"]) {
        NSDictionary *dict = @{@"noun": noun, @"dirty" : @NO};
        [cachedNouns addObject:dict];
    }
    [self addNouns:cachedNouns];
}

- (NSArray *)plistDataWithName:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    if (dict) {
        return dict[@"Data"];
    }
    
    return nil;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            DLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

/*
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return _managedObjectContext;
}


// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

/*
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    
    /*
     Set up the store.
     For the sake of illustration, provide a pre-populated default store.
     */
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:[storeURL path]]) {
        NSURL *defaultStoreURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"sqlite"];
        if (defaultStoreURL) {
            [fileManager copyItemAtURL:defaultStoreURL toURL:storeURL error:NULL];
        }
    }
    
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    
    NSError *error;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        DLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
