#import "WisdomUmengPlugin.h"
#import <UMCommon/UMConfigure.h>
#import <UserNotifications/UserNotifications.h>
#import <UMPush/UMessage.h>
#include <arpa/inet.h>
#import <UMCommon/MobClick.h>
#import <UMCommon/UMCommon.h>
#import <Flutter/Flutter.h>

static NSString * const kMsgChannelName = @"WisdomMessageEventChannel";

@interface WisdomUmengPlugin()<UNUserNotificationCenterDelegate>
@property (nonatomic,strong) FlutterMethodChannel *methodChannel;
@property (nonatomic,copy) FlutterEventSink eventSink;
@property (nonatomic,strong) NSString *appKey;
@property (nonatomic,strong) NSString *channel;
@property (nonatomic,strong) NSString *appSecret;
@end

@implementation WisdomUmengPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"wisdom_umeng"
                                     binaryMessenger:[registrar messenger]];
    WisdomUmengPlugin* instance = [[WisdomUmengPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if ([@"init" isEqualToString:call.method]) {
        NSDictionary *appKeys = (NSDictionary *)call.arguments;
        if (appKeys[@"ios_app_key"] != nil) {
            self.appKey = appKeys[@"ios_app_key"];
        } else if (appKeys[@"ios_channel"] != nil) {
            self.appKey = appKeys[@"ios_channel"];
        } else if (appKeys[@"ios_master_secret"] != nil) {
            self.appSecret = appKeys[@"ios_master_secret"];
        }
        result(@YES);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [UMCommonLogManager setUpUMCommonLogManager];
    [UMConfigure setLogEnabled:YES];
    [UMConfigure initWithAppkey:self.appKey channel:self.channel ? self.channel : @"App Store"];
    [UNUserNotificationCenter currentNotificationCenter].delegate=self;


    [self EventChannelFunction];

    if(launchOptions){
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self sendMessageByEventChannel:userInfo];
        });
    }

    return YES;
}

-(void) EventChannelFunction{
    FlutterViewController* controller = (FlutterViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    FlutterEventChannel* eventChannel = [FlutterEventChannel eventChannelWithName:kMsgChannelName binaryMessenger:controller];
    [eventChannel setStreamHandler:self];
}


// // 这个onListen是Flutter端开始监听这个channel时的回调，第二个参数 EventSink是用来传数据的载体。
- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(FlutterEventSink)events {
    // arguments flutter给native的参数
    // 回调给flutter， 建议使用实例指向，因为该block可以使用多次
    if (self.eventSink == nil) {
        self.eventSink = events;
        NSLog(@"注册FlutterEventSink成功，想测试功能，可以自己self.eventSink(xxx)调用任意参数");
    }

    return nil;
}

/// flutter不再接收
- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    // arguments flutter给native的参数
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.eventSink = nil;
    return nil;
}

- (void)sendMessageByEventChannel:(NSDictionary *)messageObj {
    if (self.eventSink) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:messageObj options:0 error:0];
        NSString *jsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        self.eventSink(jsonStr);
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    // [UMessage registerDeviceToken:deviceToken];
    if (![deviceToken isKindOfClass:[NSData class]]) return;
    const unsigned *tokenBytes = (const unsigned *)[deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    NSLog(@"deviceToken:%@",hexToken);
}

#pragma mark - UNUserNotificationCenterDelegate
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {

    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage setAutoAlert:NO];
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];

    }else{
        //应用处于前台时的本地推送接受
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        [self sendMessageByEventChannel:userInfo];
    }else{
        //应用处于后台时的本地推送接受
    }
}

//iOS9以上使用以下方法
- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    if ([MobClick handleUrl:url]) {
        return YES;
    }
    //其它第三方处理
    return YES;
}


@end
