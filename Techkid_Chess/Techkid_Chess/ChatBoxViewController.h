//
//  ChatBoxViewController.h
//  Techkid_Chess
//
//  Created by Quang Dai on 5/29/16.
//  Copyright © 2016 TechKid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatBoxViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtInputChatText;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
- (IBAction)btnSendTouchUpInside:(id)sender;

@end
