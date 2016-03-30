//
//  ViewController.m
//  LYJSContext
//
//  Created by lance on 16/3/30.
//  Copyright © 2016年 lance. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

// JSExport 定义与js交互的协议
@protocol JSExportDelagte <JSExport>

-(void) function1 ;

/*
 如果希望方法在JavaScript中有一个比较短的名字，就需要用的JSExport.h中提供的宏：JSExportAs(PropertyName, Selector)
 JavaScript调用格式为 PropertyName（参数1，参数2，参数3）；
 */
JSExportAs(function2WithParam, -(void)function2WithParam:(NSString*)param ) ;


@end

/**
 * js代码与本地api互相调用的例子
 */
@interface ViewController ()<UIWebViewDelegate,JSExportDelagte>//遵循协议

@property (strong ,nonatomic) UIWebView * webView;
@property (strong , nonatomic) JSContext * jsContext;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = [[UIWebView alloc]initWithFrame:self.view.frame] ;
    _webView.delegate =self ;
    [self.view addSubview:_webView] ;
    NSURL * url = [[NSBundle mainBundle] URLForResource:@"js_test" withExtension:@"html"] ;
    [_webView loadRequest:[NSURLRequest requestWithURL:url]] ;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    /*
     在页面加载完成时，获取webview的上下文 ，并将对象注入js内
     */
    self.jsContext = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"] ;
    
    /*
     将遵循JSExportDelagte协议的实例对象注入 nativeObject
     */
    self.jsContext[@"nativeObject"] = self ;
    
}

#pragma mark  ----协议方法-------
-(void)function1{
    
    NSLog(@"function1 has response success !") ;
}
-(void)function2WithParam:(NSString*)param{
    
    NSLog(@"%@",param) ;
    /*
     JSValue :获取js内的属性值
     nativeSendMessage :js内定义的函数
     */
    JSValue * jsValue = self.jsContext[@"nativeSendMessage"] ;
    
    // callWithArguments:传入函数的参数
    [jsValue callWithArguments:@[param,@"28"]] ;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
