//
//  OrderSummaryReusableView.h
//  Gizmeondeals
//
//  Created by Maneesh M on 28/04/15.
//  Copyright (c) 2015 Maneesh M. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderSummaryReusableView : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *lableProductName;

@property (weak, nonatomic) IBOutlet UILabel *labelProductModel;
@property (weak, nonatomic) IBOutlet UILabel *labelProductPrice;

@property (weak, nonatomic) IBOutlet UILabel *lablelProductQuantity;

@property (weak, nonatomic) IBOutlet UILabel *labelTotalPrice;



-(CGRect)frameForNextView;

@end
