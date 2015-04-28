//
//  OrderdetailViewController.h
//  Gizmeondeals
//
//  Created by Roy Leela Electronics on 09/02/15.
//  Copyright (c) 2015 Roy Leela Electronics. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface OrderdetailViewController : UIViewController


@property(nonatomic,strong) NSDictionary *shippingDetails;
@property(nonatomic,strong) NSArray * arrayCartItems;





@property (weak, nonatomic) IBOutlet UIView *viewProductTable;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewMain;



@property (weak, nonatomic) IBOutlet UIView *viewTotals;

@property (weak, nonatomic) IBOutlet UILabel *labelSubTotal;

@property (weak, nonatomic) IBOutlet UILabel *labelShippingRate;

@property (weak, nonatomic) IBOutlet UILabel *labelTotal;


- (IBAction)actionBack:(id)sender;


@end
