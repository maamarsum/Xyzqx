//
//  SignUpViewController.m
//  Gizmeondeals
//
//  Created by Gizmeon Technologies on 24/02/15.
//  Copyright (c) 2015 Gizmeon Technologies. All rights reserved.
//

#import "SignUpViewController.h"
#import "InterfaceManager.h"
#import "ValidationManger.h"
#import "DefineMainValues.h"
#include "AppGlobalVariables.h"

@interface SignUpViewController ()

@end

BOOL valdiated;
NSArray * arrayManditoryFields;
NSArray * arrayCountryList;
NSArray * arrayZoneList;

CGPoint screenCenterPoint;
CGPoint scrollOffset;
CGSize scrollViewDefaultContentSize;
CGRect scrollViewDefaultFrame;
KLCPopup * popupCountry;

NSString *countryID,*zoneID;

@implementation SignUpViewController
@synthesize textFieldAddress,textFieldCity,textFieldConfirmPassword,textFieldCOuntryId,textFieldEmail,textFieldFName,textFieldPassword,textFieldPINCode,textFieldSName,textFieldTelephone,textFieldAddress2,textFieldCompany,textFieldFax,textFieldRefferelName,textFieldZone;

@synthesize scrollViewMain;
@synthesize buttonCancel,buttonSubmit;

@synthesize GPassword,GUsername;

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
    arrayManditoryFields = [[NSArray alloc]initWithObjects:textFieldFName,textFieldSName,textFieldEmail,textFieldTelephone,textFieldAddress,textFieldCity,textFieldPINCode,textFieldCOuntryId,textFieldPassword,textFieldConfirmPassword,textFieldTelephone,nil];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.title=@"Sign up";
    
    textFieldTelephone.delegate=textFieldSName.delegate=textFieldPINCode.delegate=textFieldPassword.delegate=textFieldFName.delegate=textFieldEmail.delegate=textFieldCOuntryId.delegate=textFieldConfirmPassword.delegate=textFieldCity.delegate=textFieldAddress.delegate=textFieldAddress2.delegate=textFieldCompany.delegate=textFieldFax.delegate=textFieldRefferelName.delegate=textFieldZone.delegate=self;
    
    
    buttonCancel.layer.cornerRadius=buttonSubmit.layer.cornerRadius=10;
    
    arrayCountryList = [AppGlobalVariables sharedInstance].arrayCountryList;

    
    scrollViewMain.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    
   
    
    scrollViewDefaultContentSize = CGSizeMake(screenWidth, buttonCancel.frame.origin.y+buttonCancel.frame.size.height+40);
    
   
    scrollViewMain.contentSize = scrollViewDefaultContentSize;
//    
//    scrollViewMain.contentSize = self.view.frame.size;
//    scrollViewMain.frame = self.view.frame;
    
    
    
    screenCenterPoint = self.view.center;
    
    scrollViewDefaultFrame=scrollViewMain.frame;
    
    
    
    UIGestureRecognizer * gester = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:gester];

}



-(void) validateManditoryFields
    {
        
      //  [self RegisterUser];
        
        
        
        for (UIView *subView in arrayManditoryFields) {
            
            if ([subView isKindOfClass:[UITextField class]]) {
                
                UITextField *textField = (UITextField*)subView;
                
                valdiated = [ValidationManger validateTextField:textField];
                
                if (!valdiated) {
                    
                    [textField becomeFirstResponder];
                    break;
                }
                
            }else{
                
                valdiated = false;
            }
            
        }
        //email
        if (![ValidationManger validateEmail:textFieldEmail.text] && valdiated) {
            
            [InterfaceManager DisplayAlertWithMessage:@"Invalid Email"];
            [textFieldEmail becomeFirstResponder];
            
            valdiated = false;
            
        }
        if (![ValidationManger validateMobileNumber:textFieldTelephone.text] && valdiated) {
            
            [InterfaceManager DisplayAlertWithMessage:@"Invalid Phone Number"];
            
            [textFieldTelephone becomeFirstResponder];
            
            valdiated = false;
            
        }
       
        // password match
        if (![ValidationManger checkStringsAreEqual:textFieldConfirmPassword.text :textFieldPassword.text] && valdiated) {
            
            [textFieldConfirmPassword becomeFirstResponder];
            [InterfaceManager DisplayAlertWithMessage:@"Passwords Not matching"];
            valdiated = false;
        }
        

        
        
        if (valdiated) {
           
            
            [self RegisterUser];
            
        }
        
        
    }
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
   
    [textField resignFirstResponder];
    
      // [self validateManditoryFields];
    
    
    return YES;
}

#pragma Mark - Server Calls

