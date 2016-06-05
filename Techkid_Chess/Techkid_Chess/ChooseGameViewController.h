//
//  ChooseGameViewController.h
//  Techkid_Chess
//
//  Created by Quang Dai on 5/29/16.
//  Copyright © 2016 TechKid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"
@interface ChooseGameViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnGo;
- (IBAction)btnGoTouchUpInside:(id)sender;
@property GameViewController *gameVC;
@property NSString *username;

@end
