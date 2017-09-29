//
//  ABRecentsViewInterface.h
//  pics
//
//  Created by  Anand Biligiri on 9/26/17.
//  Copyright © 2017  Anand Biligiri. All rights reserved.
//

#ifndef ABRecentsViewInterface_h
#define ABRecentsViewInterface_h
@class ABRecentItem;
@class UIImage;

@protocol ABRecentsViewInterface <NSObject>
- (void)showLoadMore;
- (void)hideLoadMore;
- (void)clearRecentItems;

- (void)showLoadingIndicator;
- (void)hideLoadingIndicator;
- (void)loadItems:(NSArray *)items offset:(NSUInteger)offset count:(NSUInteger)count;
- (void)showError:(NSError *)error;

- (void)showThumbnailImage:(UIImage *)image forRecentItem:(ABRecentItem *)item;
@end

#endif /* ABRecentsViewInterface_h */
