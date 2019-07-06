//
//  ABPhoto.m
//  pics
//
//  Created by  Anand Biligiri on 9/23/17.
//  Copyright © 2017  Anand Biligiri. All rights reserved.
//
// More testing

#import "ABPhoto.h"

static NSString *identiferKey = @"r_id";
static NSString *ownerKey = @"r_owner";
static NSString *secretKey = @"r_secret";
static NSString *serverKey = @"r_server";
static NSString *titleKey = @"r_title";
static NSString *farmKey = @"r_farm";
static NSString *attributesKey = @"r_attributes";


@interface ABPhoto()
@property (nonatomic, readonly) NSMutableDictionary *attributes;
@end

@implementation ABPhoto
{
    NSMutableDictionary *_attributes;
}

+ (ABPhoto *)photoWithJSONObject:(NSDictionary *)object
{
    NSString *identifier = object[@"id"];
    NSString *owner = object[@"owner"];
    NSString *secret = object[@"secret"];
    NSString *server = object[@"server"];
    NSNumber *farm = object[@"farm"];
    NSString *title = object[@"title"];
    
    if (identifier && [identifier isKindOfClass:[NSString class]] &&
        owner && [owner isKindOfClass:[NSString class]] &&
        secret && [secret isKindOfClass:[NSString class]] &&
        server && [server isKindOfClass:[NSString class]] &&
        farm && [farm isKindOfClass:[NSNumber class]] &&
        title && [title isKindOfClass:[NSString class]]) {
        ABPhoto *recentPhoto = [[ABPhoto alloc] initWithIdentifier:identifier owner:owner secret:secret server:server title:title farm:[farm stringValue]];
        
        return recentPhoto;
    }

    return nil;
}

- (instancetype)initWithIdentifier:(NSString *)identifier owner:(NSString *)owner secret:(NSString *)secret server:(NSString *)server title:(NSString *)title farm:(NSString *)farm
{
    self = [super init];
    
    if (self) {
        _attributes = [NSMutableDictionary dictionaryWithCapacity:5];
        _attributes[identiferKey] = identifier ? [identifier copy]: @"";
        _attributes[ownerKey] = owner ? [owner copy] : @"";
        _attributes[secretKey] = secret ? [secret copy] : @"";
        _attributes[serverKey] = server ? [server copy] : @"";
        _attributes[titleKey] = title ? [title copy] : @"";
        _attributes[farmKey] = farm ? [farm copy] : @"";
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_attributes forKey:attributesKey];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [self initWithIdentifier:nil owner:nil secret:nil server:nil title:nil farm:nil];
    
    if (self) {
        _attributes = [aDecoder decodeObjectForKey:attributesKey];
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (BOOL)isEqual:(ABPhoto *)other
{
    if (![other isKindOfClass:[self class]]) {
        return NO;
    }
    
    return  [_attributes isEqual:other.attributes];
}

- (NSString *)identifier
{
    return _attributes[identiferKey];
}

- (NSString *)owner
{
    return _attributes[ownerKey];
}

- (NSString *)secret
{
    return _attributes[secretKey];
}

- (NSString *)server
{
    return _attributes[serverKey];
}

- (NSString *)title
{
    return _attributes[titleKey];
}

- (NSString *)farm
{
    return _attributes[farmKey];
}

- (NSURL *)thumbnailURL
{
    //https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_[q].jpg
    //q is 150x150
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_q.jpg", self.farm, self.server, self.identifier, self.secret]];
}
@end
