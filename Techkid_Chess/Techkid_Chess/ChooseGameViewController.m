//
//  ChooseGameViewController.m
//  Techkid_Chess
//
//  Created by Quang Dai on 5/29/16.
//  Copyright © 2016 TechKid. All rights reserved.
//

#import "ChooseGameViewController.h"

@interface ChooseGameViewController ()

@end

@implementation ChooseGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self customNavigation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) customNavigation {
    //---------------------------------------------------------
    //set color for navigation bar
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:3.0f/255.0f green:155.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    
    //---------------------------------------------------------
    //set title for back button
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //---------------------------------------------------------
    //set first title
    self.navigationItem.title = @"TechKids Gaming";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"ChalkboardSE-Bold" size:20], NSFontAttributeName, nil]];
}


- (void) playGo {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _gameVC = [storyboard instantiateViewControllerWithIdentifier:@"GameID"];
    _gameVC.username = self.username;
    [self.navigationController pushViewController:_gameVC animated:YES];
}

- (IBAction)btnGoTouchUpInside:(id)sender {
    [self playGo];
}

@end
