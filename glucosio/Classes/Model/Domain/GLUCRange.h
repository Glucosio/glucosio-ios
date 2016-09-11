#import <Foundation/Foundation.h>
#import "GLUCModel.h"

@protocol RLMDouble;

@interface GLUCRange : GLUCModel

@property (nonatomic, readwrite, strong) NSString *rangeName;
@property (nonatomic, readwrite, strong) NSNumber<RLMDouble> *rangeMin;
@property (nonatomic, readwrite, strong) NSNumber<RLMDouble> *rangeMax;

+ (NSArray *) allRanges;

@end
