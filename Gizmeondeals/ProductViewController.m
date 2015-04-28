//
//  ProductViewController.m
//  qatardeals
//
//  Created by Roy Leela Electronics on 30/12/14.
//  Copyright (c) 2014 Roman Efimov. All rights reserved.
//

#import "ProductViewController.h"
#import "DefineServerLinks.h"
#import "InterfaceManager.h"
#import "ContactsViewController.h"
#import "DefineMainValues.h"
#import "ModelProduct.h"
#import "MenuViewController.h"
#import "ReviewViewController.h"
#import "MyordersViewController.h"
#import "CredentialManager.h"
#import "ValidationManger.h"

#import "LoginViewController.h"
#import "SectionHeaderView.h"
#import "Section.h"
#import "AppGlobalVariables.h"
#import "ReviewTableViewCell.h"
#import "ProductOrganizer.h"



@interface ProductViewController (){
    
    
    UITapGestureRecognizer * resignKeyboard;
    UIAlertView *alrtLogin;
    NSArray *tabledata;
    NSMutableArray *reviewtabledata;
    NSMutableArray *reviewdata;
    NSMutableArray *reviewdetail;
    
    CGRect ScrollviewDefaultFrame;
    CGSize scrollViewDefaultSize;
    CGPoint scrollOffset;
    
    
    NSArray *arrayreviewProducts;
    
}

@end
#define DEFAULT_ROW_HEIGHT 78
#define HEADER_HEIGHT 45


@implementation ProductViewController
@synthesize sectionArray;
@synthesize AuthenticationServer,lbprice,lbrating,lbname,labelDescription,getproduct_id,imageViewProductImage,arrayDealsDetails,JsonArray,textViewQuantity,didTappedBuy,producttable,Scrollview,reviewtable,lbspecialprice,lbAvailability;

@synthesize textview,textfieldreviewname,ReviewView;
@synthesize expandview,textviewfield,thisProduct,textviewreview;

@synthesize buttonspecification,reviewrating;
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
    
    
    [self loaddatatotable];
    
    
    [lbname setFont:[UIFont boldSystemFontOfSize:15]];
    [lbrating setFont:[UIFont boldSystemFontOfSize:30]];
    [reviewrating setFont:[UIFont boldSystemFontOfSize:40]];
    [expandview setHidden:YES];
    [ReviewView setHidden:YES];
    self.navigationController.tabBarController.tabBar.hidden=NO;
    
    
    Scrollview.frame=CGRectMake(0,97,600,450);
    [Scrollview setContentSize:CGSizeMake(600,1000)];
    
    
    
    
    //NSTimer*   timer=[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(performTransition) userInfo:nil repeats:YES];
    
//    
//    imageViewProductImage.layer.borderWidth=2;
//    imageViewProductImage.layer.cornerRadius=2;
//    imageViewProductImage.layer.borderColor=[UIColor blackColor].CGColor;
    didTappedBuy = false;
    
    
    resignKeyboard = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    [self.view addGestureRecognizer:resignKeyboard];
    
    textViewQuantity.delegate = self;
    
    [self loadProductDetails];
    
    
}
- (IBAction)discriptionButtonAction:(id)sender{
    
    
    UIButton *button=sender;
    if (button.tag == 0) {
        [expandview setHidden:NO];
        button.tag=1;
    }else if (button.tag == 1){
        
        [expandview setHidden:YES];
        button.tag=0;
    }
    
}

- (IBAction)specificationButtonAction:(id)sender{
    
    
    UIButton *button=sender;
    if (button.tag == 0) {
        [expandview setHidden:NO];
        
        
        
        button.tag=1;
        
    }else if (button.tag == 1){
        
        [expandview setHidden:YES];
        button.tag=0;
    }
    
     
}


- (IBAction)reviewButtonAction:(id)sender{
    
    UIButton *button=sender;
    if (button.tag == 0) {
        [ReviewView setHidden:NO];
        
        
        
        button.tag=1;
        
    }else if (button.tag == 1){
        
        [ReviewView setHidden:YES];
        button.tag=0;
    }
   
    
    
}



