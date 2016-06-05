//
//  ViewController.h
//  Techkid_Chess
//
//  Created by Ta Hoang Minh on 5/28/16.
//  Copyright © 2016 TechKid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseGameViewController.h"
@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
- (IBAction)btnLoginTouchUpInside:(id)sender;
@property ChooseGameViewController *chooseVC;
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@end

