//
//  KartViewController.m
//  qatardeals
//
//  Created by MAAMARSUM on 1/11/15.
//  Copyright (c) 2015 Roman Efimov. All rights reserved.
//

#import "CartViewController.h"
#import "DefineMainValues.h"
#import "DefineServerLinks.h"

#import "ModelProduct.h"
#import "InterfaceManager.h"

#import "ProductViewController.h"
#import "ProductOrganizer.h"
#import "CredentialManager.h"
#import "ContactsViewController.h"
#import "LoginViewController.h"

@interface CartViewController (){
    
   
    NSMutableArray *arrayPopulateTable;
    
    
}

@end

@implementation CartViewController
@synthesize AuthenticationServer,tableViewCartList;


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



-(void)viewWillAppear:(BOOL)animated
{
    
    if ([CredentialManager FetchCredentailsSavedOffline]) {
        
        
        [self loadCartFromServer];
    }else{
    
    [self loadCartOffline];
    }

}
-(void) loadCartOffline
{
    NSString * key =@"CartItems";
    
    arrayPopulateTable = [ProductOrganizer loadArrayFromUserDefaultsWithKey:key];
    
    if (arrayPopulateTable) {
        
        
        [tableViewCartList reloadData];
        
        
    }else{
        
        
        tableViewCartList.hidden=YES;
        
        [InterfaceManager DisplayAlertWithMessage:@"No items to display"];
        
    }
    
}
-(void) loadCartFromServer
{
    
    arrayPopulateTable = [[NSMutableArray alloc]init];
    
    
    NSDictionary * userDetails = [CredentialManager FetchCredentailsSavedOffline];
    
    NSString * userId = [userDetails valueForKey:@"UserId"];
    
    
    NSString * PostString = [NSString stringWithFormat:@"customer_id=%@&lan=%@",userId,@"1"];
    
    
    AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_getcustomerkart PostData:PostString];
    
    
    [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST":^(NSDictionary *JSONDict) {
        
        
        NSDictionary * Result1 = JSONDict;
        
        
        
        if (Result1) {
            
            NSString * status = [Result1 valueForKey:@"status"];
            
            
            if ([status isEqualToString:@"Success"]) {
                
                
            
            
                NSArray * jsonArray = [JSONDict valueForKey:@"data"];
                
                
                arrayPopulateTable    =   [[ProductOrganizer convertServerArrayToModelProductArray:jsonArray] mutableCopy];
                
                
                [tableViewCartList reloadData];
                
                
                
                NSLog(@"%@",[JSONDict valueForKey:@"Name"]);
                
            }
            
            
        }
        
        
        
    } FailBlock:^(NSString *Error) {
        
        
        [InterfaceManager DisplayAlertWithMessage:Error];
        
    }];

    
    
}



//***************************************  Delegates   *************************************************//


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
  //
    
    if (indexPath.row < arrayPopulateTable.count) {
        
        UITableViewCell *cellForProductList= [tableView dequeueReusableCellWithIdentifier:@"cartList" forIndexPath:indexPath];

         ModelProduct * productObj =  [arrayPopulateTable objectAtIndex:indexPath.row];
        UILabel * labelName = (UILabel*) [cellForProductList viewWithTag:101];
        UILabel * labelPrice = (UILabel*) [cellForProductList viewWithTag:102];
        UIImageView * imageViewPreview = (UIImageView*) [cellForProductList viewWithTag:103];
        
        labelName.text= productObj.productName;
        labelPrice.text = productObj.productPrice;
        
        if (!productObj.productThumbImage) {
            
            
            imageViewPreview.image = [UIImage imageNamed:@"Men_at_work.png"];
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                
                [ProductOrganizer setThumbImageForProduct:productObj];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    imageViewPreview.image = productObj.productThumbImage;
                    
                    
                });
                
                
                
            });
        }else{
            
            imageViewPreview.image = productObj.productThumbImage;
            
        }
        
        return cellForProductList;
        
        
    }
    else
        
    {
        
        UITableViewCell *cellForLastCell = [tableView dequeueReusableCellWithIdentifier:@"ListLastCell" forIndexPath:indexPath];
        
        UILabel * labelTotalPrice = (UILabel*)[cellForLastCell viewWithTag:201];
        
        labelTotalPrice.text= [self getTotalPrice];
        
        
        return cellForLastCell;
        
    }
    
    
    return nil;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (arrayPopulateTable.count) {
        
        
    
    ProductViewController *viewproductVCobj = [self.storyboard instantiateViewControllerWithIdentifier:@"productview"];
    
    
    viewproductVCobj.thisProduct = [arrayPopulateTable objectAtIndex:indexPath.item];
    
    
    [self.navigationController pushViewController:viewproductVCobj animated:NO];
        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (arrayPopulateTable.count == 0) {
        
       
        
        return 0;
    }
    
    return (arrayPopulateTable.count)+1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (indexPath.row<arrayPopulateTable.count) {
        return 150;
    }else
        return 40;
    
    
}

