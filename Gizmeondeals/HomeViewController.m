//
//  DEMOHomeViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "HomeViewController.h"
#import "DealstableviewcellTableViewCell.h"
#import "DefineServerLinks.h"
#import "MenuViewController.h"
#import "ModelProduct.h"
#import "InterfaceManager.h"
#import "ModelAddHorseGlobalVariable.h"

#import "DealsbycategoryViewController.h"
#import "RightmenuView.h"
#import "ProductViewController.h"
#import "MoreViewController.h"
#import "TabBarController.h"
#import "LeftMenuViewController.h"
#import "AppGlobalVariables.h"


@interface HomeViewController (){
    
    NSMutableArray *arrayMyDeals,*arrayRecentDeals;
    CGRect ScrollviewDefaultFrame;
    CGSize scrollViewDefaultSize;
    CGPoint scrollOffset;
    
   
    
    int selectedButtonIndex;
    
    NSMutableArray *Jsonarray;
    
    
   
}

@end

@implementation HomeViewController
@synthesize AuthenticationServer,FeederUserObject,Scrollview,collectionViewRecentDeals,collectionViewMyDeals,bgview,viewMyDeals,viewRecentdeals;



-(void)viewDidLoad{
    
    [super viewDidLoad];
    
   
    
    viewRecentdeals.layer.cornerRadius = 5;
    viewRecentdeals.layer.masksToBounds = YES;
    viewMyDeals.layer.cornerRadius = 5;
    viewMyDeals.layer.masksToBounds = YES;
    [self loadContentsToView];
    
  //  int screenHeight=[[UIScreen mainScreen]bounds].size.height;
    
    
    
    bgview.backgroundColor=[UIColor orangeColor];

    scrollViewDefaultSize = CGSizeMake(Scrollview.frame.size.width, Scrollview.frame.size.height+130);
    //int x= self .tabBarController.tabBar.frame.size.height;
    
   // ScrollviewDefaultFrame = CGRectMake(Scrollview.frame.origin.x, Scrollview.frame.origin.y, Scrollview.frame.size.width,screenHeight-Scrollview.frame.origin.y-self.tabBarController.tabBar.frame.size.height);
    
    [Scrollview  setContentSize:scrollViewDefaultSize];
    
    
    collectionViewRecentDeals.dataSource=self;
    collectionViewRecentDeals.delegate=self;
    
    collectionViewMyDeals.dataSource=self;
    collectionViewMyDeals.delegate=self;
    
    
    
    
    collectionViewMyDeals.layer.borderColor = [UIColor redColor].CGColor;
    
    collectionViewMyDeals.layer.cornerRadius = 10.0;
    collectionViewRecentDeals.layer.cornerRadius = 10.0;
    
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    anim.fromValue = (id)[UIColor clearColor].CGColor;
    anim.toValue = (id)[UIColor lightGrayColor].CGColor;
    collectionViewRecentDeals.layer.borderColor = [UIColor lightGrayColor].CGColor;
    anim.duration = [CATransaction animationDuration];
    anim.timingFunction = [CATransaction animationTimingFunction];
    [collectionViewRecentDeals.layer addAnimation:anim forKey:@"myAnimation"];
    
    
    
    
        
    }
    




-(void)viewWillAppear:(BOOL)animated
{
    
  
}

