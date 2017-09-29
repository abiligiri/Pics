//
//  ABRecentsLastFetchInfo.m
//  pics
//
//  Created by  Anand Biligiri on 9/24/17.
//  Copyright © 2017  Anand Biligiri. All rights reserved.
//

#import "ABRecentsLastFetchInfo.h"

@implementation ABRecentsLastFetchInfo
{
    NSTimeInterval _timestamp;
    NSUInteger _total, _pages, _perPage;
}

- (instancetype)initWithTimestamp:(NSTimeInterval)timestamp total:(NSUInteger)total page:(NSUInteger)pages perPage:(NSUInteger)perPage
{
    self = [super init];
    
    if (self) {
        _timestamp = timestamp;
        _total = total;
        _pages = pages;
        _perPage = perPage;
        _currentPage = 1;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSTimeInterval timestamp = [aDecoder decodeDoubleForKey:@"ts"];
    NSUInteger total = [aDecoder decodeIntegerForKey:@"total"];
    NSUInteger page = [aDecoder decodeIntegerForKey:@"pages"];
    NSUInteger perPage = [aDecoder decodeIntegerForKey:@"perPage"];
    
    self = [self initWithTimestamp:timestamp total:total page:page perPage:perPage];
    self.currentPage = [aDecoder decodeIntegerForKey:@"currentPage"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeDouble:_timestamp forKey:@"ts"];
    [aCoder encodeInteger:_total forKey:@"total"];
    [aCoder encodeInteger:_pages forKey:@"pages"];
    [aCoder encodeInteger:_perPage forKey:@"perPage"];
    [aCoder encodeInteger:_currentPage forKey:@"currentPage"];
}
@end
