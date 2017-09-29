//
//  ABImageCache.m
//  pics
//
//  Created by  Anand Biligiri on 9/28/17.
//  Copyright © 2017  Anand Biligiri. All rights reserved.
//

#import "ABImageCache.h"
#import <UIKit/UIImage.h>

@interface ABImageCache()
@property (nonatomic, readonly) NSString *recentsDirectory;
@end

@implementation ABImageCache
{
    NSCache *_cache;
    NSOperationQueue *_queue;
    NSString *_recentsDirectory;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _cache = [[NSCache alloc] init];
        _cache.countLimit = 100;
        
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 5;
    }
    
    return self;
}

- (UIImage *)cachedImageForKey:(id)key
{
    return [_cache objectForKey:key];
}

- (void)fetchImageAtURL:(NSURL *)URL key:(id)key completion:(void (^)(UIImage *, NSError *))completion
{
    __weak typeof(self) weakSelf = self;
    
    [_queue addOperationWithBlock:^{
        typeof(self) strongSelf = weakSelf;
        
        if (!strongSelf) {
            return ;
        }
        
        NSString *filePath = [strongSelf filePathForURL:URL];
        
        NSData *imgData;
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            imgData = [NSData dataWithContentsOfFile:filePath];
        } else {
            NSError *error = nil;
            imgData = [NSData dataWithContentsOfURL:URL options:0 error:&error];
            
            if (error && !imgData.length) {
                if (completion) {
                    completion(nil, error ?: [NSError errorWithDomain:@"ImageCache" code:1 userInfo:nil]);
                }
                return;
            }
            
            [imgData writeToFile:filePath atomically:YES];
        }
        
        UIImage *image = [UIImage imageWithData:imgData];
        
        [_cache setObject:image forKey:key];
        
        if (completion) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completion(image, nil);
            }];
        }
    }];
}

- (NSString *)filePathForURL:(NSURL *)URL
{
    NSData *data = [URL.absoluteString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *filename = [data base64EncodedStringWithOptions:0];
    
    return [self.recentsDirectory stringByAppendingPathComponent:filename];
}

- (NSString *)recentsDirectory {
    if (!_recentsDirectory) {
        NSError *error;
        
        NSString *cachesDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *picsDirectory = [cachesDirectory stringByAppendingPathComponent:@"recents"];
        
        BOOL directory = NO;
        if (![[NSFileManager defaultManager] fileExistsAtPath:picsDirectory isDirectory:&directory]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:picsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        }

        _recentsDirectory = picsDirectory;
    }
    
    return _recentsDirectory;
}

- (void)resume
{
    [_queue setSuspended:NO];
}

- (void)suspend
{
    [_queue setSuspended:YES];
}

- (void)cancel
{
    [_queue cancelAllOperations];
}

- (void)clear
{
    [self cancel];
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:self.recentsDirectory error:&error];
}
@end
