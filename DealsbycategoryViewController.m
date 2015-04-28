//
//  DEMOSecondViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//
#import "DealstableviewcellTableViewCell.h"
#import "MenuViewController.h"
#import "DealsbycategoryViewController.h"
#import "MenuViewController.h"
#import "ModelAddHorseGlobalVariable.h"
#import "DefineServerLinks.h"
#import "DefineMainValues.h"


#import "Reachability.h"
#import "Reachability.h"
#import "ModelProduct.h"
#import "InterfaceManager.h"


//vc//
#import "ProductViewController.h"
#import "ModelProduct.h"
#import "ProductOrganizer.h"
#import "ValidationManger.h"



@interface DealsbycategoryViewController (){
    
    
    
    NSMutableArray * jsonarray;
    
    NSMutableArray * arrayForPopulateTable;
    
    NSArray * sortedProducts;
    NSArray * filteredProducts;
    
    NSArray * arraySortOptions;
    NSArray *arrayFilterCategories;
    NSDictionary * dictionaryFilterCategory;
    
    NSInteger selectedCategoryIndex;
    
    BOOL tablelist;
    
}
@property(nonatomic,assign) bool isConntectedToInternet;
@end

@implementation DealsbycategoryViewController
@synthesize tableViewProductList,AuthenticationServer;
@synthesize isConntectedToInternet;
@synthesize category_id;
@synthesize arraydealsDetailsRecieved;
@synthesize tableVIewSortOptions,tableFilterCategories,tableFilterFinalSelection;
@synthesize viewFilterView,viewSortView;
@synthesize collectionViewGridDetails;
@synthesize gridbutton1,gridbutton2;



- (IBAction)showMenu
{
    // Dismiss keyboard (optional)
    //  ModelAddHorseGlobalVariable *horseDetails=[ModelAddHorseGlobalVariable getInstance];
    ModelAddHorseGlobalVariable *horseDetails=[ModelAddHorseGlobalVariable getInstance];
    
    horseDetails.isFromRight = NO;
    
    
    [self.view endEditing:YES];
    
   // [self.frostedViewController.view endEditing:YES];
    
    
    
    // Present the view controller
    
   // self.frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    
    //
  //  [self.frostedViewController presentMenuViewController];
}

- (IBAction)buttonActiongridview:(id)sender {
    
    
    
   UIButton *button = sender;
        
    if (button.tag == 0) {
        [gridbutton1 setImage:[UIImage imageNamed:@"table.png"] forState:UIControlStateNormal];
        
        
        [self populategrideview];
        [collectionViewGridDetails reloadData];
        [collectionViewGridDetails setHidden:NO];
        tableViewProductList.hidden=YES;
        button.tag=1;
       
       
    }else if (button.tag == 1){
        [gridbutton1 setImage:[UIImage imageNamed:@"grid.png"] forState:UIControlStateNormal];
        
       
        [collectionViewGridDetails setHidden:YES];
        tableViewProductList.hidden=NO;
        [tableViewProductList reloadData];
        button.tag=0;
    }
    
        


    
   
    
        
        
        
    
}

- (IBAction)buttonActionSort:(id)sender {
    
        
    [viewSortView setHidden:NO];
    
}

- (IBAction)buttonActionFilter:(id)sender {
    
    viewFilterView.hidden=NO;
    
    
}

- (IBAction)cancelSortView:(id)sender {
    
    viewFilterView.hidden=YES;
    viewSortView.hidden=YES;
    
}

