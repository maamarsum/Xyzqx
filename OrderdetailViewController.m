//
//  OrderdetailViewController.m
//  Gizmeondeals
//
//  Created by Roy Leela Electronics on 09/02/15.
//  Copyright (c) 2015 Roy Leela Electronics. All rights reserved.
//

#import "OrderdetailViewController.h"
#import "BinSystemsServerConnectionHandler.h"
#import "InterfaceManager.h"
#import "DefineMainValues.h"
#import "DefineServerLinks.h"
#import "ProductOrganizer.h"

@interface OrderdetailViewController ()

@end

NSArray * arrayProducts;
CGRect frameForNextView;

@implementation OrderdetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)fetchOrderSummery
{
    
    
    NSString *PostData = [NSString stringWithFormat:@"lan=%@",appLanguage];
    NSLog(@"Request: %@", PostData);
    
    
    BinSystemsServerConnectionHandler * AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_getcustomerkart PostData:PostData];
    
    
    [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST":^(NSDictionary *JSONDict) {
        
        
        
        
        
        NSString * status = [JSONDict valueForKey:@"status"];
        
        
        
        if ([status isEqualToString:@"Success"]) {
            
            
            
            NSArray * jsonArray = [JSONDict valueForKey:@"data"];
            
            
            arrayProducts    =   [[ProductOrganizer convertServerArrayToModelProductArray:jsonArray] mutableCopy];
            

            
            
            
            
            
            
            
        }else{
            
            
            
            
            
            
            
        }
        
        
        
        
        
        
        
    } FailBlock:^(NSString *Error) {
        
        
        
        NSLog(@"error");
        
        
        [InterfaceManager DisplayAlertWithMessage:@"Connection Lost"];
        
        
        
        
        
        
    }];
    

    
    
    
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
