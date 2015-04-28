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
#import "OrderSummaryReusableView.h"
#import "ModelProduct.h"
#import "CredentialManager.h"


@interface OrderdetailViewController ()

@end

NSArray * arrayProducts;
CGRect frameForReusableView;

@implementation OrderdetailViewController
@synthesize viewProductTable,viewTotals;

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
    
    
    _labelShippingRate.text= _labelSubTotal.text=_labelTotal.text=@"0";
    
    //[self addProductsDataToMainViewWithArray:arrayProducts];
    
    [self fetchOrderSummery];
}


-(void)fetchOrderSummery
{
    
    
    NSDictionary * userDetails = [CredentialManager FetchCredentailsSavedOffline];
    
    NSString * userId = [userDetails valueForKey:@"UserId"];
    
    
    NSString * PostString = [NSString stringWithFormat:@"customer_id=%@&lan=%@",userId,appLanguage];
    
    
     BinSystemsServerConnectionHandler * AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_getcustomerkart PostData:PostString];
    
    
    [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST":^(NSDictionary *JSONDict) {
        
        
        NSDictionary * Result1 = JSONDict;
        
        
        
        if (Result1) {
            
            NSString * status = [Result1 valueForKey:@"status"];
            
            
            if ([status isEqualToString:@"Success"]) {
                
                
                
                
                NSArray * jsonArray = [JSONDict valueForKey:@"data"];
                
                
                arrayProducts    =   [[ProductOrganizer convertServerArrayToModelProductArray:jsonArray] mutableCopy];
                
                
                
                [self addProductsDataToMainViewWithArray:arrayProducts];
            }
            
            
        }
        
        
        
        
        
    } FailBlock:^(NSString *Error) {
        
        
        
        NSLog(@"error");
        
        
        [InterfaceManager DisplayAlertWithMessage:@"Connection Lost"];
        
        
        
        
        
        
    }];
    

    
    
    
    
    
}
-(void) addProductsDataToMainViewWithArray :(NSArray *) productList
{
    float reusableViewHeight = 100;
    
    float viewProductTableHeight = productList.count * reusableViewHeight;
    
    NSString *totalPrice =  [self getTotalPrice];
    
    frameForReusableView = CGRectMake(0, 0, viewProductTable.frame.size.width, reusableViewHeight);
    
    
    
    
    for (ModelProduct *item in productList) {
        
       
        
        OrderSummaryReusableView * osrView = [[OrderSummaryReusableView alloc]initWithFrame:frameForReusableView];
        
        
        
        [viewProductTable addSubview:osrView];
        
        frameForReusableView.origin.y = frameForReusableView.origin.y+reusableViewHeight;
        
        
        
    }
    
    _labelSubTotal.text = totalPrice;
    _labelShippingRate.text = 0;
    _labelTotal.text = totalPrice;
    
    
    viewProductTable.frame = CGRectMake(viewProductTable.frame.origin.x, viewProductTable.frame.origin.y, viewProductTable.frame.size.width, viewProductTableHeight);
    
    
    NSLog(@"%@",NSStringFromCGRect(viewTotals.frame));
    
    
    CGRect frameViewTotal = viewTotals.frame;
    
   
    
    frameViewTotal.origin.y = viewProductTable.frame.origin.y + viewProductTable.frame.size.height + 10 ;
    
    
    viewTotals.frame = frameViewTotal;
    
    
     NSLog(@"%@",NSStringFromCGRect(frameViewTotal));
    
    
    
    _scrollViewMain.contentSize =CGSizeMake(_scrollViewMain.frame.size.width, viewTotals.frame.origin.y+viewTotals.frame.size.height+20);
}
-(NSString*) getTotalPrice
{
    double total=0;
    
    for (ModelProduct * product in arrayProducts) {
        
        total = total + [product.productPrice doubleValue];
        
    }
    
    NSLog(@"Total = %f", total);
    return [NSString stringWithFormat:@"QR %0.2f",total];
    
}

- (IBAction)actionBack:(id)sender {
    
    [self.presentingViewController dismissViewControllerAnimated:self.presentedViewController completion:nil];
    
    
    
}
@end