-(void) loadContentsToView
{
    
    
    arrayRecentDeals = [[NSMutableArray alloc]init];
    
    
    NSString *PostData = [NSString stringWithFormat:@"lan=%@",@"1"];
    NSLog(@"Request: %@", PostData);
    
    
    AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_getRecentDeals PostData:PostData];
    
    
    [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST":^(NSDictionary *JSONDict) {
        
        
        
        
        
        
        NSMutableArray * Result1 = [JSONDict valueForKey:@"recentdeals"];
        
        
        
        if (Result1) {
            
            
            
            
            NSString * ErroCode;
            
            if ([ErroCode isEqualToString:@"403"] ) {
                
                NSLog(@"null result :%@",ErroCode);
            }else
            {
                
                
                Jsonarray = [JSONDict valueForKey:@"recentdeals"];
                
                for (NSDictionary * productDetails in Jsonarray) {
                    
                    ModelProduct * product = [ModelProduct new];
                    
                    product.productId= [productDetails valueForKey:@"product_id"];
                    product.productName=[productDetails valueForKey:@"name"];
                    product.productPrice=[productDetails valueForKey:@"price"];
                    product.productSpecilaprice=[productDetails valueForKey:@"special"];
                    product.productModel=[productDetails valueForKey:@"model"];
                    product.productImageUrl=[productDetails valueForKey:@"image"];
                    product.productDescription=[productDetails valueForKey:@"description"];
                    NSLog(@"description %@",product.productDescription);
                    NSLog(@"name %@",product.productName);
                    [arrayRecentDeals addObject:product];
                    
                    
                }
                
                
                [collectionViewRecentDeals reloadData];
                
                
                
                NSLog(@"%@",[JSONDict valueForKey:@"Name"]);
                
                
                
                
            }
            
            
        }
        
        
        
    } FailBlock:^(NSString *Error) {
        
        [InterfaceManager DisplayAlertWithMessage:@"Your net connection is too slow"];
        
        
    }];
    
    arrayMyDeals = [[NSMutableArray alloc]init];
    
    
    NSString *PostData2 = [NSString stringWithFormat:@"lan=%@",@"1"];
    NSLog(@"Request: %@", PostData2);
    
    
    AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_getRecentDeals PostData:PostData2];
    
    
    [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST":^(NSDictionary *JSONDict) {
        
        
        
    
        
        
        NSMutableArray * Result1 = [JSONDict valueForKey:@"recentdeals"];
        
        
        
        if (Result1) {
            
            
            
            
            NSString * ErroCode;
            
            if ([ErroCode isEqualToString:@"403"] ) {
                
                
            }else
            {
                
                
                NSArray * jsonArray = [JSONDict valueForKey:@"recentdeals"];
                
                for (NSDictionary * productDetails in jsonArray) {
                    
                    ModelProduct * product = [ModelProduct new];
                    
                    product.productId= [productDetails valueForKey:@"product_id"];
                    product.productName=[productDetails valueForKey:@"name"];
                    product.productPrice=[productDetails valueForKey:@"price"];
                    product.productModel=[productDetails valueForKey:@"model"];
                    product.productImageUrl=[productDetails valueForKey:@"image"];
                    product.productDescription=[productDetails valueForKey:@"description"];
                    product.productSpecilaprice=[productDetails valueForKey:@"special"];
                    product.productQuantity=[productDetails valueForKey:@"quantity"];
                   // NSLog(@"description %@",product.productDescription);
                    
                    [arrayMyDeals addObject:product];
                    
                    
                }
                
                
                [collectionViewMyDeals reloadData];
                
                
                
                NSLog(@"%@",[JSONDict valueForKey:@"Name"]);
                
                
                
                
            }
            
            
        }
        
        
        
    } FailBlock:^(NSString *Error) {
        
        [InterfaceManager DisplayAlertWithMessage:@"Your net connection is too slow"];
        
        
    }];

}


#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return NO;
}

#pragma Mark- Collection View Delegates *****************


