//
//  ABRecentsWireframe.h
//  pics
//
//  Created by  Anand Biligiri on 9/27/17.
//  Copyright © 2017  Anand Biligiri. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ABRootWireframe, ABRecentsPresenter, UIWindow;

@interface ABRecentsWireframe : NSObject
@property (nonatomic, weak) ABRootWireframe *rootWireframe;
@property (nonatomic, strong) ABRecentsPresenter *recentsPresenter;

- (void)presentRecentsInterfaceFromWindow:(UIWindow *)window;
@end
