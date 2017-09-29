//
//  ABRecentsInteractorIO.h
//  pics
//
//  Created by  Anand Biligiri on 9/23/17.
//  Copyright © 2017  Anand Biligiri. All rights reserved.
//

#ifndef ABRecentsInteractorIO_h
#define ABRecentsInteractorIO_h
@class ABPhoto;

@protocol ABRecentsInteractorInput <NSObject>
- (void)reload;
- (void)fetchRecentPhotosWithOffset:(NSUInteger)offset;
@end


@protocol ABRecentsInteractorOutput <NSObject>
- (void)fetchedRecentPhotos:(NSArray <ABPhoto *> *)recents offset:(NSUInteger)offset hasMore:(BOOL)hasMore;
- (void)failedToFetchPhotosWithError:(NSError *)error;
@end

#endif /* ABRecentsInteractorIO_h */
