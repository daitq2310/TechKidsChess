//
//  ChatBoxViewController.m
//  Techkid_Chess
//
//  Created by Quang Dai on 5/29/16.
//  Copyright © 2016 TechKid. All rights reserved.
//

#import "ChatBoxViewController.h"
#import "ChatRoomViewController.h"
#import "ChatCell.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@interface ChatBoxViewController () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>
@property ChatRoomViewController *socketRoom;
@property int messageIdx;
@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation ChatBoxViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self sendMessage:@"Ahihi123"];
    self.messageIdx = 0;
    [self backgroundChatBox];
    [self displayChatBox];
}

- (void) backgroundChatBox {
    self.view.backgroundColor = [UIColor colorWithRed:100.0f / 255.0f green:100.0f / 255.0f blue:100.0f / 255.0f alpha:0.8f];
    _background.layer.cornerRadius = 7.0f;
    _background.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.navigationController.view.alpha = 0.8;
}

- (void) displayChatBox {
    [UIView animateWithDuration:0.4f delay:0.f options:UIViewAnimationOptionCurveLinear animations:^{
        _background.frame = CGRectMake(_background.frame.origin.x, _background.frame.origin.y - _background.frame.size.height/2 - self.view.frame.size.height/2, _background.frame.size.width, _background.frame.size.height);
        _btnSend.frame = CGRectMake(_btnSend.frame.origin.x, _btnSend.frame.origin.y - _background.frame.size.height/2 - self.view.frame.size.height/2, _btnSend.frame.size.width, _btnSend.frame.size.height);
        _txtInputChatText.frame = CGRectMake(_txtInputChatText.frame.origin.x, _txtInputChatText.frame.origin.y - _background.frame.size.height/2 - self.view.frame.size.height/2, _txtInputChatText.frame.size.width, _txtInputChatText.frame.size.height);
        _tblChatDetail.frame = CGRectMake(_tblChatDetail.frame.origin.x, _tblChatDetail.frame.origin.y - _background.frame.size.height/2 - self.view.frame.size.height/2, _tblChatDetail.frame.size.width, _tblChatDetail.frame.size.height);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void) dismissChatBox {
    [UIView animateWithDuration:0.4f delay:0.f options:UIViewAnimationOptionCurveLinear animations:^{
        _background.frame = CGRectMake(_background.frame.origin.x, _background.frame.origin.y + _background.frame.size.height/2 - self.view.frame.size.height/2, _background.frame.size.width, _background.frame.size.height);
        _btnSend.frame = CGRectMake(_btnSend.frame.origin.x, _btnSend.frame.origin.y + _background.frame.size.height/2 - self.view.frame.size.height/2, _btnSend.frame.size.width, _btnSend.frame.size.height);
        _txtInputChatText.frame = CGRectMake(_txtInputChatText.frame.origin.x, _txtInputChatText.frame.origin.y + _background.frame.size.height/2 - self.view.frame.size.height/2, _txtInputChatText.frame.size.width, _txtInputChatText.frame.size.height);
        _tblChatDetail.frame = CGRectMake(_tblChatDetail.frame.origin.x, _tblChatDetail.frame.origin.y + _background.frame.size.height/2 - self.view.frame.size.height/2, _tblChatDetail.frame.size.width, _tblChatDetail.frame.size.height);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

- (void) sendMessage:(NSString *)message
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.socketRoom.roomReady) {
            [self.socketRoom.socket emit:@"message" withItems:@[message, self.socketRoom.roomName, self.socketRoom.userName]];
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1"];
    cell.lblChatTextLeft.layer.cornerRadius = 7.0f;
    cell.lblChatTextRight.layer.cornerRadius = 7.0f;
    return cell;
}

- (IBAction)btnSendTouchUpInside:(id)sender {
    
}

- (IBAction)btnBackClicked:(id)sender {
    [self dismissChatBox];
}


@end
