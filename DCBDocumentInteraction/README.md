#  应用间文件传输
## 1、自己APP调用第三方应用打开文件

主要实现UIDocumentInteractionController类，并实现UIDocumentInteractionControllerDelegate代理方法。
创建属性：
@property (nonatomic,strong) UIDocumentInteractionController * documentInteractionController;

传入文件路径调起界面：
- (void)openFile:(NSString *)fileUrl {
    NSURL *file_URL = [NSURL fileURLWithPath:fileUrl];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fileUrl]) {
       if (_documentInteractionController == nil) {
           _documentInteractionController = [[UIDocumentInteractionController alloc] init];
           _documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:file_URL];
           _documentInteractionController.delegate = self;
       }else {
           _documentInteractionController.URL = file_URL;
       }
       [_documentInteractionController presentPreviewAnimated:YES];
    }
}
注意：需要使用真机调试




## 2、第三方应用调用自己APP打开文件
（1）需要在DCBDocumentInteraction->Info->Document Types中配置
Name: cn.gogpay.dcb.DCBDocumentInteraction
Types: com.microsoft.powerpoint.ppt, public.item, com.microsoft.word.doc, com.adobe.pdf, com.microsoft.excel.xls, public.image, public.content, public.composite-content, public.archive, public.audio, public.movie, public.text, public.data

说明：name为Bundle identifier；Types为支持的文件类型，可选择配置；

（2）需要在DCBDocumentInteraction->Info->Exported UTIs中配置
identifier : cn.gogpay.dcb.DCBDocumentInteraction

给工程配置了以上的参数之后，就可以被第三方应用调用

（3）当第三方应用调用自己APP时，拿到沙盒的文件路径
iOS13后
- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {
    ///外部APP导入文件路径
    NSLog(@"URLContexts = %@",URLContexts);

    [[NSNotificationCenter defaultCenter] postNotificationName:@"kImportFileNotification" object:nil];
    
    NSEnumerator *enumerator = [URLContexts objectEnumerator];
    UIOpenURLContext *context;
    while (context = [enumerator nextObject]) {
        NSLog(@"外部APP导入文件路径 : %@",context.URL);
    }
}


iOS13之前
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
NSLog(@"url = %@",url);
}
或者
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
/*外部文件访问本应用,会传递参数过来*/ 
 NSLog(@"application = %@",application);
 NSLog(@"url = %@",url);
  //来源的 Bundle identifier
 NSLog(@"sourceApplication = %@",sourceApplication);
 NSLog(@"annotation = %@",annotation);
}

url 为三方应用调用之后存储文件的路径，
得到路径就可以对文件进行操作了。










