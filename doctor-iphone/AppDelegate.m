//
//  AppDelegate.m
//  doctor-iphone
//
//  Created by zhangdy on 17/7/6.
//  Copyright © 2017年 zhangdy. All rights reserved.
//

#import "AppDelegate.h"
#import "ScanViewController.h"
#import "KnowlegeViewController.h"
#import "PersonViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //1.初始化UITabBarController
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    //2.设置UIWindow的rootViewController为UITabBarController
    self.window.rootViewController = tabBarController;
    
    //3.创建相应的子控制器（viewcontroller）
    //3.1 扫一扫
    ScanViewController *scanVC = [[ScanViewController alloc]init];
    //UITabBarItem *vc1BarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemContacts tag:0];
    scanVC.tabBarItem.title = @"扫一扫";
    //vc1.tabBarItem.image =  [UIImage init UIBarButtonSystemItemRedo];
    //3.2 知识库
    KnowlegeViewController *knowlegeVC = [[KnowlegeViewController alloc]init];
    knowlegeVC.tabBarItem.title = @"知识库";
    //3.3 我的
    PersonViewController *personVC = [[PersonViewController alloc]init];
    personVC.tabBarItem.title = @"我的";
    
    //4.把子控制器添加到UITabBarController
    NSArray *vcs = [NSArray arrayWithObjects:scanVC, knowlegeVC, personVC, nil];
    tabBarController.viewControllers =vcs;
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
