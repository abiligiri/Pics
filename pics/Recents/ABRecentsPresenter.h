//
//  ABRecentsPresenter.h
//  pics
//
//  Created by  Anand Biligiri on 9/26/17.
//  Copyright © 2017  Anand Biligiri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABRecentsInteractorIO.h"
#import "ABRecentsModuleInterface.h"

@protocol ABRecentsViewInterface;

@interface ABRecentsPresenter : NSObject <ABRecentsInteractorOutput, ABRecentsModuleInterface>
@property (nonatomic, weak) id<ABRecentsViewInterface> userInterface;
@property (nonatomic, strong) id<ABRecentsInteractorInput> recentsInteractor;
@end
