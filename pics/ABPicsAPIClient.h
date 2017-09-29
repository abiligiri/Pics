//
//  ABPicsAPIClient.h
//  pics
//
//  Created by  Anand Biligiri on 9/23/17.
//  Copyright © 2017  Anand Biligiri. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ABRecentsLastFetchInfo;

typedef NS_ENUM(NSUInteger, ABRecentsFetchError) {
    ABRecentsFetchErrorNot200,
    ABRecentsFetchErrorInvalidContentType,
    ABRecentsFetchErrorMissingData,
    ABRecentsFetchErrorJSONParse,
    ABRecentsFetchErrorInfoParse,
    ABRecentsFetchErrorPhotosParse,
};

@interface ABPicsAPIClient : NSObject
- (instancetype)initWithAPIKey:(NSString *)apiKey;
- (void)fetchRecentPhotosWithPage:(NSUInteger)currentPage completion:(void(^)(ABRecentsLastFetchInfo *info, NSArray *recents, NSError *error))completion;
@end
