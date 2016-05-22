//
//  TLOverlayController.m
//  TLProgressSpring
//
//  Created by Andrew on 16/5/18.
//  Copyright © 2016年 Andrew. All rights reserved.
//

#import "TLOverlayController.h"
#import <TLProgressSpring/TLOverlayProgressView.h>

@interface TLOverlayController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSArray *arrayData;

@end

@implementation TLOverlayController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    _arrayData=@[@"显示普通转轮",
                 @"显示失败图标",
                 @"显示成功图标",
                 @"TLOverlayStyleHorizontalBar",
                 @"TLOverlayStyleIndeterminateSmall",
                 @"TLOverlayStyleDeterminateCircular",
                 @"带有文字的转轮",
                 @"TLOverlayStyleSystemUIActivity"];
    [self initTable];
}

-(UIView *)rootView{
    return self.view.window;
}

-(void)initTable{
    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVHEIGHT)];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    [self.view addSubview:_tableview];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrayData.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   static NSString *cellId=@"cellId";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    cell.textLabel.text=_arrayData[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
    TLOverlayStyle style;
    switch (indexPath.row) {
        case 0:
        {
            style=TLOverlayStyleIndeterminate;
            [self onShowProgress0];
        }
            break;
            
        case 1:
            style=TLOverlayStyleCrossIcon;
            [self onShowProgress1];
            break;
        case 2:
        {
            style=TLOverlayStyleCheckmarkIcon;
            [self onShowProgress2];
        }
            break;
        case 3:
            style=TLOverlayStyleHorizontalBar;
            [self onShowProgress3];
            break;

        case 4:
            style=TLOverlayStyleIndeterminateSmall;
             [self onShowProgress4:style];
            break;

        case 5:
            style=TLOverlayStyleDeterminateCircular;
              [self onShowProgress5];
            break;
        case 6:
            [self onShowProgress6];
            break;
        case 7:
            style=TLOverlayStyleSystemUIActivity;
            [self onShowProgress7];
            break;
    

        default:
        {
            style=TLOverlayStyleIndeterminate;
             [self onShowProgress4:style];
        }
            break;
    }
    
   
}

#pragma mark 工厂方法
- (void)onShowIndeterminateProgressView:(id)sender {
    TLOverlayProgressView *progressView = [TLOverlayProgressView showOverlayAddTo:self.view
                                                                             title:@"加载中..."
                                                                             style:TLOverlayStyleIndeterminate animated:YES stopBlock:^(TLOverlayProgressView *progressView) {
                                                                                 [progressView hideAnimated:YES];
                                                                             }];
    [self.view addSubview:progressView];
    [progressView showAnimated:YES];
    
    [self performBlock:^{
        [progressView dismiss:YES];
    } afterDelay:2.0];
}


-(void)onShowProgress0{
    TLOverlayProgressView *overLayProgress = [TLOverlayProgressView
                                              showOverlayAddTo:self.view
                                              title:nil
                                              style:TLOverlayStyleIndeterminate
                                              animated:YES stopBlock:^(TLOverlayProgressView *progressView) {
                                                  
                                                  [progressView hideAnimated:YES];
                                              }];
    [overLayProgress showAnimated:YES];
    [self performBlock:^{
        [overLayProgress dismiss:YES];
    } afterDelay:2.0];
}

-(void)onShowProgress1{
    TLOverlayProgressView *overlayProgress=[TLOverlayProgressView showOverlayAddTo:[self rootView] title:@"Failier" style:TLOverlayStyleCrossIcon animated:YES stopBlock:^(TLOverlayProgressView *progressView) {
        [progressView hideAnimated:YES];
    }];
    
    [overlayProgress showAnimated:YES];
    [self performBlock:^{
        [overlayProgress dismiss:YES];
    } afterDelay:2.0];
    
}
-(void)onShowProgress2{
    TLOverlayProgressView *overlayProgress=[TLOverlayProgressView showOverlayAddTo:[self rootView] title:@"Success" style:TLOverlayStyleCheckmarkIcon animated:YES stopBlock:^(TLOverlayProgressView *progressView) {
        [progressView hideAnimated:YES];
    }];
    
    [overlayProgress showAnimated:YES];
    [self performBlock:^{
        [overlayProgress dismiss:YES];
    } afterDelay:2.0];
    
}

