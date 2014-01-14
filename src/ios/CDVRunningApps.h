#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Cordova/CDVPlugin.h>
#import <sys/sysctl.h>

@interface CDVRunningApps : CDVPlugin {}

- (void)getRunningApps:(CDVInvokedUrlCommand*)command;

@end
