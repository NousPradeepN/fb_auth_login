#import "FbAuthLoginPlugin.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@implementation FbAuthLoginPlugin{
    FBSDKLoginManager *loginManager;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"fb_auth_login"
            binaryMessenger:[registrar messenger]];
  FbAuthLoginPlugin* instance = [[FbAuthLoginPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype) init {
    loginManager = [[FBSDKLoginManager alloc] init];
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    return handled;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    BOOL handled = NO;
    if (@available(iOS 9.0, *)) {
        handled = [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }
    return handled;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if([@"logIn" isEqualToString:call.method]){
      NSArray *permissions = call.arguments[@"permissions"];
      [self loginWithPermissions:permissions result:result];
  } else if([@"logOut" isEqualToString:call.method]){
      [self logOut:result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)loginWithPermissions:(NSArray*)permissions result:(FlutterResult)result{
    [loginManager logInWithPermissions:permissions fromViewController:nil handler:^(FBSDKLoginManagerLoginResult * _Nullable loginResult, NSError * _Nullable error) {
        [self handleLoginResult:loginResult result:result error:error];
    }];
}

- (void) handleLoginResult: (FBSDKLoginManagerLoginResult *) loginResult result:(FlutterResult)result error:(NSError*) error {
    if(error == nil){
        if(!loginResult.isCancelled) {
            NSDictionary *mappedToken = [self accessToken:loginResult.token];
            
            result(@{
                @"status": @"loggedIn",
                @"accessToken" : mappedToken
            });
        } else {
            result(@{
                @"status": @"cancelledByUser",
            });
        }
    } else {
        result(@{
            @"status": @"error",
            @"errorMessage": [error description]
        });
    }
}

- (void)logOut:(FlutterResult)result {
  [loginManager logOut];
  result(nil);
}

-(id) accessToken:(FBSDKAccessToken *)token {
    if(token == nil) {
        return [NSNull null];
    }
    
    NSNumber *expires = [NSNumber
    numberWithLongLong:token.expirationDate.timeIntervalSince1970 * 1000.0];
    
    return  @{
        @"token" : token.tokenString,
        @"userId" : token.userID,
        @"expires" : expires,
        @"permissions" : [token.permissions allObjects],
        @"declinedPermissions": [token.declinedPermissions allObjects]
    };
}

@end
