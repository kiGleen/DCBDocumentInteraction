//
//  ViewController.m
//  DCBDocumentInteraction
//
//  Created by zoujing@gogpay.cn on 2020/2/4.
//  Copyright © 2020 cn.gogpay.dcb. All rights reserved.
//

#import "ViewController.h"
#import "DCBFileManager.h"

@interface ViewController ()<UIDocumentInteractionControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIDocumentInteractionController * documentInteractionController;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,copy) NSString *documentsPath;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:UIColor.whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileChange) name:@"kImportFileNotification" object:nil];
    
    self.documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Inbox"];
    NSLog(@"documentsPath: %@",self.documentsPath);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除Inbox所有" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAllFiles)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"本地文件导出" style:UIBarButtonItemStylePlain target:self action:@selector(exportFile)];
    
    [self.view addSubview:self.tableView];
    
    [self getFileName];
}

- (void)fileChange {
    [self getFileName];
}


- (void)deleteAllFiles {
    [DCBFileManager deleteAllFileAtPath:self.documentsPath];
    
    [self getFileName];
}

- (void)exportFile {
    NSString * fileUrl = [[NSBundle mainBundle] pathForResource:@"BioassaySurvey" ofType:@"docx"];
    [self openFile:fileUrl];
}

/// 拿到Inbox下所有的文件名称
- (void)getFileName {
    if (self.dataSource) {
        [self.dataSource removeAllObjects];
    }
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:self.documentsPath];
    for (NSString *fileName in enumerator) {
        [self.dataSource addObject:fileName];
    }
    NSLog(@"fileName : %@",self.dataSource);
    [self.tableView reloadData];
}

/// 打开调起分享到其他应用
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


-(UIViewController*)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController*)controller{
    return self;
}

-(UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller {
    return self.view;
}

-(CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller {
    return self.view.frame;
}

//点击预览窗口的“Done”(完成)按钮时调用
-(void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController*)controller {
    NSLog(@"点击预览窗口的“Done”(完成)按钮时调用");
}

// 文件分享面板弹出的时候调用
-(void)documentInteractionControllerWillPresentOpenInMenu:(UIDocumentInteractionController*)controller{
    NSLog(@"WillPresentOpenInMenu");
}

// 当选择一个文件分享App的时候调用
- (void)documentInteractionController:(UIDocumentInteractionController*)controller willBeginSendingToApplication:(nullable NSString*)application{
    NSLog(@"begin send : %@", application);
}

// 弹框消失的时候走的方法
-(void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController*)controller{
    NSLog(@"dissMiss");
}


//创建tableView视图
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell.textLabel setText:[self.dataSource objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *fileUrl = [NSString stringWithFormat:@"%@/%@",self.documentsPath,[self.dataSource objectAtIndex:indexPath.row]];
    
    [self openFile:fileUrl];
}


@end
