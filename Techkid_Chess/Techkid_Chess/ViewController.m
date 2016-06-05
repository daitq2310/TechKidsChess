//
//  ViewController.m
//  Techkid_Chess
//
//  Created by Ta Hoang Minh on 5/28/16.
//  Copyright © 2016 TechKid. All rights reserved.
//

#import "ViewController.h"
#import "ChatRoomViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self customNavigation];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoardWhenTap:)];
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void) chooseGame {
    if (_txtUsername.text.length == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Please input Username" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        NSLog(@"2");
        [alert show];
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _chooseVC = [storyboard instantiateViewControllerWithIdentifier:@"ChooseGameID"];
        _chooseVC.username = _txtUsername.text;
        [self.navigationController pushViewController:_chooseVC animated:YES];
    }
    
}

- (void) customNavigation {
    //---------------------------------------------------------
    //change back button icon
    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"back"];
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"back"];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //---------------------------------------------------------
    //set color for navigation bar
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:3.0f/255.0f green:155.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    
    //---------------------------------------------------------
    //set title for back button
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //---------------------------------------------------------
    //set first title
    self.navigationItem.title = @"Login";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"ChalkboardSE-Bold" size:23], NSFontAttributeName, nil]];
    
    //---------------------------------------------------------
    //change style of StatusBar
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction) dismissKeyBoardWhenTap:(id)sender{
    if ([_txtUsername isKindOfClass:[UITextField class]] && [_txtUsername isFirstResponder]) {
        [_txtUsername resignFirstResponder];
    }
    
    if ([_txtPassword isKindOfClass:[UITextField class]] && [_txtPassword isFirstResponder]) {
        [_txtPassword resignFirstResponder];
    }
}

- (IBAction)btnLoginTouchUpInside:(id)sender {
    [self chooseGame];
}

@end
