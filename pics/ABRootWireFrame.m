//
//  ABRootWireFrame.m
//  pics
//
//  Created by  Anand Biligiri on 9/26/17.
//  Copyright © 2017  Anand Biligiri. All rights reserved.
//

#import "ABRootWireFrame.h"

@implementation ABRootWireframe
- (void)showRootViewController:(UIViewController *)rootViewControler inWindow:(UIWindow *)window
{
    UINavigationController *nvc = [[UINavigationController alloc] init];
    nvc.viewControllers = @[rootViewControler];
    [window addSubview:nvc.view];
    window.rootViewController = nvc;
}
@end
