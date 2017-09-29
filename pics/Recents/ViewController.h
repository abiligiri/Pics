//
//  ViewController.h
//  pics
//
//  Created by  Anand Biligiri on 9/22/17.
//  Copyright © 2017  Anand Biligiri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABRecentsViewInterface.h"

@class ABRecentsPresenter;

@interface ViewController : UIViewController <ABRecentsViewInterface>
@property (nonatomic, strong) ABRecentsPresenter *recentsPresenter;
@end

