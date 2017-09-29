//
//  ABPicsDataStore.m
//  pics
//
//  Created by  Anand Biligiri on 9/23/17.
//  Copyright © 2017  Anand Biligiri. All rights reserved.
//

#import "ABPicsDataStore.h"
static NSString *lastFetchInfoKey = @"abRecentFetchInfo";
static NSString *lastFetchData = @"abRecentFetchData";

@implementation ABPicsDataStore
{
    NSMutableArray *_recentPhotos;
}

- (ABRecentsLastFetchInfo *)lastFetchInfoForRecentPhotos
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:lastFetchInfoKey];
    
    if (!data) {
        return nil;
    }
    
    ABRecentsLastFetchInfo *info = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return info;
}

- (NSArray *)recentPhotos
{
    if (!_recentPhotos) {
        _recentPhotos = [[NSKeyedUnarchiver unarchiveObjectWithFile:[self cacheFilePath]] mutableCopy];
        
        if (!_recentPhotos) {
            _recentPhotos = [NSMutableArray array];
        }
    }
    
    return _recentPhotos;
}

- (void)appendRecentsPhotos:(NSArray *)recents fetchInfo:(ABRecentsLastFetchInfo *)fetchInfo
{
    NSMutableArray *mutableRecents = (NSMutableArray *)self.recentPhotos;
    [mutableRecents addObjectsFromArray:recents];
    
    [NSKeyedArchiver archiveRootObject:mutableRecents toFile:[self cacheFilePath]];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:fetchInfo] forKey:lastFetchInfoKey];
}

- (void)clearRecentPhotos
{
    [_recentPhotos removeAllObjects];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:lastFetchInfoKey];
    [[NSFileManager defaultManager] removeItemAtPath:[self cacheFilePath] error:nil];
}

- (NSString *)cacheFilePath
{
    NSArray *caches = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheFile = [[caches[0] stringByAppendingPathComponent:@"flickr_recents"] stringByAppendingPathExtension:@"data"];
    
    return cacheFile;
}
@end
