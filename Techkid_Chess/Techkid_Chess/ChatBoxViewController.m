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

@end

@implementation ChatBoxViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self sendMessage:@"Ahihi123"];
    self.messageIdx = 0;
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
    
    return cell;
}

- (IBAction)btnSendTouchUpInside:(id)sender {
    
}
@end
