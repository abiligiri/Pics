//
//  ABImageCache.h
//  pics
//
//  Created by  Anand Biligiri on 9/28/17.
//  Copyright © 2017  Anand Biligiri. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;
@interface ABImageCache : NSObject
- (UIImage *)cachedImageForKey:(id)key;
- (void)fetchImageAtURL:(NSURL *)URL key:(id)key completion:(void(^)(UIImage *image, NSError *error))compleiton;
- (void)suspend;
- (void)cancel;
- (void)resume;
- (void)clear;
@end
