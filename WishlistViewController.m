//
//  WishlistViewController.m
//  Gizmeondeals
//
//  Created by Roy Leela Electronics on 02/02/15.
//  Copyright (c) 2015 Roy Leela Electronics. All rights reserved.
//

#import "WishlistViewController.h"
#import "ModelProduct.h"
#import "ProductViewController.h"
#import "CredentialManager.h"
#import "BinSystemsServerConnectionHandler.h"
#import "DefineServerLinks.h"
#import "ProductOrganizer.h"

@interface WishlistViewController ()
{
    
    NSMutableArray *arrayPopultateTable;
}
@end
@implementation WishlistViewController
@synthesize tableViewWishList;
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
        
        [self loadCartOnline];
        
    }else{
        [self loadCartOffline];
        
        
    }

    
}
-(void) loadCartOnline
{
    NSDictionary * userDetails = [CredentialManager FetchCredentailsSavedOffline];
    
    NSString * userId = [userDetails valueForKey:@"UserId"];

    
    NSString * PostString = [NSString stringWithFormat:@"customer_id=%@&lan=%@",userId,@"1"];
    
    
    
    BinSystemsServerConnectionHandler *AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_getWishList PostData:PostString];
    
    
    
    //specify method in first argument
    
    [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST" :^(NSDictionary *JSONDict) {
        
        
        
        NSDictionary *data = JSONDict;
        
        NSString * status = [data valueForKey:@"status"];
        if ([status isEqualToString:@"Success"]) {
            
            NSArray * arrayProducts = [data valueForKey:@"data"];
            
            
          arrayPopultateTable =  [[ProductOrganizer convertServerArrayToModelProductArray:arrayProducts] copy];
                      
            [tableViewWishList reloadData];
        }
        
        
        
        
        
        
    } FailBlock:^(NSString *Error) {
        
        
        
        [InterfaceManager DisplayAlertWithMessage:@"Failed to load"];
        
        
        
        
        
    }];
    

    
    
}
-(void) loadCartOffline
{
     NSString * key =@"WishListItems";
    
    arrayPopultateTable = [ProductOrganizer loadArrayFromUserDefaultsWithKey:key];
    
    if (arrayPopultateTable) {
        
        
        //ANythig????
        
        
        [tableViewWishList reloadData];
        
        
    }else{
        
        
        tableViewWishList.hidden=YES;
        
        [InterfaceManager DisplayAlertWithMessage:@"No items to display"];
        
    }
    
}




//***************************************  Delegates   *************************************************//


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    UITableViewCell *cellForHorseList= [tableView dequeueReusableCellWithIdentifier:@"HorseList" forIndexPath:indexPath];
    
       
    
    ModelProduct * productObj =  [arrayPopultateTable objectAtIndex:indexPath.row];
    if ([indexPath row]<arrayPopultateTable.count) {
        
        UILabel * labelName = (UILabel*) [cellForHorseList viewWithTag:101];
        UILabel * labelPrice = (UILabel*) [cellForHorseList viewWithTag:102];
        UIImageView * imageViewPreview = (UIImageView*) [cellForHorseList viewWithTag:103];
        
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
        
        
        
        
        
        
        return cellForHorseList;
        
    }
       
    
    return nil;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayPopultateTable.count;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductViewController *viewproductVCobj = [self.storyboard instantiateViewControllerWithIdentifier:@"productview"];
    
    
    viewproductVCobj.thisProduct = [arrayPopultateTable objectAtIndex:indexPath.item];
    
    
    [self.navigationController pushViewController:viewproductVCobj animated:NO];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)actionDeleteRow:(UIButton*)sender {
    
    
    CGRect buttonFrame = [sender convertRect:sender.bounds toView:tableViewWishList];
    NSIndexPath *indexPath =  [tableViewWishList indexPathForRowAtPoint:buttonFrame.origin];
    
    
    [self removeWishListItemAtIndexPath:indexPath];
}
-(void) removeWishListItemAtIndexPath :(NSIndexPath*) indexPath
{
    
    ModelProduct * p = [arrayPopultateTable objectAtIndex:indexPath.row];
    
    NSString * pid = p.productId;
    
    
    if (![CredentialManager FetchCredentailsSavedOffline]) {
        
        //guest user
        
        NSString * keyCart =@"WishListItems";
        NSMutableArray * WishListItems = [ProductOrganizer loadArrayFromUserDefaultsWithKey:keyCart];
        
        [WishListItems removeObjectAtIndex:indexPath.row];
        
        [ProductOrganizer saveCustomArrayToUserDefaults:WishListItems withKey:keyCart];
        
        arrayPopultateTable = [WishListItems copy];
        
        [tableViewWishList reloadData];
        
    }else{
        
        
        
        NSString * userId = [CredentialManager FetchCredentailsSavedOffline][@"UserId"];
        
        
        NSString * PostString = [NSString stringWithFormat:@"profile_id=%@&product_id=%@",userId,pid];
        
        
      BinSystemsServerConnectionHandler * AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_removeWishListItem PostData:PostString];
        
        
        [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST":^(NSDictionary *JSONDict) {
            
            
            NSDictionary * Result1 = JSONDict;
            
            
            
            if (Result1) {
                
                NSString * msg = [Result1 valueForKey:@"status"];
                
                
                if ([msg isEqualToString:@"Success"]) {
                    
                    
                    
                    
                    [arrayPopultateTable removeObjectAtIndex:indexPath.row];
                    
                    
                    [tableViewWishList reloadData];
                    
                    
                }
                
                
            }
            
            
            
        } FailBlock:^(NSString *Error) {
            
            
            [InterfaceManager DisplayAlertWithMessage:Error];
            
        }];
        
        
        
        
        
        
        
    }
  
    
    
    
    
}
@end
