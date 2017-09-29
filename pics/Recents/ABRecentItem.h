//
//  ABRecentItem.h
//  pics
//
//  Created by  Anand Biligiri on 9/27/17.
//  Copyright © 2017  Anand Biligiri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABRecentItem : NSObject <NSCopying>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSURL *thumbnailURL;
@end