-(NSString*) getTotalPrice
{
    double total=0;
    
    for (ModelProduct * product in arrayPopulateTable) {
        
        total = total + [product.productPrice doubleValue];
        
    }
    return [NSString stringWithFormat:@"Total Price= %f QR",total];
    
}
-(void) removeCartItemAtIndexPath :(NSIndexPath*) indexPath
{
    
    ModelProduct * p = [arrayPopulateTable objectAtIndex:indexPath.row];
    
    NSString * pid = p.productId;
    
    
    if (![CredentialManager FetchCredentailsSavedOffline]) {
        
        //guest user
        
        NSString * keyCart =@"CartItems";
        NSMutableArray * addToCartItems = [ProductOrganizer loadArrayFromUserDefaultsWithKey:keyCart];
        
        [addToCartItems removeObjectAtIndex:indexPath.row];
        
        [ProductOrganizer saveCustomArrayToUserDefaults:addToCartItems withKey:keyCart];

        [tableViewCartList reloadData];
        
    }else{
        
        
    
    NSString * userId = [CredentialManager FetchCredentailsSavedOffline][@"UserId"];
    
    
    NSString * PostString = [NSString stringWithFormat:@"profile_id=%@&product_id=%@",userId,pid];

    
    AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_removeCartItem PostData:PostString];
    
    
    [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST":^(NSDictionary *JSONDict) {
        
        
        NSDictionary * Result1 = JSONDict;
        
        
        
        if (Result1) {
            
            NSString * msg = [Result1 valueForKey:@"message"];
            
            
            if ([msg isEqualToString:@"Deleted"]) {
                
                
                
                
                [arrayPopulateTable removeObjectAtIndex:indexPath.row];
                
                
                [tableViewCartList reloadData];
                
                
            }
            
            
        }
        
        
        
    } FailBlock:^(NSString *Error) {
        
        
        [InterfaceManager DisplayAlertWithMessage:Error];
        
    }];

    
    
    
    
    
    
    }
    
}
- (IBAction)actionRemoveCartItem:(UIButton*)sender {
    
    
    CGRect buttonFrame = [sender convertRect:sender.bounds toView:tableViewCartList];
    NSIndexPath *indexPath =  [tableViewCartList indexPathForRowAtPoint:buttonFrame.origin];
    
    
    [self removeCartItemAtIndexPath:indexPath];
    
}
    
    
    
    


- (IBAction)actionProceedToPay:(id)sender {
    
    
    if ([CredentialManager FetchCredentailsSavedOffline]) {
        
        
        ContactsViewController *contactsCobj  =   [self.storyboard instantiateViewControllerWithIdentifier:@"contactview"];
        
        
        [self presentViewController:contactsCobj animated:YES completion:nil];
        
    }else{
        
        LoginViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginview"];
        
        
        
        [self.navigationController presentViewController:VC animated:YES completion:nil];
        
       // didTappedBuy=true;
        
    }

    
    
    
    
}
@end
