//
//  ViewController.m
//  ScrollViewDemo
//
//  Created by Joeyoung on 2018/12/12.
//  Copyright © 2018 Joeyoung. All rights reserved.
//

#import "ViewController.h"
#define kLabel_h  40.f

@interface ViewController ()<UIScrollViewDelegate> {
    NSInteger _currentIndex;
}

/** scrollView */
@property (nonatomic, strong) UIScrollView *scrollView;
/** array */
@property (nonatomic, copy) NSArray *dataArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始索引
    _currentIndex = 0;
    
    _dataArr = @[@"第一条",@"第二条",@"第三条",@"第四条"];
    
    [self.view addSubview:self.scrollView];
    
    // 添加定时器
    [self addTimer];
}

#pragma mark - Event
- (void)addTimer {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.f
                                                      target:self
                                                    selector:@selector(doSomething)
                                                    userInfo:nil
                                                     repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
- (void)doSomething {
    _currentIndex ++;
    [self.scrollView setContentOffset:CGPointMake(0, kLabel_h) animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y == kLabel_h) {
        [self refreshSubViewsWithOriginY];
    }
}
// 刷新子视图的y坐标
- (void)refreshSubViewsWithOriginY {
     for (int i =0; i<_dataArr.count; i++) {
        UILabel *label = [self.scrollView viewWithTag:1000+i];
        CGRect rect = label.frame;
        if (rect.origin.y-kLabel_h >= 0) rect.origin.y -= kLabel_h;
         // 已经滚动显示过的视图, 放在scrollView的末尾
        if ((_currentIndex-1) == i) rect.origin.y = kLabel_h*(_dataArr.count-1);
        label.frame = rect;
    }
    // 滚动到最后 归零
    if (_currentIndex == _dataArr.count) _currentIndex = 0;
    // 跳到中间行
    [self.scrollView setContentOffset:CGPointZero animated:NO];
 }

#pragma mark - Getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGRect rect = CGRectMake(50, 200, 200, kLabel_h);
        _scrollView = [[UIScrollView alloc] initWithFrame:rect];
        _scrollView.backgroundColor = [UIColor cyanColor];
        _scrollView.contentSize = CGSizeMake(0, _dataArr.count*kLabel_h);
        _scrollView.delegate = self;
        for (int i = 0; i < _dataArr.count; i++) {
            CGRect label_rect = CGRectMake(0, kLabel_h*i, rect.size.width, rect.size.height);
            UILabel *label = [[UILabel alloc] initWithFrame:label_rect];
            label.backgroundColor = [UIColor yellowColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = _dataArr[i];
            label.tag = i+1000;
            label.textColor = [UIColor redColor];
            [_scrollView addSubview:label];
        }
    }
    return _scrollView;
}


@end
