#import "WisdomUmengPlugin.h"
#import <UMCommon/UMConfigure.h>
#import <UserNotifications/UserNotifications.h>
#import <UMPush/UMessage.h>
#include <arpa/inet.h>
#import <UMCommon/MobClick.h>
#import <UMCommon/UMCommon.h>
#import <Flutter/Flutter.h>
#import <UMAPM/UMLaunch.h>
#import <UMAPM/UMCrashConfigure.h>
#import <UMAPM/UMAPMConfig.h>

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
        result(@YES);
    } else if ([@"pushError" isEqualToString:call.method]) {
        [UMCrashConfigure reportExceptionWithName:@"" reason:@"" stackTrace:@[]];
        result(@YES);
    } else {
        result(FlutterMethodNotImplemented);
    }
}
@end
