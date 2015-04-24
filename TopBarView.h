//
//  TopBarView.h
//  Gizmeondeals
//
//  Created by Gizmeon Technologies on 27/02/15.
//  Copyright (c) 2015 Gizmeon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface TopBarView : UIView < UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
- (IBAction)buttonActionMenu:(id)sender;
//+(TopBarView*) getSharedInstance;
+ (id) loadFromNib;

//@property (nonatomic, weak) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBarMain;

@property (strong, nonatomic) IBOutlet UIView *view;

@end
