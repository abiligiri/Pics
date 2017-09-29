//
//  ABPicsAPIClient.m
//  pics
//
//  Created by  Anand Biligiri on 9/23/17.
//  Copyright © 2017  Anand Biligiri. All rights reserved.
//

#import "ABPicsAPIClient.h"
#import "ABRecentsLastFetchInfo.h"
#import "ABPhoto.h"

@implementation ABPicsAPIClient
{
    NSString *_apiKey;
}

- (instancetype)initWithAPIKey:(NSString *)apiKey
{
    self = [super init];
    
    if (self) {
        _apiKey = [apiKey copy];
    }
    
    return self;
}

- (void)fetchRecentPhotosWithPage:(NSUInteger)page completion:(void(^)(ABRecentsLastFetchInfo *info, NSArray *recents, NSError *error))completion
{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme = @"https";
    components.host = @"api.flickr.com";
    components.path = @"/services/rest";
    NSMutableArray *queryItems = [NSMutableArray array];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"method" value:@"flickr.photos.getRecent"]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"api_key" value:@"7b85e389607020e3b5a12c5a40e260db"]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"per_page" value:@"25"]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"page" value:[NSString stringWithFormat:@"%ld", page]]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"format" value:@"json"]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"nojsoncallback" value:@"1"]];
    components.queryItems = [queryItems copy];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[components URL]];
    
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *fetchTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        typeof(self) strongSelf = weakSelf;
        
        if (!strongSelf)
        {
            return;
        }
        
        if (error) {
            completion(nil, nil, error);
            return;
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (!response || httpResponse.statusCode != 200) {
            completion(nil, nil, [NSError errorWithDomain:@"FlickrAPI" code:ABRecentsFetchErrorNot200 userInfo:nil]);
            return;
        }
        
        if (![httpResponse.allHeaderFields[@"Content-Type"] hasPrefix:@"application/json"]) {
            completion(nil, nil, [NSError errorWithDomain:@"FlickrAPI" code:ABRecentsFetchErrorInvalidContentType userInfo:nil]);
            return;
        }
        
        if (!data.length) {
            completion(nil, nil, [NSError errorWithDomain:@"FlickrAPI" code:ABRecentsFetchErrorMissingData userInfo:nil]);
            return;
        }
        
        NSError *jsonError = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError || ![result isKindOfClass:[NSDictionary class]]) {
            completion(nil, nil, [NSError errorWithDomain:@"FlickrAPI" code:ABRecentsFetchErrorJSONParse userInfo:nil]);
            return;
        }
        
        NSError *infoParseError = nil;
        ABRecentsLastFetchInfo *info = [[strongSelf class] parseInfo:result error:&infoParseError];
        
        if (infoParseError) {
            completion(nil, nil, [NSError errorWithDomain:@"FlickrAPI" code:ABRecentsFetchErrorInfoParse userInfo:nil]);
            return;
        }
        
        NSError *photosParseError = nil;
        
        NSArray *recents = [[strongSelf class] parseRecentPhotos:result error:&photosParseError];
        
        if (photosParseError) {
            completion(nil, nil, [NSError errorWithDomain:@"FlickrAPI" code:ABRecentsFetchErrorPhotosParse userInfo:nil]);
            return;
        }
        
        completion(info, recents, nil);
    }];
    
    [fetchTask resume];
}

+ (ABRecentsLastFetchInfo *)parseInfo:(NSDictionary *)result error:(NSError *__autoreleasing *)error
{
    //-----> { "photos": { "page": 1, "pages": 10, "perpage": 100, "total": "1000",
    //     "photo": [
    NSDictionary *photos = result[@"photos"];
    
    if (![photos isKindOfClass:[NSDictionary class]]) {
        *error = [NSError errorWithDomain:@"FlickrAPI" code:1 userInfo:nil];
        return nil;
    }
    
    NSNumber *page = photos[@"page"];
    NSNumber *pages = photos[@"pages"];
    NSNumber *perPage = photos[@"perpage"];
    NSNumber *total = photos[@"total"];
    
    if (page && [page isKindOfClass:[NSNumber class]] &&
        pages && [pages isKindOfClass:[NSNumber class]] &&
        perPage && [perPage isKindOfClass:[NSNumber class]] &&
        total && [total isKindOfClass:[NSNumber class]]) {
        ABRecentsLastFetchInfo *info = [[ABRecentsLastFetchInfo alloc] initWithTimestamp:[NSDate timeIntervalSinceReferenceDate]
                                                                                   total:total.unsignedIntegerValue
                                                                                    page:pages.unsignedIntegerValue
                                                                                 perPage:perPage.unsignedIntegerValue];
        info.currentPage = page.unsignedIntegerValue;
        
        return info;
    }
    
    return nil;
}

+ (NSArray <ABPhoto *> *)parseRecentPhotos:(NSDictionary *)results error:(NSError *__autoreleasing *)error
{
    // { "photos": { "page": 1, "pages": 10, "perpage": 100, "total": "1000",
    //----->      "photo": [
    //                    { "id": "23504522138", "owner": "20509430@N00", "secret": "19a2a0ee32", "server": "4511", "farm": 5, "title": "greved-75.jpg", "ispublic": 1, "isfriend": 0, "isfamily": 0 },
    //                    { "id": "23504523188", "owner": "158451764@N02", "secret": "ee54473e80", "server": "4408", "farm": 5, "title": "Elegant Sexy Crochet Hollowed Out Evening Dress", "ispublic": 1, "isfriend": 0, "isfamily": 0 },
    //                    { "id": "23504523268", "owner": "67084790@N03", "secret": "23f5af2ae3", "server": "4472", "farm": 5, "title": "7_DSC8801", "ispublic": 1, "isfriend": 0, "isfamily": 0 },

    NSArray *photoList = [results valueForKeyPath:@"photos.photo"];
    
    if (![photoList isKindOfClass:[NSArray class]]) {
        *error = [NSError errorWithDomain:@"FlickrAPI" code:1 userInfo:nil];
        return nil;
    }
    
    NSMutableArray *recents = [NSMutableArray array];
    
    for (NSDictionary *photo in photoList) {
        if (![photo isKindOfClass:[NSDictionary class]]) {
            *error = [NSError errorWithDomain:@"FlickrAPI" code:1 userInfo:nil];
            return nil;
        }
        
        ABPhoto *recentPhoto = [ABPhoto photoWithJSONObject:photo];
        
        if (recentPhoto) {
            [recents addObject:recentPhoto];
        }
    }
    
    return recents;
}
@end