-(void) viewWillAppear:(BOOL)animated{
    
    
    
    
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tableViewProductList.dataSource=self;
    tableViewProductList.delegate=self;
    collectionViewGridDetails.hidden=YES;
    
    viewSortView.hidden=YES;
    
   //[gridbutton1.titleLabel setText:@"grid"];
    [gridbutton1 setImage:[UIImage imageNamed:@"grid.png"] forState:UIControlStateNormal];
    //[gridbutton2 setBackgroundImage:[UIImage imageNamed:@"table.png"] forState:UIControlStateNormal];
    
    
    arraySortOptions = [NSArray arrayWithObjects:@"Price Low to High",@"Price High to Low",nil];
    
    
    NSArray * priceRange = [NSArray arrayWithObjects:@"$1 to $100",@"$101 to &200",@"$201 to $300",@"$301 to &400",@"Above 400", nil];
    
    NSArray * brand = [NSArray arrayWithObjects:@"Band1",@"Band1",@"Band2",@"Band3", nil];
    
    NSArray * discount = [NSArray arrayWithObjects:@"Up to 10%",@"Up to 20%",@"Up to 30%",@"Up to 40%",@"Up to 50%",@"More than 50&", nil];
    
    NSArray * rating = [NSArray arrayWithObjects:@"One star",@"Two Star",@"Three Star",@"Four Star",@"Five Star", nil];
    
    
     dictionaryFilterCategory = [NSDictionary dictionaryWithObjectsAndKeys:priceRange,@"Price",brand,@"Brand",discount,@"Discount",rating,@"Rating", nil];
    
    
    
    arrayFilterCategories = [[NSArray alloc]initWithObjects:priceRange,brand,discount, nil];
    
    viewFilterView.hidden=YES;
    
    [tableFilterCategories reloadData];
    
    
    
    tableViewProductList.frame=collectionViewGridDetails.frame;
    
  //  [tableFilterFinalSelection reloadData];
    
    [self populateTable];
    
    
}

-(void)populateTable
{
        arraydealsDetailsRecieved = [[NSMutableArray alloc]init];
    
    NSString *PostData= [NSString stringWithFormat:@"categoryid=%@&lan=%@",category_id,@"1"];
    NSLog(@"request:%@",PostData);
    
    AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_dealsbycategory PostData:PostData];
        
    [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST":^(NSDictionary *JSONDict) {
        
        
        NSMutableArray * Result1 = [JSONDict valueForKey:@"DealsByCategory"];
        
        NSLog(@"Test:%@",Result1);
        
        if (Result1) {
            
          //  [self ShowAlertView:[NSString stringWithFormat:@"Items added to wishlist"]];
            
            
            NSString * ErroCode;
            
            if ([ErroCode isEqualToString:@"403"] ) {
                
                
            }else
            {
                
                
             jsonarray = [JSONDict valueForKey:@"DealsByCategory"];
                
                for (NSDictionary *categorydetails in jsonarray) {
                    
                    
                     ModelProduct * product = [ModelProduct new];
                     
                     product.productId= [categorydetails valueForKey:@"product_id"];
                     product.productName=[categorydetails valueForKey:@"name"];
                     product.productPrice=[categorydetails valueForKey:@"price"];
                     product.productModel=[categorydetails valueForKey:@"model"];
                     product.productImageUrl=[categorydetails valueForKey:@"image"];
                    
                    
                    if ([ValidationManger validateProduct:product]) {
                        
                        
                         [arraydealsDetailsRecieved addObject:product];
                    }
                     
                    
                    
                }
                
                arrayForPopulateTable = arraydealsDetailsRecieved;
                
                [tableViewProductList reloadData];
                [collectionViewGridDetails reloadData];
                
                
                
                NSLog(@"%@",[JSONDict valueForKey:@"name"]);
                
                
                
                
            }
            
            
        }
        
        
        
    } FailBlock:^(NSString *Error) {
        
        [InterfaceManager DisplayAlertWithMessage:@"Your net connection is too slow"];
        
        
    }];
   
}
   
