////////////////////////////////////////////////////////////////////////////
//
// Copyright 2014 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import <Realm/RLMCollection.h>

NS_ASSUME_NONNULL_BEGIN

@class RLMObject, RLMRealm, RLMNotificationToken;

/**
 RLMResults is an auto-updating container type in Realm returned from object
 queries.

 RLMResults can be queried with the same predicates as RLMObject and RLMArray
 and you can chain queries to further filter query results.

 RLMResults always reflect the current state of the Realm on the current thread,
 including during write transactions on the current thread. The one exception to
 this is when using `for...in` fast enumeration, which will always enumerate
 over the objects which matched the query when the enumeration is begun, even if
 some of them are deleted or modified to be excluded by the filter during the
 enumeration.

 RLMResults are initially lazily evaluated, and only run queries when the result
 of the query is requested. This means that chaining several temporary
 RLMResults to sort and filter your data does not perform any extra work
 processing the intermediate state.

 Once the results have been evaluated or a notification block has been added,
 the results are eagerly kept up-to-date, with the work done to keep them
 up-to-date done on a background thread whenever possible.

 RLMResults cannot be created directly.
 */
@interface RLMResults<RLMObjectType: RLMObject *> : NSObject<RLMCollection, NSFastEnumeration>

#pragma mark - Properties

/**
 Number of objects in the results.
 */
@property (nonatomic, readonly, assign) NSUInteger count;

/**
 The class name (i.e. type) of the RLMObjects contained in this RLMResults.
 */
@property (nonatomic, readonly, copy) NSString *objectClassName;

/**
 The Realm this `RLMResults` is associated with.
 */
@property (nonatomic, readonly) RLMRealm *realm;

/**
 Indicates if the results can no longer be accessed.

 The results can no longer be accessed if `invalidate` is called on the containing `realm`.
 */
@property (nonatomic, readonly, getter = isInvalidated) BOOL invalidated;

#pragma mark - Accessing Objects from an RLMResults

/**
 Returns the object at the index specified.

 @param index   The index to look up.

 @return An RLMObject of the type contained in this RLMResults.
 */
- (RLMObjectType)objectAtIndex:(NSUInteger)index;

/**
 Returns the first object in the results.

 Returns `nil` if called on an empty RLMResults.

 @return An RLMObject of the type contained in this RLMResults.
 */
- (nullable RLMObjectType)firstObject;

/**
 Returns the last object in the results.

 Returns `nil` if called on an empty RLMResults.

 @return An RLMObject of the type contained in this RLMResults.
 */
- (nullable RLMObjectType)lastObject;

#pragma mark - Querying Results

/**
 Gets the index of an object.

 Returns NSNotFound if the object is not found in this RLMResults.

 @param object  An object (of the same type as returned from the objectClassName selector).
 */
- (NSUInteger)indexOfObject:(RLMObjectType)object;

/**
 Gets the index of the first object matching the predicate.

 @param predicateFormat The predicate format string which can accept variable arguments.

 @return    Index of object or NSNotFound if the object is not found in this RLMResults.
 */
- (NSUInteger)indexOfObjectWhere:(NSString *)predicateFormat, ...;

/// :nodoc:
- (NSUInteger)indexOfObjectWhere:(NSString *)predicateFormat args:(va_list)args;

/**
 Gets the index of the first object matching the predicate.

 @param predicate   The predicate to filter the objects.

 @return    Index of object or NSNotFound if the object is not found in this RLMResults.
 */
- (NSUInteger)indexOfObjectWithPredicate:(NSPredicate *)predicate;

/**
 Get objects matching the given predicate in the RLMResults.

 @param predicateFormat The predicate format string which can accept variable arguments.

 @return                An RLMResults of objects that match the given predicate
 */
- (RLMResults<RLMObjectType> *)objectsWhere:(NSString *)predicateFormat, ...;

/// :nodoc:
- (RLMResults<RLMObjectType> *)objectsWhere:(NSString *)predicateFormat args:(va_list)args;

/**
 Get objects matching the given predicate in the RLMResults.

 @param predicate   The predicate to filter the objects.

 @return            An RLMResults of objects that match the given predicate
 */
- (RLMResults<RLMObjectType> *)objectsWithPredicate:(NSPredicate *)predicate;

/**
 Get a sorted `RLMResults` from an existing `RLMResults` sorted by a property.

 @param property    The property name to sort by.
 @param ascending   The direction to sort by.

 @return    An RLMResults sorted by the specified property.
 */
- (RLMResults<RLMObjectType> *)sortedResultsUsingProperty:(NSString *)property ascending:(BOOL)ascending;

/**
 Get a sorted `RLMResults` from an existing `RLMResults` sorted by an `NSArray`` of `RLMSortDescriptor`s.

 @param properties  An array of `RLMSortDescriptor`s to sort by.

 @return    An RLMResults sorted by the specified properties.
 */
- (RLMResults<RLMObjectType> *)sortedResultsUsingDescriptors:(NSArray *)properties;

#pragma mark - Notifications

