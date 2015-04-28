//
//  MoreViewController.m
//  Gizmeondeals
//
//  Created by Roy Leela Electronics on 02/02/15.
//  Copyright (c) 2015 Roy Leela Electronics. All rights reserved.
//

#import "MoreViewController.h"


#import "ContactsViewController.h"
#import "LoginViewController.h"
#import "MyordersViewController.h"
#import "KLCPopup.h"
#import "ViewSelectCountryNLanguage.h"
#import "AppGlobalVariables.h"
#import "BinSystemsAppManager.h"
#import "DefineServerLinks.h"
#import "InterfaceManager.h"
#import "DefineMainValues.h"

@interface MoreViewController ()
{
    
    NSArray * arrayCountryList;
    NSArray * arrayLanguageList;
    KLCPopup * popupCountry;
}

@end

@implementation MoreViewController

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
    
  // self.navigationController.navigationBar.hidden=NO;

   
    // Do any additional setup after loading the view.
    
    
    
    [self fetchCountryLIst];
    
    NSDictionary * English = @{@"name":@"English",@"code":@"1"};
    NSDictionary * Arabic = @{@"name":@"Arabic",@"code":@"2"};
    
    
    arrayLanguageList = [NSArray arrayWithObjects:English,Arabic, nil];
    
    NSString * lan = (NSString*) appLanguage;
    
    if ([lan isEqualToString:@"2"] ) {
        
        _labelSelectedLanguage.text = @"Arabic";
    }else{
        
        
        _labelSelectedLanguage.text = @"English";
    }
    
   
    
}
-(IBAction)ButtonInformation:(id)sender{
    
    MyordersViewController *myordervCobj  =   [self.storyboard instantiateViewControllerWithIdentifier:@"informationview"];
    
    
    [self presentViewController:myordervCobj animated:YES completion:nil];
    
}

-(IBAction)ButtonContactUs:(id)sender{
    
    MyordersViewController *myordervCobj  =   [self.storyboard instantiateViewControllerWithIdentifier:@"contactusview"];
    
    
    [self presentViewController:myordervCobj animated:YES completion:nil];
    
}




- (IBAction)Buttonmyorders:(id)sender {
    
    MyordersViewController *myordervCobj  =   [self.storyboard instantiateViewControllerWithIdentifier:@"myorderview"];
    
    
    [self presentViewController:myordervCobj animated:YES completion:nil];
    
    
}
-(void) fetchCountryLIst
{
  
    arrayCountryList = [[AppGlobalVariables sharedInstance].arrayCountryList copy];
    
    if (arrayCountryList.count == 0) {
     
        BinSystemsServerConnectionHandler * AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_getCountryList PostData:nil];
        
        
        [AuthenticationServer StartServerConnectionWithCompletionHandler:@"GET":^(NSDictionary *JSONDict) {
            
            
            
            
            NSString * status = [JSONDict valueForKey:@"status"];
            
            if ([status isEqualToString:@"Success"]) {
                
                arrayCountryList = [JSONDict valueForKey:@"data"];
                
                [AppGlobalVariables sharedInstance].arrayCountryList = arrayCountryList;
                
                
                
            }else{
                
               
                
            }
            
            
            
        } FailBlock:^(NSString *Error) {
            
            NSLog(@"error");
            
            
            
            
        }];
        
        
    }
    
    
}
-(void) fetchLanguageList
{
    
    
    
    
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

- (IBAction)ActionSelectCountry:(id)sender {
    
    
    if (arrayCountryList.count>0) {
        
        
        
        ViewSelectCountryNLanguage * viewCountryList = [[ViewSelectCountryNLanguage alloc]init];
       // viewCountryList.frame = CGRectMake(0, 0, 200, 300);
        
        
        viewCountryList.arrayTableContents = arrayCountryList;
       
        viewCountryList.delegate=self;
        
        [viewCountryList setTitle:@"Select Country"];
        
         popupCountry = [KLCPopup popupWithContentView:viewCountryList];
        
   
       
        [popupCountry show];
        
        
[viewCountryList reloadTable];
        
        
    }else{
        
        
        [InterfaceManager DisplayAlertWithMessage:@"Debugmsg:Country List Not Found"];
    }
    
    
    
    
}

- (IBAction)ActionSelectLanguage:(id)sender {
    
    
    
        
        ViewSelectCountryNLanguage * viewCountryList = [[ViewSelectCountryNLanguage alloc]init];
        // viewCountryList.frame = CGRectMake(0, 0, 200, 300);
        
        
        viewCountryList.arrayTableContents = arrayLanguageList;
        
        viewCountryList.delegate=self;
        
        [viewCountryList setTitle:@"Select Language"];
        
        popupCountry = [KLCPopup popupWithContentView:viewCountryList];
        
        
        
        [popupCountry show];
        
        
        [viewCountryList reloadTable];
        
        
   
    
    
}

-(void) popupView:(id)sender getValueFromList:(NSDictionary *)selectedValue
{
    
    
    [popupCountry dismiss:YES];
    
    sender = (ViewSelectCountryNLanguage*)sender;
    
    if ([[sender getTitle] isEqualToString:@"Select Country"]) {
        
        _labelSelectedCountry.text = [selectedValue valueForKey:@"name"];
        
    }else if ([[sender getTitle] isEqualToString:@"Select Language"]){
        
        
        _labelSelectedLanguage.text = [selectedValue valueForKey:@"name"];
        
        
        NSUserDefaults * pref = [NSUserDefaults standardUserDefaults];
        
      
        
        [pref setObject:[selectedValue valueForKey:@"code"] forKey:@"selectedLanguage"];

        
        
    }
    
    
    
    
    
}
@end