-(void)reloadDealsWithNewCategoryId :(NSString*) categoryId{
    
    self.category_id = categoryId;
    
    [self populateTable];
    
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(tableView == tableViewProductList){
     return arrayForPopulateTable.count;
    }
    if (tableView==tableVIewSortOptions) {
        return arraySortOptions.count;
    }
    if (tableView==tableFilterCategories) {
        
        return  dictionaryFilterCategory.count;
    }
    if (tableView == tableFilterFinalSelection) {
        
      
            
            NSArray * keys = [dictionaryFilterCategory allKeys];
            
            NSArray * subCat =[dictionaryFilterCategory valueForKey:keys[selectedCategoryIndex]];
            return subCat.count;
        
        
    }
    return 0;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tableViewProductList) {
        
    
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
   // DealstableviewcellTableViewCell *cellForLastCell= (DealstableviewcellTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"lastCell"];
    
    DealstableviewcellTableViewCell * cellForDealsList= (DealstableviewcellTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"dealsList"];
    
    //if (cellFordealsList==NULL||cellForLastCell==NULL) {
    NSArray *tableCellArray =[[NSBundle mainBundle]loadNibNamed:@"DealstableviewcellTableViewCell" owner:self options:nil];
    
    
    if ([indexPath row]<arrayForPopulateTable.count) {
        
        cellForDealsList=[tableCellArray objectAtIndex:0];
    
        
        ModelProduct * productdetails = [ModelProduct new];
        productdetails=[arrayForPopulateTable objectAtIndex:indexPath.row];
        
       // UIImageView *imageViewProductImage = (UIImageView *)[cellForDealsList viewWithTag:201];
      /*
        UILabel * labeldealsName = (UILabel *)[cellFordealsList viewWithTag:202];
        UILabel * labeldealsPrice = (UILabel *)[cellFordealsList viewWithTag:203];
        UILabel * labeldealsmodel = (UILabel *)[cellFordealsList viewWithTag:204];
       */
        
           cellForDealsList.name.text =  productdetails.productName;
        //cellForDealsList.price.text=@"10";
        cellForDealsList.price.text = [NSString stringWithFormat:@"%.2f",[productdetails.productPrice floatValue]];
        cellForDealsList.model.text = productdetails.productModel;
        
        
        if (productdetails.productImage==nil) {
            
           cellForDealsList.image.image = [UIImage imageNamed:@"Men_at_work.png"];
            //Pending
            
           // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                
                ModelProduct * tempProduct = [arrayForPopulateTable objectAtIndex:indexPath.row];
                
                NSURL * imgUrl =[NSURL URLWithString:[@"http://talenweave.com/qatardeals2/image/" stringByAppendingString:productdetails.productImageUrl]];
                
                NSData *downloadedData = [NSData dataWithContentsOfURL:imgUrl];
                
               tempProduct.productImage = [UIImage imageWithData:downloadedData];
                
                
            
                    [arrayForPopulateTable replaceObjectAtIndex:indexPath.row withObject:tempProduct];
            
                    
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    //    NSData *imgData=[dictionaryImageDataModel valueForKey:@"imageData"];
                    ModelProduct * tempProduct = [arrayForPopulateTable objectAtIndex:indexPath.row];
                    
                    if (tempProduct.productImage != nil) {
                        
                        
                      cellForDealsList.image.image = tempProduct.productImage;
                        
                    }
                    
                    NSLog(@"Image Loaded %ld",(long)indexPath.row);
                    
                });
                
                
                
           
            
            
            
            
        }else{
            
            
            cellForDealsList.image.image = productdetails.productImage;
            
         cellForDealsList.imageView.contentMode=UIViewContentModeScaleAspectFill;
            
            
            
        }
        
        
    }
    
        return cellForDealsList;
}
    
    if (tableView==tableVIewSortOptions) {
        
        UITableViewCell * cellSort = [tableView dequeueReusableCellWithIdentifier:@"sortCell" forIndexPath:indexPath];
        
        
        cellSort.textLabel.text = [arraySortOptions objectAtIndex:indexPath.row];
        
        return cellSort;
        
    }
    
    NSArray * keys = [dictionaryFilterCategory allKeys];
    
    if (tableView== tableFilterCategories ) {
        
        
        UITableViewCell * cellFilterCategory = [tableView dequeueReusableCellWithIdentifier:@"cellFilterCategory" forIndexPath:indexPath];
        
        cellFilterCategory.textLabel.text=[keys objectAtIndex:indexPath.row];
        
        return cellFilterCategory;
        
    }
    if (tableView == tableFilterFinalSelection) {
        
        
        UITableViewCell * cellFilterFinalCategory = [tableView dequeueReusableCellWithIdentifier:@"cellFilterFinalCategory" forIndexPath:indexPath];
        
        cellFilterFinalCategory.textLabel.text=[[dictionaryFilterCategory valueForKey:keys[selectedCategoryIndex]] objectAtIndex:indexPath.row];
        
        return cellFilterFinalCategory;
    }
    
    return [UITableViewCell new];
}


