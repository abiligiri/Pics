//
//  ABRecentsWireframe.m
//  pics
//
//  Created by  Anand Biligiri on 9/27/17.
//  Copyright © 2017  Anand Biligiri. All rights reserved.
//
#import "ABRecentsWireframe.h"
#import "ViewController.h"
#import "ABRootWireFrame.h"
#import "ABRecentsPresenter.h"

@implementation ABRecentsWireframe
- (void)presentRecentsInterfaceFromWindow:(UIWindow *)window
{
    ViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    vc.recentsPresenter = self.recentsPresenter;
    self.recentsPresenter.userInterface = vc;
    
    [self.rootWireframe showRootViewController:vc inWindow:window];
}
@end
