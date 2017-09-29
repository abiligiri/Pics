//
//  ABRecentsInteractor.m
//  pics
//
//  Created by  Anand Biligiri on 9/23/17.
//  Copyright © 2017  Anand Biligiri. All rights reserved.
//

#import "ABRecentsInteractor.h"
#import "ABPicsDataStore.h"
#import "ABRecentsLastFetchInfo.h"
#import "ABPicsAPIClient.h"

@implementation ABRecentsInteractor
{
    ABPicsDataStore *_dataStore;
    ABPicsAPIClient *_apiClient;
    dispatch_queue_t _queue;
}

- (instancetype)initWithDataStore:(ABPicsDataStore *)dataStore apiClient:(ABPicsAPIClient *)apiClient
{
    self = [super init];
    
    if (self) {
        _dataStore = dataStore;
        _apiClient = apiClient;
        _queue = dispatch_queue_create("recents_interactor", DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

- (void)reload
{
    [_dataStore clearRecentPhotos];
    [self fetchRecentPhotosWithOffset:0];
}

- (void)fetchRecentPhotosWithOffset:(NSUInteger)offset
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(_queue, ^{
        typeof(self) strongSelf = weakSelf;
        
        if (!strongSelf) {
            return;
        }
        
        ABRecentsLastFetchInfo *lastFetchInfo = [_dataStore lastFetchInfoForRecentPhotos];
        
        if (lastFetchInfo) {
            NSUInteger cachedItems = lastFetchInfo.perPage * lastFetchInfo.currentPage;
            if (cachedItems && offset < cachedItems) {
                NSLog(@"Fetching from cache , offset = %lu, items = %lu", offset, cachedItems);
                NSArray *recentPhotos = [_dataStore recentPhotos];
                [strongSelf notifyRecents:recentPhotos offset:offset hasMore: (lastFetchInfo.pages != lastFetchInfo.currentPage)];
                return;
            }
            
            //fallback to fetching from the network
        }

        NSLog(@"Fetching from network , page = %lu", lastFetchInfo.currentPage + 1);
        
        //no cached items or offset > number of cached items
        [_apiClient fetchRecentPhotosWithPage:(lastFetchInfo.currentPage + 1) completion:^(ABRecentsLastFetchInfo *info, NSArray *recents, NSError *error) {
            if (!strongSelf) {
                return;
            }
            dispatch_async(_queue, ^{
                if (error) {
                    return;
                }
                
                [_dataStore appendRecentsPhotos:recents fetchInfo:info];
                [strongSelf notifyRecents:recents offset:offset hasMore:(info.pages != info.currentPage)];
            });
        }];
    });
}

- (void)notifyRecents:(NSArray *)recents offset:(NSUInteger)offset hasMore:(BOOL)hasMore
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate fetchedRecentPhotos:recents offset:offset hasMore:hasMore];
    });
}
@end
