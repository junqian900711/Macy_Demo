//
//  Vars.m
//
//  Created by 钱骏  on 16/4/18
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "Vars.h"


NSString *const kVarsFreq = @"freq";
NSString *const kVarsLf = @"lf";
NSString *const kVarsSince = @"since";


@interface Vars ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Vars

@synthesize freq = _freq;
@synthesize lf = _lf;
@synthesize since = _since;


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
            self.freq = [[self objectOrNilForKey:kVarsFreq fromDictionary:dict] doubleValue];
            self.lf = [self objectOrNilForKey:kVarsLf fromDictionary:dict];
            self.since = [[self objectOrNilForKey:kVarsSince fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.freq] forKey:kVarsFreq];
    [mutableDict setValue:self.lf forKey:kVarsLf];
    [mutableDict setValue:[NSNumber numberWithDouble:self.since] forKey:kVarsSince];

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

    self.freq = [aDecoder decodeDoubleForKey:kVarsFreq];
    self.lf = [aDecoder decodeObjectForKey:kVarsLf];
    self.since = [aDecoder decodeDoubleForKey:kVarsSince];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_freq forKey:kVarsFreq];
    [aCoder encodeObject:_lf forKey:kVarsLf];
    [aCoder encodeDouble:_since forKey:kVarsSince];
}

- (id)copyWithZone:(NSZone *)zone
{
    Vars *copy = [[Vars alloc] init];
    
    if (copy) {

        copy.freq = self.freq;
        copy.lf = [self.lf copyWithZone:zone];
        copy.since = self.since;
    }
    
    return copy;
}


@end
