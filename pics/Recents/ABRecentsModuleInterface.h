//
//  ABRecentsModuleInterface.h
//  pics
//
//  Created by  Anand Biligiri on 9/26/17.
//  Copyright © 2017  Anand Biligiri. All rights reserved.
//

#ifndef ABRecentsModuleInterface_h
#define ABRecentsModuleInterface_h

@protocol ABRecentsModuleInterface <NSObject>
- (void)updateView;
- (void)reload;
@end
#endif /* ABRecentsModuleInterface_h */
