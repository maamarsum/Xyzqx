//
//  ProductViewController.h
//  qatardeals
//
//  Created by Roy Leela Electronics on 30/12/14.
//  Copyright (c) 2014 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BinSystemsServerConnectionHandler.h"
#import "ModelProduct.h"
#import "SectionHeaderView.h"
#import "SlideNavigationController.h"
@interface ProductViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,SectionHeaderViewDelegate,UIScrollViewDelegate,SlideNavigationControllerDelegate>
{
    NSInteger animatedindex;
}
@property (strong, nonatomic) IBOutlet UILabel *lbname;
@property (strong, nonatomic) IBOutlet UILabel *labelDescription;
@property (strong, nonatomic) IBOutlet UILabel *lbrating;
@property (strong, nonatomic) IBOutlet UITextField *textViewQuantity;
@property (strong, nonatomic) IBOutlet UILabel *lbprice;
@property (strong, nonatomic) IBOutlet UILabel *lbspecialprice;
@property (strong, nonatomic) IBOutlet UILabel *lbAvailability;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewProductImage;
@property (strong, nonatomic) IBOutlet UITableView *producttable;
@property (strong, nonatomic) IBOutlet UITableView *reviewtable;
@property (strong, nonatomic) NSMutableArray *JsonArray;
@property (strong, nonatomic) IBOutlet UITableViewCell *hrcell;
@property (nonatomic, strong) NSMutableArray *sectionArray;
@property (nonatomic, assign) NSInteger openSectionIndex;
@property (nonatomic, retain) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UIScrollView *Scrollview;
@property (strong, nonatomic) IBOutlet UIButton *buttonspecification;
@property (strong, nonatomic) IBOutlet UILabel *reviewrating;

@property (strong, nonatomic) ModelProduct *thisProduct;
@property (strong, nonatomic) IBOutlet UITextField *textfieldreviewname;


@property BOOL didTappedBuy;
@property (strong, nonatomic) IBOutlet UIView *expandview;
@property (strong, nonatomic) IBOutlet UIView *ReviewView;

@property (strong, nonatomic) IBOutlet UITextView *textviewfield;
@property (strong, nonatomic) IBOutlet UITextView *textviewreview;

@property(nonatomic,retain)NSMutableArray *arrayDealsDetails;
@property (strong,nonatomic) BinSystemsServerConnectionHandler * AuthenticationServer;

@property (strong,nonatomic) NSString *getproduct_id;
@property(strong,nonatomic)NSArray *labelanimationarray;
- (IBAction)buttonActionBack:(id)sender;


@end
