//
//  ABPhoto.h
//  pics
//
//  Created by  Anand Biligiri on 9/23/17.
//  Copyright © 2017  Anand Biligiri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABPhoto : NSObject <NSCoding, NSCopying>
@property (nonatomic, readonly, copy) NSString *identifier;
@property (nonatomic, readonly, copy) NSString *owner;
@property (nonatomic, readonly, copy) NSString *secret;
@property (nonatomic, readonly, copy) NSString *server;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *farm;

- (id)initWithIdentifier:(NSString *)identifier owner:(NSString *)owner secret:(NSString *)secret server:(NSString *)server title:(NSString *)server farm:(NSString *)farm;
+ (ABPhoto *)photoWithJSONObject:(NSDictionary *)object;
@end