/**
 Register a block to be called each time the RLMResults changes.

 The block will be asynchronously called with the initial results, and then
 called again after each write transaction which changes either any of the
 objects in the results, or which objects are in the results.

 The change parameter will be `nil` the first time the block is called with the
 initial results. For each call after that, it will contain information about
 which rows in the results were added, removed or modified. If a write transaction
 did not modify any objects in this results, the block is not called at all.
 See the RLMCollectionChange documentation for information on how the changes
 are reported and an example of updating a UITableView.

 If an error occurs the block will be called with `nil` for the results
 parameter and a non-`nil` error. Currently the only errors that can occur are
 when opening the RLMRealm on the background worker thread.

 At the time when the block is called, the RLMResults object will be fully
 evaluated and up-to-date, and as long as you do not perform a write transaction
 on the same thread or explicitly call `-[RLMRealm refresh]`, accessing it will
 never perform blocking work.

 Notifications are delivered via the standard run loop, and so can't be
 delivered while the run loop is blocked by other activity. When
 notifications can't be delivered instantly, multiple notifications may be
 coalesced into a single notification. This can include the notification
 with the initial results. For example, the following code performs a write
 transaction immediately after adding the notification block, so there is no
 opportunity for the initial notification to be delivered first. As a
 result, the initial notification will reflect the state of the Realm after
 the write transaction.

     RLMResults<Dog *> *results = [Dog allObjects];
     NSLog(@"dogs.count: %zu", dogs.count); // => 0
     self.token = [results addNotificationBlock:^(RLMResults *dogs,
                                                  RLMCollectionChange *changes,
                                                  NSError *error) {
         // Only fired once for the example
         NSLog(@"dogs.count: %zu", dogs.count); // => 1
     }];
     [realm transactionWithBlock:^{
         Dog *dog = [[Dog alloc] init];
         dog.name = @"Rex";
         [realm addObject:dog];
     }];
     // end of run loop execution context

 You must retain the returned token for as long as you want updates to continue
 to be sent to the block. To stop receiving updates, call `-stop` on the token.

 @warning This method cannot be called during a write transaction, or when the
          containing realm is read-only.

 @param block The block to be called with the evaluated results.
 @return A token which must be held for as long as you want query results to be delivered.
 */
- (RLMNotificationToken *)addNotificationBlock:(void (^)(RLMResults<RLMObjectType> *__nullable results,
                                                         RLMCollectionChange *__nullable change,
                                                         NSError *__nullable error))block __attribute__((warn_unused_result));

#pragma mark - Aggregating Property Values

/**
 Returns the minimum (lowest) value of the given property

     NSNumber *min = [results minOfProperty:@"age"];

 @warning You cannot use this method on RLMObject, RLMArray, and NSData properties.

 @param property The property to look for a minimum on. Only properties of type int, float, double and NSDate are supported.

 @return The minimum value for the property amongst objects in an RLMResults.
 */
- (nullable id)minOfProperty:(NSString *)property;

/**
 Returns the maximum (highest) value of the given property of objects in an RLMResults

     NSNumber *max = [results maxOfProperty:@"age"];

 @warning You cannot use this method on RLMObject, RLMArray, and NSData properties.

 @param property The property to look for a maximum on. Only properties of type int, float, double and NSDate are supported.

 @return The maximum value for the property amongst objects in an RLMResults
 */
- (nullable id)maxOfProperty:(NSString *)property;

/**
 Returns the sum of the given property for objects in an RLMResults.

     NSNumber *sum = [results sumOfProperty:@"age"];

 @warning You cannot use this method on RLMObject, RLMArray, and NSData properties.

 @param property The property to calculate sum on. Only properties of type int, float and double are supported.

 @return The sum of the given property over all objects in an RLMResults.
 */
- (NSNumber *)sumOfProperty:(NSString *)property;

/**
 Returns the average of a given property for objects in an RLMResults.

     NSNumber *average = [results averageOfProperty:@"age"];

 @warning You cannot use this method on RLMObject, RLMArray, and NSData properties.

 @param property The property to calculate average on. Only properties of type int, float and double are supported.

 @return    The average for the given property amongst objects in an RLMResults. This will be of type double for both
 float and double properties.
 */
- (nullable NSNumber *)averageOfProperty:(NSString *)property;

/// :nodoc:
- (id)objectAtIndexedSubscript:(NSUInteger)index;

#pragma mark - Unavailable Methods

/**
 -[RLMResults init] is not available because RLMResults cannot be created directly.
 RLMResults can be obtained by querying a Realm.
 */
- (instancetype)init __attribute__((unavailable("RLMResults cannot be created directly")));

/**
 +[RLMResults new] is not available because RLMResults cannot be created directly.
 RLMResults can be obtained by querying a Realm.
 */
+ (instancetype)new __attribute__((unavailable("RLMResults cannot be created directly")));

@end

/**
 RLMLinkingObjects is an auto-updating container type that represents a collection of objects that
 link to a given object.
 */
@interface RLMLinkingObjects<RLMObjectType: RLMObject *> : RLMResults
@end

NS_ASSUME_NONNULL_END