-(void) RegisterUser
{
    
    
    if([BinSystemsAppManager internetCheck])
    {
        NSString * fName = textFieldFName.text;
        NSString * lName = textFieldSName.text;
        NSString * email = textFieldEmail.text;
        NSString * address = textFieldAddress.text;
        NSString * telephone = textFieldTelephone.text;
        NSString * countryid = countryID;
        NSString * password = textFieldPassword.text;
        NSString * postCode = textFieldPINCode.text;
        NSString * city = textFieldCity.text;
        NSString * fax =textFieldFax.text;
        NSString * referalName =@"1";
        NSString * company =@"1";
        NSString * customerGroupId =@"1";
        NSString * companyid =@"1";
        NSString * taxid =@"1";
        NSString * address2 =@"dummy";
        NSString * confirm =@"dummy";
        NSString * newsletter =@"1";
        NSString * zoneid =zoneID;
        
#warning change hard code values later

        
        NSString * PostData = [NSString stringWithFormat:@"firstname=%@&lastname=%@&email=%@&telephone=%@&city=%@&postcode=%@&country_id=%@&password=%@&confirm=%@&address_1=%@&fax=%@&referral_name=%@&company=%@&customer_group_id=%@&company_id=%@&tax_id=%@&address_2=%@&zone_id=%@&newsletter=%@&agree=%@",fName,lName,email,telephone,city,postCode,countryid,password,confirm ,address,fax,referalName,company,customerGroupId,companyid,taxid,address2,zoneid,newsletter,@""];
        
        BinSystemsServerConnectionHandler *AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_SignUp PostData:PostData];
        
        
        
        
        //specify method in first argument
        [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST":^(NSDictionary *JSONDict) {
            
            
            
            
            NSString * status = [JSONDict valueForKey:@"status"];
            
            
            
            if ([status isEqualToString:@"Failed"]) {
                
                
                [InterfaceManager DisplayAlertWithMessage:[JSONDict valueForKey:@"message"]];
                
                
                
            }else{
                

                GUsername=textFieldEmail.text;
                GPassword=textFieldPassword.text;
                
                [self AuthenticateCredentialsWithServer];
                
                
                
                
            }
            
            
            
            
        }
         
         
         
                                                               FailBlock:^(NSString *Error) {
                                                                   
                                                                   [InterfaceManager DisplayAlertWithMessage:@"Your net connection is too slow"];
                                                                   
                                                                   
                                                               }];
        
    }
    
   
}
-(void)AuthenticateCredentialsWithServer{
    
    if (GPassword && GUsername) {
        
        if([BinSystemsAppManager internetCheck])
        {
            
            NSString * PostData = [NSString stringWithFormat:@"email=%@&password=%@",GUsername,GPassword];
            
            BinSystemsServerConnectionHandler *AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_Login PostData:PostData];
            
            
            
            
            //specify method in first argument
            [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST":^(NSDictionary *JSONDict) {
                
                
                
                
                NSString * status = [JSONDict valueForKey:@"status"];
                
                
                
                if ([status isEqualToString:@"Failed"]) {
                    
                    
                    [InterfaceManager DisplayAlertWithMessage:[JSONDict valueForKey:@"message"]];
                    
                    
                    
                    
                    
                    
                    
                }else{
                    
                    NSUserDefaults * isAppRunFirsttime = [NSUserDefaults standardUserDefaults];
                    
                    [isAppRunFirsttime setObject:@"NO" forKey:@"isFirstTime"];
                    
                    [isAppRunFirsttime synchronize];

                    
                    NSString * uid = [[JSONDict valueForKey:@"data"] valueForKey:@"customer_id"];
                    NSString * token = [[JSONDict valueForKey:@"data"] valueForKey:@""];
                    
                    [CredentialManager
                     SaveCredentialsOffline:@{@"username":GUsername,@"password":GPassword,@"UserId":uid,@"Token":@"temptoken"}];
                    
                    
                    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                    
                     [InterfaceManager DisplayAlertWithMessage:@"Registration Success"];
                    
                    
                }
                
                
                
                
            }
             
             
             
                                                                   FailBlock:^(NSString *Error) {
                                                                       
                                                                       [InterfaceManager DisplayAlertWithMessage:@"Invalid Response, Login Failed"];
                                                                       
                                                                       
                                                                   }];
            
        }
        
        
    }
    
    
    
    
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    
    if (textField==textFieldCOuntryId) {
        
        [self displayPopupListWithTitle:@"Select Country" andArray:arrayCountryList];
        
        arrayZoneList = nil;
        
        return NO;
        
        
      //  [self.view endEditing:YES];
    }
    if (textField == textFieldZone) {
        
        if ([textFieldCOuntryId.text isEqualToString:@""]) {
            
            
            [self displayPopupListWithTitle:@"Select Country" andArray:arrayCountryList];
            
            
            
            
        }else{
            
            
            [self displayPopupListWithTitle:@"Select State" andArray:arrayZoneList];
            
            
            
        }
       
        return NO;
    }

    
    [self calculateScroolOffsetForTextField:textField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    return YES;
    
    
    
}
-(BOOL) textFieldShouldEndEditing:(UITextField *)textField{
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    return YES;
}

