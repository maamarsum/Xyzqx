//
//  ContactsViewController.m
//  qatardeals
//
//  Created by MAAMARSUM on 1/11/15.
//  Copyright (c) 2015 Roman Efimov. All rights reserved.
//

#import "ContactsViewController.h"
#import "ProductViewController.h"
#import "BinSystemsAppManager.h"
#import "InterfaceManager.h"
#import "DefineMainValues.h"
#import "DefineServerLinks.h"
#import "CredentialManager.h"
#import "OrderdetailViewController.h"


@interface ContactsViewController ()

@end

NSDictionary *shippingDetails;

CGPoint screenCenterPoint;
CGPoint scrollOffset;
CGSize scrollViewDefaultContentSize;
CGRect scrollViewDefaultFrame;


@implementation ContactsViewController
@synthesize textFieldCity,textFieldFirstName,textFieldLastName,textFieldNumber,textAddress,textFieldEmail,textFieldPin,scrollViewMain;
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
    
    _buttonClearData.layer.cornerRadius = 5.0f;_buttonNext.layer.cornerRadius= 10.0f;
    
    textFieldPin.delegate=textFieldEmail.delegate=textAddress.delegate=textFieldFirstName.delegate=textFieldLastName.delegate=textFieldNumber.delegate=self;
    
    
    
    
    scrollViewMain.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    
    
    
    scrollViewDefaultContentSize = CGSizeMake(screenWidth, _buttonNext.frame.origin.y+_buttonNext.frame.size.height+40);
    
    
    scrollViewMain.contentSize = scrollViewDefaultContentSize;
    //
    //    scrollViewMain.contentSize = self.view.frame.size;
    //    scrollViewMain.frame = self.view.frame;
    
    
    
    screenCenterPoint = self.view.center;
    
    scrollViewDefaultFrame=scrollViewMain.frame;
    
    
    
    UIGestureRecognizer * gester = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:gester];

    
    
    
    
    
    
    
    
    [self fetchShippingAddress];
    
    
}

-(void) fetchShippingAddress
{
    
   
    NSString * uid = [CredentialManager FetchCredentailsSavedOffline][@"UserId"];
    
    NSString *PostData = [NSString stringWithFormat:@"lan=%@&customer_id=%@",appLanguage,uid];
    NSLog(@"Request: %@", PostData);
    
    
    BinSystemsServerConnectionHandler * AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_getShippingAddress PostData:PostData];
    
    
    [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST":^(NSDictionary *JSONDict) {
        
        
        
        
        
        NSString * status = [JSONDict valueForKey:@"status"];
        
        
        
        if ([status isEqualToString:@"Success"]) {
            
            NSArray * data = [JSONDict  valueForKey:@"data"];
            
            shippingDetails = [data firstObject];
            
            
            textFieldFirstName.text = [shippingDetails valueForKey:@"firstname"];
            
            textFieldLastName.text = [shippingDetails valueForKey:@"lastname"];
            
            textFieldEmail.text = [shippingDetails valueForKey:@"email"];
            textFieldCity.text = [shippingDetails valueForKey:@"zone"];
            textAddress.text = [shippingDetails valueForKey:@"address_1"];
            textFieldPin.text = [shippingDetails valueForKey:@"postcode"];
            textFieldNumber.text = [shippingDetails valueForKey:@"telephone"];
            
            
            
        }else{
            
            
            
            [InterfaceManager DisplayAlertWithMessage:@"Parse Error"];
            
            
            
        }
        
        
        
        
        
        
        
    } FailBlock:^(NSString *Error) {
        
        
        
        NSLog(@"error");
        
        
        
        [InterfaceManager DisplayAlertWithMessage:@"Connection Lost"];
        
        
        
        
        
    }];
    

    
    
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    
//    if (textField==textFieldCOuntryId) {
//        
//        [self displayPopupListWithTitle:@"Select Country" andArray:arrayCountryList];
//        
//        arrayZoneList = nil;
//        
//        return NO;
//        
//        
//        //  [self.view endEditing:YES];
//    }
//    if (textField == textFieldZone) {
//        
//        if ([textFieldCOuntryId.text isEqualToString:@""]) {
//            
//            
//            [self displayPopupListWithTitle:@"Select Country" andArray:arrayCountryList];
//            
//            
//            
//            
//        }else{
//            
//            
//            [self displayPopupListWithTitle:@"Select State" andArray:arrayZoneList];
//            
//            
//            
//        }
//        
//        return NO;
//    }
//    
    
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

- (IBAction)buttonActionBack:(id)sender {
    
    
    UINavigationController * nav = (UINavigationController*)self.presentingViewController;
    
    if ([nav.topViewController isKindOfClass:[ProductViewController class]]) {
        
        
        ProductViewController *VC = (ProductViewController*)nav.topViewController;
        
        
        VC.didTappedBuy= NO;
        
    }
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)ActionNext:(id)sender {
    
    
    OrderdetailViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"orderDetails"];
    
    
    vc.shippingDetails = shippingDetails;
    vc.arrayCartItems = self.arrayCartItems;
    
    [self presentViewController:vc animated:YES completion:nil];
    
    
}

- (IBAction)actionNewAddress:(id)sender {

textFieldNumber.text=textAddress.text=textFieldFirstName.text=textFieldLastName.text=textFieldCity.text=textFieldEmail.text=textFieldPin.text=@"";




}
@end
