//
//  InformationViewController.m
//  Gizmeondeals
//
//  Created by Roy Leela Electronics on 24/04/15.
//  Copyright (c) 2015 Roy Leela Electronics. All rights reserved.
//

#import "InformationViewController.h"

@interface InformationViewController ()

@end

@implementation InformationViewController
@synthesize Scrollview;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    Scrollview.frame=CGRectMake(0,50,490,68);
    [Scrollview setContentSize:CGSizeMake(650,78)];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)ActionBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
