//
//  SortAndFilter.m
//  Gizmeondeals
//
//  Created by Gizmeon Technologies on 05/03/15.
//  Copyright (c) 2015 Gizmeon Technologies. All rights reserved.
//

#import "ProductOrganizer.h"
#import "CredentialManager.h"
#import "InterfaceManager.h"
#import "ValidationManger.h"


@implementation ProductOrganizer



+(NSArray*) sortArray :(NSArray*) unsortedArray withKey:(NSString *) key ascending:(BOOL) isAscending
{
    
    
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:key ascending:isAscending]];
    NSArray *sortedArray = [unsortedArray sortedArrayUsingDescriptors:sortDescriptors];
    
    
    return sortedArray;
}



+(NSArray*) filterArray:(NSArray *)unfilteredArray withKey:(NSString *)key
{
    
    NSMutableArray * filteredArray = [NSMutableArray new];
    
    
    for (id object in filteredArray) {
        
        if ([object isKindOfClass:[ModelProduct class]]) {
            
            ModelProduct * product = (ModelProduct *) object;
            
//            if (<#condition#>) {
//                <#statements#>
//            }
            
            
        }
        
        
        
        
    }
    
    
    
    return [filteredArray copy];
}




+(BOOL) addProductToServerCart :(ModelProduct *) product
{
    NSDictionary * userDetails = [CredentialManager FetchCredentailsSavedOffline];
    
    NSString * userId = [userDetails valueForKey:@"UserId"];
    
    if (!userDetails) {
        
        
        return NO;
    }
    
    
    NSString *urlString = kServerLink_addtokart;
    
    NSString *postString=[NSString stringWithFormat:@"product_id=%@&profile_id=%@&quantity=%@}",product.productId,userId,product.productCartNumberOfItems];
    
    
    NSURLResponse *response;
    NSError *err;
    NSData *postData = [postString  dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    NSLog(postString.description);
    NSLog(urlString.description);
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    NSData *receivedData=[NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&err];
    if (receivedData) {
        
        NSError *jsonParsingError;
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:receivedData
                                                             options:NSJSONReadingAllowFragments error:&jsonParsingError];
        if(!jsonParsingError)
        {
           
            NSString *status=[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]];
            
            
            if ([status isEqualToString:@"Success"]) {
                
                
                // sucess
                
                NSLog(@"ADDED TO SERVER CART-PID-%@",product.productId);
                
                return YES;
            }
            
            
            
            
            
            
        }
        else{
            
            
                       NSLog(@"%@",jsonParsingError.description);
            
            
        }
    
    

        
        
        
        
        
        
        
    }
    
    NSLog(@"FAILED TO ADD TO SERVER CART-PID-%@",product.productId);
    return NO;
}




+ (BOOL) addProductToServerWishList:(ModelProduct *)product
{
    
    NSDictionary * userDetails = [CredentialManager FetchCredentailsSavedOffline];
    
    NSString * userId = [userDetails valueForKey:@"UserId"];
    
    if (!userDetails) {
        
        
        return NO;
    }

    
    NSString *urlString = kServerLink_addtowishlist;
    
    NSString *postString=[NSString stringWithFormat:@"wishlist=%@&customerid=%@",product.productId,userId];
    
    
    NSURLResponse *response;
    NSError *err;
    NSData *postData = [postString  dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    NSLog(postString.description);
    NSLog(urlString.description);
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    NSData *receivedData=[NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&err];
    if (receivedData) {
        
        NSError *jsonParsingError;
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:receivedData
                                                             options:NSJSONReadingAllowFragments error:&jsonParsingError];
        if(!jsonParsingError)
        {
            
            NSString *status=[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]];
            
            
            if ([status isEqualToString:@"Success"]) {
                
                
                NSLog(@"ADDED TO SERVER WISHLIST-PID-%@",product.productId);
                
                return YES;
            }
            
            
            
            
            
            
        }
        else{
            
            
            NSLog(@"%@",jsonParsingError.description);
            
            
        }
        
        
        
    }
    
    NSLog(@"FAILED TO ADD TO SERVER WISHLIST-PID-%@",product.productId);
    return NO;
    
}






+ (BOOL) addProductToLocalWishList :(ModelProduct *)product
{
    
    // add product to userDefaults, in case of not login
    NSString * wishListArrayKey =@"WishListItems";
    
    NSMutableArray * arrayWishList = [self loadArrayFromUserDefaultsWithKey:wishListArrayKey];
    
    if (arrayWishList) {
        
        
        BOOL found = false;
        
        for (ModelProduct * temp in arrayWishList) {
            
            if ([temp.productId isEqualToString:product.productId]) {
                
                found=true;
            }
        }
        if (!found) {
            
            [arrayWishList addObject:product];
            [self saveCustomArrayToUserDefaults:arrayWishList withKey:wishListArrayKey];
            
        }else{
            
            [InterfaceManager DisplayAlertWithMessage:@"Product is already in WishList"];
        }
        
        
    }else{
        
        arrayWishList = [NSMutableArray arrayWithObject:product];
        [self saveCustomArrayToUserDefaults:arrayWishList withKey:wishListArrayKey];
        
        
    }

    return YES;
}

+(NSArray *) convertServerArrayToModelProductArray :(NSArray *) arrayServerData

{
    NSMutableArray * returnArray = [NSMutableArray new];
    
        for (NSDictionary * productDetails in arrayServerData) {
        
        ModelProduct * product = [ModelProduct new];
        
        product.productId= [productDetails valueForKey:@"product_id"];
        product.productName=[productDetails valueForKey:@"name"];
        product.productPrice=[productDetails valueForKey:@"price"];
        product.productModel=[productDetails valueForKey:@"model"];
        product.productImageUrl=[productDetails valueForKey:@"image"];
            product.productCartNumberOfItems = [[ productDetails valueForKey:@"quantity"] stringValue];
        
        [returnArray addObject:product];
        
        
    }

        
    return returnArray;
}


+(NSArray *) convertServerReviewArrayToModelProductArray :(NSArray *) arrayServerData

{
    NSMutableArray * returnArray = [NSMutableArray new];
    
    for (NSDictionary * productDetails in arrayServerData) {
        
        ModelProduct * product = [ModelProduct new];
        
        product.productReviewId= [productDetails valueForKey:@"review_id"];
        product.productReviewName=[productDetails valueForKey:@"author"];
        product.productReviewRating=[productDetails valueForKey:@"rating"];
        product.productReviewText=[productDetails valueForKey:@"text"];
        product.productReviewDateAndTime=[productDetails valueForKey:@"date_added"];
       
        
        [returnArray addObject:product];
        
        
    }
    
    
    return returnArray;
}










+(void)saveCustomArrayToUserDefaults:(NSMutableArray*)obj withKey:(NSString *) key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:obj];
    
    
    [defaults setObject:myEncodedObject forKey:key];
}






+(NSMutableArray *)loadArrayFromUserDefaultsWithKey:(NSString*)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [defaults objectForKey: key];
    NSMutableArray* obj = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    return obj;
}

+(void) setThumbImageForProduct:(ModelProduct *) product
{
    
//    if ([ValidationManger validateProduct:product]) {
//        
//        NSLog(@"Invalid Product for thumbImageRequest");
//        
//        return;
//        
//    }
    
#warning this methode is  made for load thumb nail, for some resons its set to load full image
    
    NSURL * imgUrl =[NSURL URLWithString:[kServerPreImageUrl stringByAppendingString:product.productImageUrl]];
    
    product.productThumbImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:imgUrl]];
    
    
    
}

@end