-(void) dismissKeyboard
{
    
    [self.view endEditing:YES];
    
}
- (NSInteger)getKeyBoardHeight:(NSNotification *)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    NSInteger keyboardHeight = keyboardFrameBeginRect.size.height;
    return keyboardHeight;
}

-(void) keyboardWillShow:(NSNotification*) notification
{
    NSInteger keyboardHeight;
    keyboardHeight = [self getKeyBoardHeight:notification];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        
        
        scrollViewMain.frame=CGRectMake(scrollViewMain.frame.origin.x
                                    , scrollViewMain.frame.origin.y, scrollViewMain.frame.size.width, ([[UIScreen mainScreen]bounds].size.height-keyboardHeight));
        
        
    }];
    [self.scrollViewMain setContentOffset:scrollOffset animated:YES];

    
    
    
    
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    
    scrollViewMain.frame = scrollViewDefaultFrame;
    scrollViewMain.contentSize = scrollViewDefaultContentSize;
    
    
    
    
}
-(void) calculateScroolOffsetForTextField :(UITextField *) textField
{
     scrollOffset = CGPointZero;
    
    CGRect frameTextField = textField.frame;
    
    CGPoint textFieldPostion = [textField convertPoint:textField.bounds.origin toView:nil];
    
    if (textFieldPostion.y > screenCenterPoint.y) {
        
        
        
         scrollOffset = CGPointMake(0, frameTextField.origin.y);
        
        
    }

    
}

-(void) popupView:(id)sender getValueFromList:(NSDictionary *)selectedValue
{
    
    
    [popupCountry dismiss:YES];
    
    sender = (ViewSelectCountryNLanguage*)sender;
    
    if ([[sender getTitle] isEqualToString:@"Select Country"]) {
        
        textFieldCOuntryId.text = [selectedValue valueForKey:@"name"];
        
        countryID = [selectedValue valueForKey:@"country_id"];
        
        [self fetchZoneDataWithCountryId:countryID];
        
        
        
        
    }else if ([[sender getTitle] isEqualToString:@"Select State"]){
        
        
        textFieldZone.text = [selectedValue valueForKey:@"name"];
        
        zoneID = [selectedValue valueForKey:@"country_id"];

        
    }
    
    
}

-(void) fetchZoneDataWithCountryId:(NSString*) countryId
{
    
    
    NSString *PostData = [NSString stringWithFormat:@"country_id=%@",countryId];
    NSLog(@"Request: %@", PostData);
    
    
    BinSystemsServerConnectionHandler * AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_getZoneData PostData:PostData];
    
    
    [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST":^(NSDictionary *JSONDict) {
        
        
        
        
        
        NSString * status = [JSONDict valueForKey:@"status"];
        
        
        
        if ([status isEqualToString:@"Success"]) {
            
            
            arrayZoneList = [JSONDict valueForKey:@"data"];
            
            
            [self displayPopupListWithTitle:@"Select State" andArray:arrayZoneList];
            
        }else{
            
            
            [InterfaceManager DisplayAlertWithMessage:@"Failed to load data, try again"];
            
            
            
            
        }
        
        
        
        
        
        
        
    } FailBlock:^(NSString *Error) {
        
        
        
        NSLog(@"error");
        
        
        
        
        
        
        
        
        
    }];
    

    
    
    
    
    
}
-(void) displayPopupListWithTitle :(NSString *) popupTitle andArray :(NSArray*) listItems
{
    
     [popupCountry dismiss:YES];
    
    ViewSelectCountryNLanguage * viewCountryList = [[ViewSelectCountryNLanguage alloc]init];
    // viewCountryList.frame = CGRectMake(0, 0, 200, 300);
    
    
    viewCountryList.arrayTableContents = listItems;
    
    viewCountryList.delegate=self;
    
    [viewCountryList setTitle:popupTitle];
    
    popupCountry = [KLCPopup popupWithContentView:viewCountryList];
    
    
    
    [popupCountry show];
    
    
    [viewCountryList reloadTable];
    

    
    
    
    
    
    
}
#pragma Mark - button Actions
- (IBAction)buttonActionCancel:(id)sender {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buttonActionSignUp:(id)sender {
    
    [self validateManditoryFields];
    
}
@end
