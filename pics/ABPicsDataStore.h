//
//  ABPicsDataStore.h
//  pics
//
//  Created by  Anand Biligiri on 9/23/17.
//  Copyright © 2017  Anand Biligiri. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ABPhoto, ABRecentsLastFetchInfo;

@interface ABPicsDataStore : NSObject
- (ABRecentsLastFetchInfo *)lastFetchInfoForRecentPhotos;
- (void)appendRecentsPhotos:(NSArray *)recents fetchInfo:(ABRecentsLastFetchInfo *)fetchInfo;
- (void)clearRecentPhotos;
- (NSArray *)recentPhotos;
@end
