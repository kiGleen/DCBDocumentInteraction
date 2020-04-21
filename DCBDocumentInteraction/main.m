//
//  main.m
//  DCBDocumentInteraction
//
//  Created by zoujing@gogpay.cn on 2020/2/4.
//  Copyright © 2020 cn.gogpay.dcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
