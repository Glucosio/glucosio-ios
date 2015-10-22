#import <Foundation/Foundation.h>
#import "GLUCModel.h"

@interface GLUCRange : GLUCModel

@property (nonatomic, readwrite, strong) NSString *rangeName;
@property (nonatomic, readwrite, strong) NSNumber *rangeMin;
@property (nonatomic, readwrite, strong) NSNumber *rangeMax;

+ (NSArray *) allRanges;

@end
