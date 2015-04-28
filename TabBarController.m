//
//  TabBarController.m
//  Stablemate
//
//  Created by Gizmeon Technologies on 11/11/14.
//  Copyright (c) 2014 Gizmeon Terchnologies. All rights reserved.
//

#import "TabBarController.h"
#import "AppGlobalVariables.h"
#import "HomeViewController.h"

@interface TabBarController ()

@end
static TabBarController * instance;
@implementation TabBarController
@synthesize index;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.selectedIndex=index;

    self.tabBar.backgroundColor=[UIColor redColor];
    [[self.tabBar.class appearance] setBarTintColor:[UIColor redColor]];
    
    self.delegate=self;
    
    
//    
//    [self.tabBar setFrame:CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y - 30, self.tabBar.frame.size.width, self.tabBar.frame.size.height + 30)];
//    
//   CGRect newFrame= self.tabBar.frame;
//    
//    newFrame.size.height=60;
//    
//    newFrame.origin.y -= 19;
    
  //  [self.tabBar setFrame:newFrame];
    
   // [[self.tabBar.class appearance] setBarTintColor:[UIColor colorWithRed:0.15 green:0.13 blue:0.07 alpha:1]];
   //[[self.tabBar.class appearance] setTintColor:[UIColor clearColor]];
    
    
    
   // [self.tabBar setBackgroundColor:[UIColor colorWithRed:0.15 green:0.13 blue:0.07 alpha:1]];
    
    
    
    
    UITabBarItem *tabBarItem1 = [self.tabBar.items objectAtIndex:0];
   UITabBarItem *tabBarItem2 = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [self.tabBar.items objectAtIndex:2];
   UITabBarItem *tabBarItem4 = [self.tabBar.items objectAtIndex:3];
    UITabBarItem *tabBarItem5 = [self.tabBar.items objectAtIndex:4];
    
    
    
    
    tabBarItem1.title = @"Home";
    tabBarItem2.title = @"My Cart";
    tabBarItem3.title = @"WishList";
    tabBarItem4.title = @"Account";
    tabBarItem5.title = @"More";
    
   
    
    
    UIImage *image11= [UIImage imageNamed:@"myhomeicon"];
                           
  //  UIImage *image12= [UIImage imageNamed:@"horse-selected"];
     
    UIImage *image21= [UIImage imageNamed:@"mycarticon"];
    
  //  UIImage *image22= [UIImage imageNamed:@"horse-selected"];
    
    
    UIImage *image31= [UIImage imageNamed:@"mywishlisticon"];
    
//    UIImage *image32= [UIImage imageNamed:@"userinfo-selected"];
    UIImage *image41= [UIImage imageNamed:@"myaccounticon"];
    
 //   UIImage *image42= [UIImage imageNamed:@"horse-selected"];
  
    
    UIImage *image51= [UIImage imageNamed:@"myoverflowicon"];
    
 //   UIImage *image52= [UIImage imageNamed:@"calender-selected"];
    
    
    [tabBarItem1 setImage:[image11 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
//    [tabBarItem1 setSelectedImage:[image12 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [tabBarItem2 setImage:[image21 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
  //  [tabBarItem2 setSelectedImage:[image22 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    
    [tabBarItem3 setImage:[image31 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    //[tabBarItem3 setSelectedImage:[image32 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    [tabBarItem4 setImage:[image41 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
  //  [tabBarItem4 setSelectedImage:[image42 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
   
    
    [tabBarItem5 setImage:[image51 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
  //  [tabBarItem5 setSelectedImage:[image52 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UINavigationController * nav = (UINavigationController*) self.viewControllers[0];
    
    HomeViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"homeController"];
    
    [nav pushViewController:VC animated:YES];
    
    [AppGlobalVariables sharedInstance].appTabBar=self;
    [AppGlobalVariables sharedInstance].firstTabNavigationController=nav;
    
 }
- (void)viewDidLayoutSubviews
{
    CGFloat tabBarHeight = 50.0;
    CGRect frame = self.view.frame;
    self.tabBar.frame = CGRectMake(0, frame.size.height - tabBarHeight, frame.size.width, tabBarHeight);
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }
                                             forState:UIControlStateNormal];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) switchFirstViewTabWithViewController:(UINavigationController*) vc {
    
    
    NSMutableArray* newArray = [NSMutableArray arrayWithArray:self.viewControllers];
    
    if(newArray.count==0  && !newArray){
        
        return;
    }
    
    [newArray replaceObjectAtIndex:0 withObject:vc];
    
    [self setViewControllers:newArray animated:NO];
    
     UITabBarItem *tabBarItem1 = [self.tabBar.items objectAtIndex:0];
    tabBarItem1.title = @"Home";
UIImage *image11= [UIImage imageNamed:@"homeicon"];
    
     [tabBarItem1 setImage:[image11 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    
    
  //  [self reloadInputViews];
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
    
    UIViewController * topVC = viewController;
    
    if ([topVC isKindOfClass:[UINavigationController class]]) {
        topVC = [((UINavigationController*)viewController) topViewController];
    }
    
    
    
    
    
    if (self.selectedIndex==0 && ![topVC isKindOfClass:[HomeViewController class]]) {
        
     
        
   
        
        UINavigationController * nav = [AppGlobalVariables sharedInstance].firstTabNavigationController;
        
        HomeViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"homeController"];
        
        [nav setViewControllers:[NSArray arrayWithObject:VC]];
        
     //r   [self switchFirstViewTabWithViewController:nav];
        
        
        
        
    }
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