-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
     if (collectionView.tag == 100) {
         
   return arrayRecentDeals.count;
     
     }else{
     
         return arrayMyDeals.count;
         
     }
}
-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView.tag == 100) {
        
        UICollectionViewCell *cellForRecentDeals = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCellRecentDeals" forIndexPath:indexPath];
        
        
        cellForRecentDeals.layer.borderColor = [UIColor blackColor].CGColor;
        
        
        
        
        
        ModelProduct *productDetails = [ModelProduct new];
        productDetails=[arrayRecentDeals objectAtIndex:indexPath.item];
        
        UIImageView *imageViewProductImage = (UIImageView *)[cellForRecentDeals viewWithTag:101 ];
        
        UILabel * labelProductName = (UILabel *)[cellForRecentDeals viewWithTag:102];
        UILabel * labelProductPrice = (UILabel *)[cellForRecentDeals viewWithTag:103];
        
        
        labelProductName.text = productDetails.productName;
        labelProductPrice.text =[NSString stringWithFormat:@"%.2f",[productDetails.productPrice floatValue]];//productDetails.productPrice;
        
        if (productDetails.productImage==nil) {
            
            imageViewProductImage.image = [UIImage imageNamed:@""];
            //Pending
            
           // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                
                ModelProduct * tempProduct = [arrayRecentDeals objectAtIndex:indexPath.item];
                
                NSURL * imgUrl =[NSURL URLWithString:[@"http://talenweave.com/qatardeals2/image/" stringByAppendingString:productDetails.productImageUrl]];
                
                NSData *downloadedData = [NSData dataWithContentsOfURL:imgUrl];
                
                tempProduct.productImage = [UIImage imageWithData:downloadedData];
                
                [arrayRecentDeals replaceObjectAtIndex:indexPath.item withObject:tempProduct];
                
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                //    NSData *imgData=[dictionaryImageDataModel valueForKey:@"imageData"];
                     ModelProduct * tempProduct = [arrayRecentDeals objectAtIndex:indexPath.item];
                    
                    if (tempProduct.productImage != nil) {
                        
                        
                       imageViewProductImage.image = tempProduct.productImage;
                        
                    }
                    
                   
                    
                });
                
                
                
            

            
            
            
        }else{
            
            imageViewProductImage.image = productDetails.productImage;
            
            
            
            
        }
        
        
        
        return cellForRecentDeals;
    }
    else
    {
        
        UICollectionViewCell *cellForMyDeals = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCellRecentDeals" forIndexPath:indexPath];
        
        ModelProduct *productDetails = [ModelProduct new];
        productDetails=[arrayMyDeals objectAtIndex:indexPath.item];

        
        UIImageView *imageViewProductImage = (UIImageView *)[cellForMyDeals viewWithTag:201];
        UILabel * labelProductName = (UILabel *)[cellForMyDeals viewWithTag:202];
        UILabel * labelProductPrice = (UILabel *)[cellForMyDeals viewWithTag:203];
        
        
        labelProductName.text = productDetails.productName;
        labelProductPrice.text =[NSString stringWithFormat:@"%.2f",[productDetails.productPrice floatValue]];
        
        if (productDetails.productImage==nil) {
            
            imageViewProductImage.image = [UIImage imageNamed:@""];
           
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                
                ModelProduct * tempProduct = [arrayMyDeals objectAtIndex:indexPath.item];
                
                NSURL * imgUrl =[NSURL URLWithString:[kServerPreImageUrl stringByAppendingString:productDetails.productImageUrl]];
                
                NSData *downloadedData = [NSData dataWithContentsOfURL:imgUrl];
                
                tempProduct.productImage = [UIImage imageWithData:downloadedData];
                
                [arrayMyDeals replaceObjectAtIndex:indexPath.item withObject:tempProduct];
                
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    //    NSData *imgData=[dictionaryImageDataModel valueForKey:@"imageData"];
                    ModelProduct * tempProduct = [arrayMyDeals objectAtIndex:indexPath.item];
                    
                    if (tempProduct.productImage != nil) {
                        
                        
                        imageViewProductImage.image = tempProduct.productImage;
                        
                    }
                    
                   
                    
                });
                
                
                
            });
        }else{
                
                imageViewProductImage.image = productDetails.productImage;
            
            }
        
        return cellForMyDeals;
        
        
    }
    
    
    
    
}

- (IBAction)showMenu
{
    // Dismiss keyboard (optional)
    //
 /*   ModelAddHorseGlobalVariable *horseDetails=[ModelAddHorseGlobalVariable getInstance];
    
    horseDetails.isFromRight = NO;
*/
    
    }

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
   
    
    if (collectionView == collectionViewRecentDeals) {
        ProductViewController *viewproductVCobj = [self.storyboard instantiateViewControllerWithIdentifier:@"productview"];
        
        
        
        viewproductVCobj.thisProduct = [arrayRecentDeals objectAtIndex:indexPath.item];
        
        
        
        [self.navigationController pushViewController:viewproductVCobj animated:YES];
        
    }
    if (collectionView == collectionViewMyDeals) {
        
        ProductViewController *viewproductVCobj = [self.storyboard instantiateViewControllerWithIdentifier:@"productview"];
        
        
        
        viewproductVCobj.thisProduct = [arrayMyDeals objectAtIndex:indexPath.item];
        
        
        
        [self.navigationController pushViewController:viewproductVCobj animated:YES];
        

        
    }
    
    
    
}






/*(- (IBAction)ButtonActionmoreIcon:(id)sender {
    
    MoreViewController *MoreVCobj = [self.storyboard instantiateViewControllerWithIdentifier:@"moreview"];
    
    
    
    [self.navigationController pushViewController:MoreVCobj animated:NO];
    
}*/

@end
