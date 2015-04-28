//
//  ModelProduct.h
//  qatardeals
//
//  Created by Gizmeon Technologies on 14/01/15.
//  Copyright (c) 2015 Roman Efimov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelProduct : NSObject

@property UIImage *productImage;
@property UIImage *productThumbImage;
@property NSString *productThumbImageUrl;
@property NSString *productName;
@property NSString *productPrice;
@property NSString *productSpecilaprice;
@property NSString *productAvailability;
@property NSString *productId;
@property NSString *productModel;
@property NSString *productImageUrl;
@property NSString *productDescription;
@property NSString *productManufacturer;
@property NSString *productQuantity;
@property NSString *productReviewId;
@property NSString *productReviewName;
@property NSString *productReviewRating;
@property NSString *productReviewDateAndTime;
@property NSString *productReviewText;
@property NSString *productFeatures;
@property NSString *productCartNumberOfItems;

- (id)initWithCoder:(NSCoder *)decoder ;
- (void)encodeWithCoder:(NSCoder *)encoder ;
@end
