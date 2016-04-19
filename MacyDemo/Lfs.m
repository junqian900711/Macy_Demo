//
//  Lfs.m
//
//  Created by 钱骏  on 16/4/18
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "Lfs.h"
#import "Vars.h"


NSString *const kLfsFreq = @"freq";
NSString *const kLfsLf = @"lf";
NSString *const kLfsSince = @"since";
NSString *const kLfsVars = @"vars";


@interface Lfs ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Lfs

@synthesize freq = _freq;
@synthesize lf = _lf;
@synthesize since = _since;
@synthesize vars = _vars;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.freq = [[self objectOrNilForKey:kLfsFreq fromDictionary:dict] doubleValue];
            self.lf = [self objectOrNilForKey:kLfsLf fromDictionary:dict];
            self.since = [[self objectOrNilForKey:kLfsSince fromDictionary:dict] doubleValue];
    NSObject *receivedVars = [dict objectForKey:kLfsVars];
    NSMutableArray *parsedVars = [NSMutableArray array];
    if ([receivedVars isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedVars) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedVars addObject:[Vars modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedVars isKindOfClass:[NSDictionary class]]) {
       [parsedVars addObject:[Vars modelObjectWithDictionary:(NSDictionary *)receivedVars]];
    }

    self.vars = [NSArray arrayWithArray:parsedVars];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.freq] forKey:kLfsFreq];
    [mutableDict setValue:self.lf forKey:kLfsLf];
    [mutableDict setValue:[NSNumber numberWithDouble:self.since] forKey:kLfsSince];
    NSMutableArray *tempArrayForVars = [NSMutableArray array];
    for (NSObject *subArrayObject in self.vars) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForVars addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForVars addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForVars] forKey:kLfsVars];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.freq = [aDecoder decodeDoubleForKey:kLfsFreq];
    self.lf = [aDecoder decodeObjectForKey:kLfsLf];
    self.since = [aDecoder decodeDoubleForKey:kLfsSince];
    self.vars = [aDecoder decodeObjectForKey:kLfsVars];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_freq forKey:kLfsFreq];
    [aCoder encodeObject:_lf forKey:kLfsLf];
    [aCoder encodeDouble:_since forKey:kLfsSince];
    [aCoder encodeObject:_vars forKey:kLfsVars];
}

- (id)copyWithZone:(NSZone *)zone
{
    Lfs *copy = [[Lfs alloc] init];
    
    if (copy) {

        copy.freq = self.freq;
        copy.lf = [self.lf copyWithZone:zone];
        copy.since = self.since;
        copy.vars = [self.vars copyWithZone:zone];
    }
    
    return copy;
}


@end
