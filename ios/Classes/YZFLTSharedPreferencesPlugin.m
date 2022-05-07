// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "YZFLTSharedPreferencesPlugin.h"

static NSString *const CHANNEL_NAME = @"plugins.flutter.io/yshared_preferences";
static NSString *const USERDEFAULTS_SUITENAME = @"yz.shared.preferences";
static NSUserDefaults *USERDEFAULTS;

@implementation YZFLTSharedPreferencesPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:CHANNEL_NAME
                                                              binaryMessenger:registrar.messenger];
  [channel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
    NSString *method = [call method];
    NSDictionary *arguments = [call arguments];

    if ([method isEqualToString:@"getAll"]) {
      result(getAllPrefs());
    } else if ([method isEqualToString:@"setBool"]) {
      NSString *key = arguments[@"key"];
      NSNumber *value = arguments[@"value"];
      [userDefaults() setBool:value.boolValue forKey:key];
      result(@YES);
    } else if ([method isEqualToString:@"setInt"]) {
      NSString *key = arguments[@"key"];
      NSNumber *value = arguments[@"value"];
      // int type in Dart can come to native side in a variety of forms
      // It is best to store it as is and send it back when needed.
      // Platform channel will handle the conversion.
      [userDefaults() setValue:value forKey:key];
      result(@YES);
    } else if ([method isEqualToString:@"setDouble"]) {
      NSString *key = arguments[@"key"];
      NSNumber *value = arguments[@"value"];
      [userDefaults() setDouble:value.doubleValue forKey:key];
      result(@YES);
    } else if ([method isEqualToString:@"setString"]) {
      NSString *key = arguments[@"key"];
      NSString *value = arguments[@"value"];
      [userDefaults() setValue:value forKey:key];
      result(@YES);
    } else if ([method isEqualToString:@"setStringList"]) {
      NSString *key = arguments[@"key"];
      NSArray *value = arguments[@"value"];
      [userDefaults() setValue:value forKey:key];
      result(@YES);
    } else if ([method isEqualToString:@"commit"]) {
      // synchronize is deprecated.
      // "this method is unnecessary and shouldn't be used."
      result(@YES);
    } else if ([method isEqualToString:@"remove"]) {
      [userDefaults() removeObjectForKey:arguments[@"key"]];
      result(@YES);
    } else if ([method isEqualToString:@"clear"]) {
      NSUserDefaults *defaults = userDefaults();
      for (NSString *key in getAllPrefs()) {
        [defaults removeObjectForKey:key];
      }
      result(@YES);
    } else {
      result(FlutterMethodNotImplemented);
    }
  }];
}

#pragma mark - Private

static NSMutableDictionary *getAllPrefs() {
//  NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
  NSDictionary *prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:USERDEFAULTS_SUITENAME];
  NSMutableDictionary *filteredPrefs = [NSMutableDictionary dictionary];
  if (prefs != nil) {
    for (NSString *candidateKey in prefs) {
      if ([candidateKey hasPrefix:@"flutter."]) {
        [filteredPrefs setObject:prefs[candidateKey] forKey:candidateKey];
      }
    }
  }
  return filteredPrefs;
}

static NSUserDefaults *userDefaults() {
    if (USERDEFAULTS == nil) {
        USERDEFAULTS = [[NSUserDefaults alloc] initWithSuiteName:USERDEFAULTS_SUITENAME];
    }
    return USERDEFAULTS;
}

@end