-(void) loadProductDetails
{
    
    if (![ValidationManger validateProduct:thisProduct]) {
        
        [InterfaceManager DisplayAlertWithMessage:[NSString stringWithFormat:@"Debugmsg:This product properties contains null values , pId = %@",thisProduct.productId]];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }else{
        
        tabledata = [NSArray arrayWithObjects: thisProduct.description, thisProduct.description,
                     
                     nil];
        
        
        
        ModelProduct * product = [ModelProduct new];
        
        product = thisProduct;
        
        
        lbname.text = product.productName;
        
        lbprice.text =  [NSString stringWithFormat:@"%.2f",[product.productPrice floatValue]];
        
        lbspecialprice.text=[NSString stringWithFormat:@"%.2f",[product.productSpecilaprice floatValue]];
        
        textviewfield.text =  product.productDescription;
        
        if (product.productQuantity == 0) {
            //lbAvailability.text =  @"out of stock";
            _labelanimationarray=[[NSMutableArray alloc]initWithObjects:@"out of stock", nil];
        }
        else
        {
            _labelanimationarray=[[NSMutableArray alloc]initWithObjects:@"Available", nil];
           // [self addanimation];

        }
        
        
        
        lbrating.text =  @"****";
        reviewrating.text =  @"****";
         NSLog(@"desscription %@",product.productDescription);
        getproduct_id=product.productId;
        NSLog(@"productis %@",getproduct_id);
        NSLog(@"%@",product.productImageUrl);
        
        NSLog(@"%@",product.productImage);
        
        if (product.productImage==nil) {
            
            imageViewProductImage.image = [UIImage imageNamed:@""];
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                
                // ModelProduct * tempProduct = [JsonArray copy];
                
                
                NSURL * imgUrl =[NSURL URLWithString:[@"http://talenweave.com/qatardeals2/image/" stringByAppendingString:product.productImageUrl]];
                
                NSData *downloadedData = [NSData dataWithContentsOfURL:imgUrl];
                
                product.productImage = [UIImage imageWithData:downloadedData];
                
                
                
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    
                    
                    
                    if (product.productImage != nil) {
                        
                        
                        
                        imageViewProductImage.image = product.productImage
                        ;
                        
                    }
                    
                    
                    
                });
                
                
                
            });
            
            
            
            
        }else{
            
            
            imageViewProductImage.image = product.productImage;
        }
        
        
        
        // Do any additional setup after loading the view.
        
        
        
        
    }
    [self addanimation];
    
}
-(void)addanimation
{
    animatedindex=0;
    lbAvailability.text=[_labelanimationarray objectAtIndex:animatedindex];
    NSTimer*   timer=[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(performTransition) userInfo:nil repeats:YES];
}

