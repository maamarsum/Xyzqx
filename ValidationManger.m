//
//  ValidationManger.m
//  Gizmeondeals
//
//  Created by Gizmeon Technologies on 25/02/15.
//  Copyright (c) 2015 Gizmeon Technologies. All rights reserved.
//

#import "ValidationManger.h"

@implementation ValidationManger
+(BOOL) validateTextField :(UITextField *) textField
{
    
    // This method is used to validate text fields
    if (!textField) {
        
        return NO;
        
    }
    
    // empty
    if (textField.text.length==0) {
        
        [InterfaceManager DisplayAlertWithMessage:@"Some manditory Fields are empty"];
        
        [textField becomeFirstResponder];
        
        return NO;
    }
    
    return YES;
}
+(BOOL) validateEmail :(NSString *) emailString
{
    
    if([emailString length]==0){
        return NO;
    }
    
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    
    NSLog(@"%lu", (unsigned long)regExMatches);
    if (regExMatches == 0) {
        return NO;
    } else {
        return YES;
    }

    
    
    return YES;
}
+(BOOL) checkStringsAreEqual :(NSString *) string1 :(NSString *) string2
{
    
    if ([string1 isEqualToString:string2]) {
        
        return YES;
        
    }else{
        
        return NO;
        
    }
}
+(BOOL) validateLandNumber :(NSString *) phoneNumber
{
    
    return YES;
}
+(BOOL) validateMobileNumber :(NSString *) mobileNumber
{
    
        NSString *numberRegEx = @"[0-9]{10}";
        NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
        if ([numberTest evaluateWithObject:mobileNumber] == YES)
            return TRUE;
        else
            return FALSE;
    
}
+(BOOL) validateProduct :(ModelProduct *) product
{
    if (!product) {
        return NO;
    }
    
    if ([product.productDescription isKindOfClass:[NSNull class]]) {
        
        return NO;
    }
    if ([product.productId isKindOfClass:[NSNull class]]) {
        
        return NO;
    }
    if ([product.productImageUrl isKindOfClass:[NSNull class]]) {
        
        return NO;
    }
    if ([product.productManufacturer isKindOfClass:[NSNull class]]) {
        
        return NO;
    }
    if ([product.productName isKindOfClass:[NSNull class]]) {
        
        return NO;
    }
    if ([[NSString stringWithFormat:@"%ld",(long)product.productPrice] isKindOfClass:[NSNull class]]) {
        
        return NO;
    }
    if ([product.productQuantity isKindOfClass:[NSNull class]]) {
        
        return NO;
    }
//    if (!product.productdescription) {
//        
//        return NO;
//    }
//    if (!product.productId) {
//        
//        return NO;
//    }
//    if (!product.productImageUrl) {
//        
//        return NO;
//    }
//    if (!product.productmanufacturer) {
//        
//        return NO;
//    }
//    if (!product.productName) {
//        
//        return NO;
//    }
//    if (!product.productPrice) {
//        
//        return NO;
//    }
//    if (!product.productquantity) {
//        
//        return NO;
//    }

    
    return YES;
}
@end