-(void)populategrideview{
    
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView== tableViewProductList) {
        return 100;
   }else
        return 30;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tableViewProductList) {
        
    
    ProductViewController *viewproductVCobj = [self.storyboard instantiateViewControllerWithIdentifier:@"productview"];
    
      viewproductVCobj.thisProduct = [arraydealsDetailsRecieved objectAtIndex:indexPath.row];
    
              [self.navigationController pushViewController:viewproductVCobj animated:YES];
    
    }
    if (tableView==tableVIewSortOptions) {
        
        BOOL sortOption = false;
        
        if (arraySortOptions[indexPath.row]==0) {
            sortOption=true;
        }else{
            
            sortOption=false;
        }
        
        
        NSArray * toSort = [arrayForPopulateTable copy];
        
        
        toSort = [ProductOrganizer sortArray:toSort withKey:@"productPrice" ascending:sortOption];
        
        
        arrayForPopulateTable = [toSort mutableCopy];
        
        [tableViewProductList reloadData];
        
        viewSortView.hidden=YES;
    }
    
    if (tableView==tableFilterCategories) {
        
        selectedCategoryIndex = indexPath.row;
        
        [tableFilterFinalSelection reloadData];
    }
}


#pragma Mark- Collection View Delegates *****************


-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [arrayForPopulateTable count];
}
-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
   
        
        UICollectionViewCell *cellForRecentDeals = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCellRecentDeals" forIndexPath:indexPath];
        
        ModelProduct *productDetails = [ModelProduct new];
        productDetails=[arrayForPopulateTable objectAtIndex:indexPath.item];
        
        UIImageView *imageViewProductImage = (UIImageView *)[cellForRecentDeals viewWithTag:101 ];
        
        UILabel * labelProductName = (UILabel *)[cellForRecentDeals viewWithTag:102];
        UILabel * labelProductPrice = (UILabel *)[cellForRecentDeals viewWithTag:103];
    //UILabel * labelProductModel = (UILabel *)[cellForRecentDeals viewWithTag:104];
        
        labelProductName.text = productDetails.productName;
        labelProductPrice.text = [NSString stringWithFormat:@"%.2f",[productDetails.productPrice floatValue]];
    //labelProductModel.text = productDetails.productModel;
        
        if (productDetails.productImage==nil) {
            
            imageViewProductImage.image = [UIImage imageNamed:@"Men_at_work.png"];
            //Pending
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                
                ModelProduct * tempProduct = [arrayForPopulateTable objectAtIndex:indexPath.item];
                
                NSURL * imgUrl =[NSURL URLWithString:[@"http://talenweave.com/qatardeals2/image/" stringByAppendingString:productDetails.productImageUrl]];
                
                NSData *downloadedData = [NSData dataWithContentsOfURL:imgUrl];
                
                tempProduct.productImage = [UIImage imageWithData:downloadedData];
                
                [arrayForPopulateTable replaceObjectAtIndex:indexPath.item withObject:tempProduct];
                
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    //    NSData *imgData=[dictionaryImageDataModel valueForKey:@"imageData"];
                    ModelProduct * tempProduct = [arrayForPopulateTable objectAtIndex:indexPath.item];
                    
                    if (tempProduct.productImage != nil) {
                        
                        
                        imageViewProductImage.image = tempProduct.productImage;
                        
                    }
                    
                    
                });
                
            });
                      
        }else{
            
            imageViewProductImage.image = productDetails.productImage;
            
            
            
        }
        
        
        
        return cellForRecentDeals;
    }
@end
