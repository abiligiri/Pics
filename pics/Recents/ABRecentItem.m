//
//  ABRecentItem.m
//  pics
//
//  Created by  Anand Biligiri on 9/27/17.
//  Copyright © 2017  Anand Biligiri. All rights reserved.
//

#import "ABRecentItem.h"

@implementation ABRecentItem
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (NSUInteger)hash
{
    return [self.title hash] ^ [self.thumbnailURL hash];
}

- (BOOL)isEqual:(ABRecentItem *)other
{
    if (self == other) {
        return YES;
    }
    
    if (![other isKindOfClass:[ABRecentItem class]]) {
        return NO;
    }
    
    return [self.thumbnailURL isEqual:other.thumbnailURL] &&
    [self.title isEqualToString:other.title];
}
@end
