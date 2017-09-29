//
//  AppDelegate.m
//  pics
//
//  Created by  Anand Biligiri on 9/22/17.
//  Copyright © 2017  Anand Biligiri. All rights reserved.
//

#import "AppDelegate.h"
#import "ABRecentsWireframe.h"
#import "ABRecentsInteractor.h"
#import "ABPicsAPIClient.h"
#import "ABPicsDataStore.h"
#import "ABRecentsPresenter.h"
#import "ABRootWireFrame.h"

@interface AppDelegate ()
@property (nonatomic, strong) ABRootWireframe *rootWireframe;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setupWithWindow:_window];
    [_window makeKeyWindow];
    return YES;
}

- (void)setupWithWindow:(UIWindow *)window
{
    ABPicsAPIClient *apiClient = [[ABPicsAPIClient alloc] initWithAPIKey:@"xxxx"];
    ABPicsDataStore *dataStore = [[ABPicsDataStore alloc] init];
    _rootWireframe = [[ABRootWireframe alloc] init];
    
    ABRecentsInteractor *recentsInteractor = [[ABRecentsInteractor alloc] initWithDataStore:dataStore apiClient:apiClient];
    ABRecentsPresenter *recentsPresenter = [[ABRecentsPresenter alloc] init];
    recentsPresenter.recentsInteractor = recentsInteractor;
    recentsInteractor.delegate = recentsPresenter;
    ABRecentsWireframe *recentsWireframe = [[ABRecentsWireframe alloc] init];
    recentsWireframe.recentsPresenter = recentsPresenter;
    recentsWireframe.rootWireframe = _rootWireframe;
    
    [recentsWireframe presentRecentsInterfaceFromWindow:window];
    
    //window -> nav -> recentsVC -> presenter -> interactor -> (apiClient, dataStore)
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
