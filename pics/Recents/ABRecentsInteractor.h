//
//  ABRecentsInteractor.h
//  pics
//
//  Created by  Anand Biligiri on 9/23/17.
//  Copyright © 2017  Anand Biligiri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABRecentsInteractorIO.h"
@class ABPicsDataStore, ABPicsAPIClient;

@interface ABRecentsInteractor : NSObject <ABRecentsInteractorInput>
@property (nonatomic, weak) id<ABRecentsInteractorOutput> delegate;
- (instancetype)initWithDataStore:(ABPicsDataStore *)dataStore apiClient:(ABPicsAPIClient *)apiClient;
@end