-(void)performTransition{
    
    lbAvailability.text=[_labelanimationarray objectAtIndex:animatedindex];
    
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    
    
    transition.type=kCATransitionPush;
    transition.subtype=kCATransitionFade;
    
    transition.delegate = self;
    
    [lbAvailability.layer addAnimation:transition forKey:nil];
    animatedindex++;
    if (animatedindex==[_labelanimationarray count]) {
        animatedindex=0;
    }

}
    -(void)dismissKeyBoard{
        [textViewQuantity resignFirstResponder];
        [textviewreview resignFirstResponder];
        [textfieldreviewname resignFirstResponder];
        
        
    }
    
    - (IBAction)showMenu
    {
        // Dismiss keyboard (optional)
        //
        /*   ModelAddHorseGlobalVariable *horseDetails=[ModelAddHorseGlobalVariable getInstance];
         
         horseDetails.isFromRight = NO;
         */
        
        [self.view endEditing:YES];
    //    [self.frostedViewController.view endEditing:YES];
        
        
        
        // Present the view controller
        
        // self.frostedViewController.direction = REFrostedViewControllerDirectionLeft;
        
        //
        // [self.frostedViewController presentMenuViewController];
    }
    
    
    
    
    
    -(void)viewDidAppear:(BOOL)animated
    {
        [super viewDidAppear:YES];
        
        
        
        if ([CredentialManager FetchCredentailsSavedOffline] && didTappedBuy) {
            
            ContactsViewController *contactsCobj  =   [self.storyboard instantiateViewControllerWithIdentifier:@"contactview"];
            
            
            [self presentViewController:contactsCobj animated:YES completion:nil];
            
        }
        
        
        
        
    }
    - (IBAction)addtokartButtonAction:(id)sender{
        
        //    NSDictionary * credentials = [CredentialManager FetchCredentailsSavedOffline];
        //
        //    if (!credentials) {
        //
        //        LoginViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginview"];
        //
        //
        //         [self presentViewController:VC animated:YES completion:nil];
        //
        //
        //
        //    }else{
        
        
        [self addProductToCart];
        
        //}
        
    }
    
    
    - (IBAction)addtowishlistButtonAction:(id)sender{
        
        if (![CredentialManager FetchCredentailsSavedOffline]) {
            
            
        
        NSString * wishListArrayKey =@"WishListItems";
        
        NSMutableArray * arrayWishList = [self loadArrayFromUserDefaultsWithKey:wishListArrayKey];
        
        if (arrayWishList) {
            
            
            BOOL found = false;
            
            for (ModelProduct * temp in arrayWishList) {
                
                if ([temp.productId isEqualToString:thisProduct.productId]) {
                    
                    found=true;
                }
            }
            if (!found) {
                
                [arrayWishList addObject:thisProduct];
                [self saveCustomArrayToUserDefaults:arrayWishList withKey:wishListArrayKey];
                
            }else{
                
                [InterfaceManager DisplayAlertWithMessage:@"Product is already in WishList"];
            }
            
            
        }else{
            
            arrayWishList = [NSMutableArray arrayWithObject:thisProduct];
            [self saveCustomArrayToUserDefaults:arrayWishList withKey:wishListArrayKey];
            
            
        }
        
        }else{
            
            
            NSString * userId = [CredentialManager FetchCredentailsSavedOffline][@"UserId"];
            

            
           
        
     //       NSString * PostData = [NSString stringWithFormat:@"{\"customerid\":\"%@\",\"wishlist\":\"%@\",}",customer,getproduct_id];
            
            NSString * PostString = [NSString stringWithFormat:@"customerid=%@&wishlist=%@",userId,getproduct_id];
            
            AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_addtowishlist PostData:PostString];
        
        
        
        
        
        
            // specify method in first argument
        
        
            [AuthenticationServer StartServerConnectionWithCompletionHandler :@"POST":^(NSDictionary *JSONDict) {
        
        
        
                NSMutableArray * Result1 = [JSONDict valueForKey:@""];
        
        
                if (Result1) {
        
                    //  [self ShowAlertView:[NSString stringWithFormat:@"Items added to wishlist"]];
        
        
                    NSString * ErroCode;
        
                    if ([ErroCode isEqualToString:@"403"] ) {
        
        
                    }else
                    {
        
        
                        [self ShowAlertView:[NSString stringWithFormat:@"Items added to WishList"]];
        
        
                        }
        
        
                }
        
        
            } FailBlock:^(NSString *Error) {
        
                [InterfaceManager DisplayAlertWithMessage:ServerConnectioError];
        
        
            }];
        
        
    }
    
    
    
    }
    - (IBAction)Buttonbuynow:(id)sender {
        
        UIButton *button=sender;
        if (button.tag == 0) {
            [expandview setHidden:NO];
            button.tag=1;
        }else if (button.tag == 1){
            
            [expandview setHidden:YES];
            button.tag=0;
        }
        
        
        /*
        
         
         
        if ([CredentialManager FetchCredentailsSavedOffline]) {
            
            
            ContactsViewController *contactsCobj  =   [self.storyboard instantiateViewControllerWithIdentifier:@"contactview"];
            
            
            [self presentViewController:contactsCobj animated:YES completion:nil];
            
        }else{
            
            LoginViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginview"];
            
            
            
            [self.navigationController presentViewController:VC animated:YES completion:nil];
            
            didTappedBuy=true;
            
        }
        
        
        */
        
        
        // [self performSegueWithIdentifier:@"HomeToGeneralAccountInfoSegue" sender:nil];
    }
         
    
    - (IBAction)Buttonaddreview:(id)sender {
        
        
        if ([textfieldreviewname.text length] == 0){
            
            [self ShowAlertView:@"Name field is empty"];
            
            [self.textfieldreviewname becomeFirstResponder];
            
            
            
            
        }else if ([textviewreview.text length] == 0){
            
            [self ShowAlertView:@"review field is empty"];
            
            [self.textviewreview becomeFirstResponder];
            
        }
        
        
        
        
        
        else
            
        {
            
            
            NSDictionary * userDetails = [CredentialManager FetchCredentailsSavedOffline];
            
            NSString * userId = [userDetails valueForKey:@"UserId"];
            
            if (!userDetails) {
                
                
               
            }
           // NSString *customerid = @"11";
            
            NSString *rating = @"5";
            NSLog(@"%@",getproduct_id);
            NSString *reviewname=textfieldreviewname.text;
             NSString *reviewtext=textfieldreviewname.text;
            
            
            NSString *PostData= [NSString stringWithFormat:@"customer_id=%@&product_id=%@&name=%@&review=%@&rating=%@",userId,thisProduct.productId,reviewname,reviewtext,rating];
            NSLog(@"request:%@",PostData);
            
            
            
            
            
            AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_addreview PostData:PostData];
            
            
   
            
            
            // specify method in first argument
            [AuthenticationServer StartServerConnectionWithCompletionHandler :@"POST":^(NSDictionary *JSONDict) {
                
                
                
                NSMutableDictionary * Result1 = [JSONDict valueForKey:@"status"];
                NSLog(@"status %@",Result1);
                
                
                
                if (Result1) {
                    
                    NSString * status = [Result1 valueForKey:@"status"];
                    
                    if ([status isEqualToString:@"Success"])
                    {
                        
                        
                        
                        
                         [InterfaceManager DisplayAlertWithMessage:[NSString stringWithFormat:@"Message:%@",[Result1  valueForKey:@"message"]]];
                       
                    }else
                    {
                        
                       
                        [InterfaceManager DisplayAlertWithMessage:@"error in savinng"];
                        
                      
                        
                        
                        
                    }
                    
                    
                    
                }
                
                
            } FailBlock:^(NSString *Error) {
                
                [InterfaceManager DisplayAlertWithMessage:@"Internet connection  is not available connection"];
                
                
            }];
        }
        [self loaddatatotable];
    }
    
    
    
    -(void)loaddatatotable
    {
        
        
        NSString *PostData= [NSString stringWithFormat:@"productid=%@",thisProduct.productId];
        NSLog(@"request:%@",PostData);
        
        
        reviewtabledata=[[NSMutableArray alloc]init];
        
        
        AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_getreviewforproduct PostData:PostData];
        
        
       
        
        
        // specify method in first argument
        [AuthenticationServer StartServerConnectionWithCompletionHandler :@"POST":^(NSDictionary *JSONDict) {
            
            
            
            
            
                
                
            
                NSString * status = [JSONDict valueForKey:@"status"];
               
                
                if ([status isEqualToString:@"success"]) {
                    
                     // reviewtabledata = [JSONDict valueForKey:@"productdetails"];
                    
                    
                    arrayreviewProducts = [JSONDict valueForKey:@"productdetails"];
                    
                    for (NSDictionary *categorydetails in arrayreviewProducts) {
                        
                        
                        ModelProduct * product = [ModelProduct new];
                        
                        product.productReviewId= [categorydetails valueForKey:@"review_id"];
                        product.productReviewName=[categorydetails valueForKey:@"author"];
                        product.productReviewDateAndTime=[categorydetails valueForKey:@"date_added"];
                        product.productReviewRating=[categorydetails valueForKey:@"rating"];
                        product.productReviewText=[categorydetails valueForKey:@"text"];
                        NSLog(@"rating %@",product.productReviewRating);
                        [reviewtabledata addObject:product];
                  
                   // reviewtabledata =  [ProductOrganizer convertServerArrayToModelProductArray:arrayreviewProducts];
                    
                    
                  
                }
            
                    [reviewtable reloadData];
                   
                }
            
            
        } FailBlock:^(NSString *Error) {
            
            [InterfaceManager DisplayAlertWithMessage:@"Internet connection  is not available connection"];
            
            
        }];
        
        
        
    }
    
         


    -(void)ShowAlertView:(NSString*)Message{
        
        UIAlertView * Alert = [[UIAlertView alloc]initWithTitle:kApplicationName message:[NSString stringWithFormat:@"\n%@\n",Message] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        
        [Alert show];
        
        
    }
    
-(BOOL)slideNavigationControllerShouldDisplayLeftMenu{
    
    return YES;
}
-(BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    
    return NO;
}
    
#pragma mark -
#pragma mark UITableView Datasource
    
    
    
    
    
    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
    {
        
       
            
            return [reviewtabledata count];
            NSLog(@"count: %@",reviewtabledata);
       
       
        
    }

    - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
    {
        
        return 2;
    }

    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        
        
        
        
        ReviewTableViewCell * cellForReviewList= (ReviewTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"ReviewList"];
        
        if (tableView==reviewtable) {
            
            
          
            
           
            
            
           
            NSArray *tableCellArray =[[NSBundle mainBundle]loadNibNamed:@"ReviewTableViewCell" owner:self options:nil];
            
            
            
            
            if ([indexPath row]<reviewtabledata.count) {
                
                cellForReviewList=[tableCellArray objectAtIndex:0];
                
                
                ModelProduct * productdetails = [ModelProduct new];
                productdetails=[reviewtabledata objectAtIndex:indexPath.row];
                
              
                
                cellForReviewList.reviewName.text =  productdetails.productReviewName;
                NSLog(@"name %@",productdetails.productReviewName);
               
                cellForReviewList.reviewDate.text = productdetails.productReviewDateAndTime;
                cellForReviewList.reviewRating.text = productdetails.productReviewRating;
                cellForReviewList.reviewText.text = productdetails.productReviewText;
            }
        }
    
        return cellForReviewList;
    
       
    }


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView== reviewtable) {
        return 100;
    }else
        return 30;
}


    
    -(void) addProductToCart

    {
        if (textViewQuantity.text == nil) {
            
            [InterfaceManager DisplayAlertWithMessage:@"Enter Quantity"];
            
            [textViewQuantity becomeFirstResponder];
        }
        
        
        if (![CredentialManager FetchCredentailsSavedOffline]) {
            
            
            
            
        
        
        NSString * cartArrayKey =@"CartItems";
        
        NSMutableArray * arrayCart = [self loadArrayFromUserDefaultsWithKey:cartArrayKey];
        
        if (arrayCart) {
            
            
            BOOL found = false;
            
            for (ModelProduct * temp in arrayCart) {
                
                if ([temp.productId isEqualToString:thisProduct.productId]) {
                    
                    found=true;
                }
            }
            if (!found) {
                
                [arrayCart addObject:thisProduct];
                [self saveCustomArrayToUserDefaults:arrayCart withKey:cartArrayKey];
                
            }else{
                
                [InterfaceManager DisplayAlertWithMessage:@"Product is already in Cart"];
            }
            
            
        }else{
            
            arrayCart = [NSMutableArray arrayWithObject:thisProduct];
            [self saveCustomArrayToUserDefaults:arrayCart withKey:cartArrayKey];
            
            
        }
        
        
        }else{
            
            
            NSString * userId = [CredentialManager FetchCredentailsSavedOffline][@"UserId"];
            
            
            
            
            
            //       NSString * PostData = [NSString stringWithFormat:@"{\"customerid\":\"%@\",\"wishlist\":\"%@\",}",customer,getproduct_id];
            
            NSString * PostString = [NSString stringWithFormat:@"profile_id=%@&product_id=%@&quantity=%@",userId,getproduct_id,textViewQuantity.text];
            
            AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_addtokart PostData:PostString];
            
            
            
            
            
            
            // specify method in first argument
            
            
            [AuthenticationServer StartServerConnectionWithCompletionHandler :@"POST":^(NSDictionary *JSONDict) {
                
                
                
                NSMutableArray * Result1 = [JSONDict valueForKey:@""];
                
                
                if (Result1) {
                    
                    //  [self ShowAlertView:[NSString stringWithFormat:@"Items added to wishlist"]];
                    
                    
                    NSString * ErroCode;
                    
                    if ([ErroCode isEqualToString:@"403"] ) {
                        
                        
                    }else
                    {
                        
                        
                        [self ShowAlertView:[NSString stringWithFormat:@"Items added to Cart"]];
                        
                        
                    }
                    
                    
                }
                
                
            } FailBlock:^(NSString *Error) {
                
                [InterfaceManager DisplayAlertWithMessage:ServerConnectioError];
                
                
            }];
            
            
        }

        
        
        
    }
    -(void)saveCustomArrayToUserDefaults:(NSMutableArray*)obj withKey:(NSString *) key
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:obj];
        
        
        [defaults setObject:myEncodedObject forKey:key];
    }
    
    -(NSMutableArray *)loadArrayFromUserDefaultsWithKey:(NSString*)key
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *myEncodedObject = [defaults objectForKey: key];
        NSMutableArray* obj = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
        return obj;
    }
    - (IBAction)buttonActionBack:(id)sender {
        
        [self.navigationController popViewControllerAnimated:NO];
    }


-(IBAction)shareButtonAction:(id)sender {
    
    
    ModelProduct * product = [ModelProduct new];
      product = thisProduct;
    
    
   // NSString *nameToShare = product.productName;
    
    NSURL * imgUrl =[NSURL URLWithString:[@"http://talenweave.com/qatardeals2/index.php?route=product/product&product_id=" stringByAppendingString:product.productId]];
    
    NSLog(@"website %@",imgUrl);
   // NSString *priceToShare = product.productPrice;
    NSArray *itemsToShare = @[imgUrl];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll]; //or whichever you don't need
    [self presentViewController:activityVC animated:YES completion:nil];
}

    @end
