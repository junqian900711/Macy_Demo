//
//  BaseClass.m
//
//  Created by 钱骏  on 16/4/18
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "BaseClass.h"
#import "Lfs.h"


NSString *const kBaseClassLfs = @"lfs";
NSString *const kBaseClassSf = @"sf";


@interface BaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation BaseClass

@synthesize lfs = _lfs;
@synthesize sf = _sf;


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
    NSObject *receivedLfs = [dict objectForKey:kBaseClassLfs];
    NSMutableArray *parsedLfs = [NSMutableArray array];
    if ([receivedLfs isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedLfs) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedLfs addObject:[Lfs modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedLfs isKindOfClass:[NSDictionary class]]) {
       [parsedLfs addObject:[Lfs modelObjectWithDictionary:(NSDictionary *)receivedLfs]];
    }

    self.lfs = [NSArray arrayWithArray:parsedLfs];
            self.sf = [self objectOrNilForKey:kBaseClassSf fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForLfs = [NSMutableArray array];
    for (NSObject *subArrayObject in self.lfs) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForLfs addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForLfs addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForLfs] forKey:kBaseClassLfs];
    [mutableDict setValue:self.sf forKey:kBaseClassSf];

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

    self.lfs = [aDecoder decodeObjectForKey:kBaseClassLfs];
    self.sf = [aDecoder decodeObjectForKey:kBaseClassSf];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_lfs forKey:kBaseClassLfs];
    [aCoder encodeObject:_sf forKey:kBaseClassSf];
}

- (id)copyWithZone:(NSZone *)zone
{
    BaseClass *copy = [[BaseClass alloc] init];
    
    if (copy) {

        copy.lfs = [self.lfs copyWithZone:zone];
        copy.sf = [self.sf copyWithZone:zone];
    }
    
    return copy;
}


@end