-(void)onShowProgress3{
    TLOverlayProgressView *overLayProgress = [TLOverlayProgressView
                                              showOverlayAddTo:self.view
                                              title:@"loading"
                                              style:TLOverlayStyleHorizontalBar
                                              animated:YES];
    overLayProgress.isShowPercent=YES;
    [overLayProgress showAnimated:YES];
    [self simulateProgress:overLayProgress];
    
    
}

-(void)onShowProgress6{
    TLOverlayProgressView *overLayProgress = [TLOverlayProgressView
                                              showOverlayAddTo:self.view
                                              title:@"Loading..."
                                              style:TLOverlayStyleIndeterminate
                                              animated:YES stopBlock:^(TLOverlayProgressView *progressView) {
                                                  [progressView hideAnimated:YES];
                                              }];
    [overLayProgress showAnimated:YES];
    [self performBlock:^{
        [overLayProgress dismiss:YES];
    } afterDelay:2.0];
    
}
-(void)onShowProgress7{
    TLOverlayProgressView *overLayProgress = [TLOverlayProgressView
                                              showOverlayAddTo:self.view
                                              title:@"Loading..."
                                              style:TLOverlayStyleSystemUIActivity
                                              animated:YES stopBlock:^(TLOverlayProgressView *progressView) {
                                                  [progressView hideAnimated:YES];
                                              }];
    [overLayProgress showAnimated:YES];
    [self performBlock:^{
        [overLayProgress dismiss:YES];
    } afterDelay:2.0];
}




-(void)onShowProgress4:(TLOverlayStyle )style{
    TLOverlayProgressView *progress = [TLOverlayProgressView showOverlayAddTo:self.view
                                                                        title:@"loading..."
                                                                        style:style
                                                                     animated:YES stopBlock:^(TLOverlayProgressView *progressView) {
                                                                         
                                                                         [progressView dismiss:YES];
                                                                     }];
    [self performBlock:^{
        [progress dismiss:YES];
    } afterDelay:2.0];
}

-(void)onShowProgress5{
    TLOverlayProgressView *overlayProgressView =[TLOverlayProgressView showOverlayAddTo:[self rootView] title:@"" style:TLOverlayStyleDeterminateCircular animated:YES stopBlock:^(TLOverlayProgressView *progressView) {
        [progressView hideAnimated:YES];
    }];
    [overlayProgressView showAnimated:YES];
    
    [self simulateProgress:overlayProgressView];
}



- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

-(void)simulateProgress:(TLOverlayProgressView *)progressView{
    
    [progressView showAnimated:YES];
    
    [self performBlock:^{
        [progressView setProgress:0.1 animated:YES];
        [self performBlock:^{
            [progressView setProgress:0.3 animated:YES];
            [self performBlock:^{
                [progressView setProgress:0.5 animated:YES];
                [self performBlock:^{
                    [progressView setProgress:0.7 animated:YES];
                    [self performBlock:^{
                        [progressView setProgress:0.8 animated:YES];
                        [self performBlock:^{
                            [progressView setProgress:0.9 animated:YES];
                            [self performBlock:^{
                                [progressView setProgress:1.0 animated:YES];
                                [self performBlock:^{
                                    [progressView hideAnimated:YES];
                                } afterDelay:0.1];
                            } afterDelay:0.4];
                            
                        } afterDelay:0.5];
                        
                    } afterDelay:0.5];
                    
                } afterDelay:0.5];
                
            } afterDelay:0.5];
        } afterDelay:0.5];
    } afterDelay:0.5];
}

@end
