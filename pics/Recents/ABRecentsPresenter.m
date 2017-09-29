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

@implementation ABRecentsPresenter
{
    NSMutableArray *_items;
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
            [_items addObject:photo.title];
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
}
@end
