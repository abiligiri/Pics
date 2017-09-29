//
//  ABRecentsLastFetchInfo.h
//  pics
//
//  Created by  Anand Biligiri on 9/24/17.
//  Copyright © 2017  Anand Biligiri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABRecentsLastFetchInfo : NSObject <NSCoding>
@property (nonatomic, readonly) NSTimeInterval lastFetchTimestamp;
@property (nonatomic, readonly) NSUInteger total;
@property (nonatomic, readonly) NSUInteger pages;
@property (nonatomic, readonly) NSUInteger perPage;
@property (nonatomic, readwrite) NSUInteger currentPage;

- (instancetype)initWithTimestamp:(NSTimeInterval)timestamp total:(NSUInteger)total page:(NSUInteger)pages perPage:(NSUInteger)perPage;
@end
