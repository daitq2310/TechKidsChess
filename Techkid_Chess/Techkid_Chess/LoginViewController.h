//
//  LoginViewController.h
//  Go Game
//
//  Created by Quang Dai on 5/29/16.
//  Copyright © 2016 HungVu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseGameViewController.h"
@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
- (IBAction)btnLoginTouchUpInside:(id)sender;
@property ChooseGameViewController *chooseVC;

@end
