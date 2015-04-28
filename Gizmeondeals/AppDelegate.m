//
//  AppDelegate.m
//  Gizmeondeals
//
//  Created by Roy Leela Electronics on 22/01/15.
//  Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//
#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "LeftMenuViewController.h"
#import "DefineServerLinks.h"
#import "AppGlobalVariables.h"
#import "DefineMainValues.h"

@implementation AppDelegate
{
    UIAlertView *alertPleaseWait;
}
@synthesize arrayMenuItems;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    
    [self fetchMenuItems];
    
    [self fetchCountryList];
    
    
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    LeftMenuViewController *leftMenu = (LeftMenuViewController*)[mainStoryboard
                                                                 instantiateViewControllerWithIdentifier: @"LeftMenuViewController"];
    
  //  RightMenuViewController *rightMenu = (RightMenuViewController*)[mainStoryboard
  //                                                                  instantiateViewControllerWithIdentifier: @"RightMenuViewController"];
    
  //  [SlideNavigationController sharedInstance].rightMenu = rightMenu;
    [SlideNavigationController sharedInstance].leftMenu = leftMenu;
    [SlideNavigationController sharedInstance].menuRevealAnimationDuration = .18;
    
      
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidClose object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *menu = note.userInfo[@"menu"];
        NSLog(@"Closed %@", menu);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidOpen object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *menu = note.userInfo[@"menu"];
        NSLog(@"Opened %@", menu);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidReveal object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *menu = note.userInfo[@"menu"];
        NSLog(@"Revealed %@", menu);
    }];
    
    
    

    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
    
    
    
    NSUserDefaults * isAppRunFirsttime = [NSUserDefaults standardUserDefaults];
    
    
    NSString * flag = [isAppRunFirsttime stringForKey:@"isFirstTime"];
    
    
    
    
    if (flag==nil) {
        
        UIStoryboard *mainStoryboard;
        
        if ( IDIOM == IPAD ) {
            /* do something specifically for iPad. */
            mainStoryboard = [UIStoryboard storyboardWithName:@"Main-iPad"
                                                       bundle: nil];
            
        } else {
            /* do something specifically for iPhone or iPod touch. */
            
            mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                       bundle: nil];
            
        }
        
        LoginViewController *controller = (LoginViewController*)[mainStoryboard
                                                                 instantiateViewControllerWithIdentifier: @"loginview"];
        
        controller.isInFirstScreen=YES;
        
        

        
        [self.window.rootViewController presentViewController:controller animated:YES completion:nil];
        
    }else if ([flag isEqualToString:@"NO"]){
        
        // skip login
        
        
        
        
    }
    
    
    
    

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)fetchMenuItems
{
    alertPleaseWait = [[UIAlertView alloc]initWithTitle:kApplicationName message:@"Loading Application data" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
    [alertPleaseWait show];
    
    NSLog(@"Loading Menu items");
    
    
    NSUserDefaults * pref = [NSUserDefaults standardUserDefaults];
    
  
    
    NSString * selectedLanguage = [pref valueForKey:@"selectedLanguage"];
    
    if (!selectedLanguage) {
        
        selectedLanguage = @"1";
        
        [pref setValue:selectedLanguage forKey:@"selectedLanguage"];
        
    }
    
    
  arrayMenuItems = [[NSArray alloc] init];
    
    NSString *PostData = [NSString stringWithFormat:@"lan=%@",selectedLanguage];
    NSLog(@"Request: %@", PostData);
    
    
    BinSystemsServerConnectionHandler * AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_getCategories PostData:PostData];
    
    
    [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST":^(NSDictionary *JSONDict) {
        
        
        
        
        NSMutableArray * Result1 = [JSONDict valueForKey:@"categories"];
        
        
        
        if (Result1) {
            
            
            
            
            NSString * ErroCode;
            
            if ([ErroCode isEqualToString:@"403"] ) {
                         [alertPleaseWait dismissWithClickedButtonIndex:0 animated:YES];
                
            }else
            {
                
                
                arrayMenuItems= [JSONDict valueForKey:@"categories"];
                
                [AppGlobalVariables sharedInstance].arrayMainMenuItems = arrayMenuItems;
                
                         [alertPleaseWait dismissWithClickedButtonIndex:0 animated:YES];
                NSLog(@"Menu Loaded");
                
                
                
                
            }
            
            
        }
        

        
    } FailBlock:^(NSString *Error) {
        
        NSLog(@"error");
        
        [alertPleaseWait dismissWithClickedButtonIndex:0 animated:YES];
        
        
    }];
    
    
    
    
    
    
}
-(void)fetchCountryList
{
    BinSystemsServerConnectionHandler * AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_getCountryList PostData:nil];
    
    
    [AuthenticationServer StartServerConnectionWithCompletionHandler:@"GET":^(NSDictionary *JSONDict) {
        
        
        
        
        NSString * status = [JSONDict valueForKey:@"status"];
        
        if ([status isEqualToString:@"Success"]) {
            
           [AppGlobalVariables sharedInstance].arrayCountryList =  [JSONDict valueForKey:@"data"];
            
            
            
            
            
        }else{
            
            
            
        }
        
        
        
    } FailBlock:^(NSString *Error) {
        
        NSLog(@"error");
        
        
        
        
    }];

    
}


@end
