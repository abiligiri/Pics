//
//  ABRecentsPresenter.m
//  pics
//
//  Created by  Anand Biligiri on 9/26/17.
//  Copyright © 2017  Anand Biligiri. All rights reserved.
//

#import "ABRecentsPresenter.h"
#import "ABRecentsInteractorIO.h"
#import "ABRecentsModuleInterface.h"
#import "ABRecentsViewInterface.h"
#import "ABPhoto.h"
#import "ABRecentItem.h"
#import "ABImageCache.h"

@interface ABRecentsPresenter()
@property (nonatomic, readonly) ABImageCache *imageCache;
@end

@implementation ABRecentsPresenter
{
    NSMutableArray <ABRecentItem *> *_items;
    ABImageCache *_imageCache;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _items = [NSMutableArray array];
    }
    
    return self;
}

- (void)fetchedRecentPhotos:(NSArray<ABPhoto *> *)recents offset:(NSUInteger)offset hasMore:(BOOL)hasMore
{
    if (offset >= _items.count) {
        for (ABPhoto *photo in recents) {
            ABRecentItem *recentItem = [[ABRecentItem alloc] init];
            recentItem.title = photo.title;
            recentItem.thumbnailURL = [photo thumbnailURL];
            [_items addObject:recentItem];
        }
        
        [self.userInterface loadItems:_items offset:offset count:(_items.count - offset)];
        
        [self.userInterface hideLoadingIndicator];
        
        if (hasMore) {
            [self.userInterface showLoadMore];
        } else {
            [self.userInterface hideLoadMore];
        }
    }
}

- (void)failedToFetchPhotosWithError:(NSError *)error
{
    [self.userInterface hideLoadingIndicator];
    [self.userInterface showError:error];
}

- (void)updateView
{
    [self.userInterface showLoadingIndicator];
    [self.recentsInteractor fetchRecentPhotosWithOffset:_items.count];
}

- (void)reload
{
    [self.userInterface showLoadingIndicator];
    [_items removeAllObjects];
    [self.recentsInteractor reload];
    [self cancelThumbnailDownloads];
    [self.imageCache clear];
}

- (UIImage *)cachedImageForRecentItem:(ABRecentItem *)item
{
    return [self.imageCache cachedImageForKey:item];
}

- (void)fetchThumbnailForRecentItem:(ABRecentItem *)item
{
    __weak typeof(self) weakSelf = self;
    [self.imageCache fetchImageAtURL:item.thumbnailURL key:item completion:^(UIImage *image, NSError *error) {
        if (!error) {
            [weakSelf.userInterface showThumbnailImage:image forRecentItem:item];
        }
    }];
}

- (void)cancelThumbnailDownloads
{
    [self.imageCache cancel];
}

- (ABImageCache *)imageCache
{
    if (!_imageCache) {
        _imageCache = [[ABImageCache alloc] init];
    }
    
    return _imageCache;
}
@end
