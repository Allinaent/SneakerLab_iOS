//
//  AppDelegate.m
//  caowei
//
//  Created by Jason cao on 16/8/30.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "MenuController.h"
#import "LoginController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <PayPal-iOS-SDK/PayPalMobile.h>
#import <FBSDKCoreKit/FBSDKApplicationDelegate.h>

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif

@import Firebase;
@import FirebaseInstanceID;
@import FirebaseMessaging;

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@interface AppDelegate () <UNUserNotificationCenterDelegate, FIRMessagingDelegate>
@end
#endif


#ifndef NSFoundationVersionNumber_iOS_9_x_Max
#define NSFoundationVersionNumber_iOS_9_x_Max 1299
#endif



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NSThread sleepForTimeInterval:3.0];
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"signInSuccessful"] boolValue])
    {
        LoginController *loginVC = [[LoginController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = nav;
    }
    else
    {
        MenuController *leftVC = [[MenuController alloc] init];
        RootViewController * rootVC = [[RootViewController alloc] init];
        self.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:rootVC];
        self.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:self.mainNavigationController];
        self.window.rootViewController = self.LeftSlideVC;
    }
    // 状态栏设置
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    // 定制导航栏
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"返回"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"返回"]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackOpaque];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:@"#32303d"]];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIRemoteNotificationType allNotificationTypes =
        (UIRemoteNotificationTypeSound |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeBadge);
        [application registerForRemoteNotificationTypes:allNotificationTypes];
#pragma clang diagnostic pop
    } else {
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
            UIUserNotificationType allNotificationTypes =
            (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
            UIUserNotificationSettings *settings =
            [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        } else {
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
            UNAuthorizationOptions authOptions =
            UNAuthorizationOptionAlert
            | UNAuthorizationOptionSound
            | UNAuthorizationOptionBadge;
            [[UNUserNotificationCenter currentNotificationCenter]
             requestAuthorizationWithOptions:authOptions
             completionHandler:^(BOOL granted, NSError * _Nullable error) {
             }
             ];
            // For iOS 10 display notification (sent via APNS)
            [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];
            // For iOS 10 data message (sent via FCM)
            [[FIRMessaging messaging] setRemoteMessageDelegate:self];
#endif
        }
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    [FIRApp configure];
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (!error) {
            LJLog(@"Success!");
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
                                                 name:kFIRInstanceIDTokenRefreshNotification object:nil];
    
#pragma mark - facebook
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    [FBSDKSettings setAppID:@"637256776443104"];
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
#pragma mark - paypel
#warning paypal改环境
    //[PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : PAYPEL_PRODUCTION,
                                                           //PayPalEnvironmentSandbox : PAYPEL_SANDBOX}];
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : PAYPEL_PRODUCTION,
                                                           PayPalEnvironmentSandbox : PAYPEL_PRODUCTION}];
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    NSLog(@"%@", userInfo);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    NSLog(@"%@", userInfo);
}

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary *userInfo = notification.request.content.userInfo;
    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    NSLog(@"%@", userInfo);
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    NSLog(@"%@", userInfo);
}
#endif

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    NSLog(@"%@", [remoteMessage appData]);
}
#endif

- (void)tokenRefreshNotification:(NSNotification *)notification {
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    [self connectToFcm];
    // TODO: If necessary send token to application server.
}

- (void)connectToFcm {
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"Connected to FCM.");
        }
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Unable to register for remote notifications: %@", error);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"APNs token retrieved: %@", deviceToken);
    [[FIRMessaging messaging] subscribeToTopic:@"/topics/all"];
#if DEBUG
    [[FIRInstanceID instanceID] setAPNSToken:deviceToken
                                        type:FIRInstanceIDAPNSTokenTypeSandbox];
#else
    [[FIRInstanceID instanceID] setAPNSToken:deviceToken
                                        type:FIRInstanceIDAPNSTokenTypeProd];
#endif

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self connectToFcm];
    [FBSDKAppEvents activateApp];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[FIRMessaging messaging] disconnect];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                    ];
    // 在此添加任意自定义逻辑。
    return handled;
}

//iOS 8或以下
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return YES;
}

@end
