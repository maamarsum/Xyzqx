//
//  AppGlobalVariables.h
//  Gizmeondeals
//
//  Created by Gizmeon Technologies on 24/02/15.
//  Copyright (c) 2015 Gizmeon Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TabBarController.h"

@interface AppGlobalVariables : NSObject
{
    
    TabBarController * appTabBar;
    NSArray *arrayMainMenuItems;
    UINavigationController * firstTabNavigationController;
}

@property(nonatomic,strong) TabBarController * appTabBar;
@property (nonatomic,strong) NSArray *arrayMainMenuItems;
@property (nonatomic,strong) UINavigationController * firstTabNavigationController;
@property (nonatomic,strong) NSArray * arrayCountryList;


+(AppGlobalVariables *)sharedInstance;

@end
