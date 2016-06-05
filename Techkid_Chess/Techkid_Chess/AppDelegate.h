//
//  AppDelegate.h
//  Techkid_Chess
//
//  Created by Ta Hoang Minh on 5/28/16.
//  Copyright © 2016 TechKid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCManager.h"
#define APPDELEGATE     ((AppDelegate *)[UIApplication sharedApplication].delegate)
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MCManager *mcManager;

@end

