//
//  ContactsViewController.h
//  qatardeals
//
//  Created by MAAMARSUM on 1/11/15.
//  Copyright (c) 2015 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ContactsViewController : UIViewController<UITextFieldDelegate>

- (IBAction)buttonActionBack:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFirstName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldLastName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCity;
@property (weak, nonatomic) IBOutlet UITextField *textAddress;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNumber;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPin;

@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;

- (IBAction)ActionNext:(id)sender;
- (IBAction)actionNewAddress:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *buttonClearData;
@property (weak, nonatomic) IBOutlet UIButton *buttonNext;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewMain;

@end
