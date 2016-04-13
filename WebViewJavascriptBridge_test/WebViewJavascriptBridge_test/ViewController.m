//
//  ViewController.m
//  WebViewJavascriptBridge_test
//
//  Created by XHY on 16/4/12.
//  Copyright © 2016年 XHY. All rights reserved.
//

#import "ViewController.h"
#import <WebViewJavascriptBridge.h>

@interface ViewController () <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, strong) WebViewJavascriptBridge *bridge;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"Received message from javascript: %@", data);
        responseCallback(@"Right back atcha");
    }];
    
    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"收到JS信息" message:data preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        responseCallback(@"JS调用本地testObjcCallback方法成功回调");
    }];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
    NSString *appHtml = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [self.webView loadHTMLString:appHtml baseURL:baseURL];
    
}

- (IBAction)sendMessage2JS
{
    [_bridge callHandler:@"testJavascriptHandler" data:@"我是Navtive!!!" responseCallback:^(id responseData) {
        NSLog(@"%@",responseData);
    }];
}



@end
