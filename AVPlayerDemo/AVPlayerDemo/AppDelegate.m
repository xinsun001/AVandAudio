//
//  AppDelegate.m
//  AVPlayerDemo
//
//  Created by facilityone on 2022/12/22.
//

#import "AppDelegate.h"
#import "PlayerDemoViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    self.window.rootViewController=[PlayerDemoViewController new];

    [self.window makeKeyAndVisible];

    return YES;
}




@end
