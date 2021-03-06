//
//  ViewController.m
//  PlayPlan
//
//  Created by Zeacone on 15/10/25.
//  Copyright © 2015年 Zeacone. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (nonatomic) UITableView *tableview;

@end

@implementation MainViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar reset];
}

#pragma mark - Config View

- (void)loadTableView {
    self.tableview = ({
        UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 164)];
        headerView.backgroundColor = [UIColor purpleColor];
        tableview.tableHeaderView = headerView;
        tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableview.separatorInset = UIEdgeInsetsZero;
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview;
    });
    [self.view addSubview:self.tableview];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0) {
        if (offsetY >= 44) {
            [self setNavigationBarTransformProgress:1];
        } else {
            [self setNavigationBarTransformProgress:(offsetY / 44)];
        }
        
    } else {
        [self setNavigationBarTransformProgress:0];
        self.navigationController.navigationBar.backIndicatorImage = [UIImage new];
    }
}

- (void)setNavigationBarTransformProgress:(CGFloat)progress
{
    [self.navigationController.navigationBar setTranslationY:(-44 * progress)];
    [self.navigationController.navigationBar setMaskAlpha:(1 - progress)];
}

#pragma mark - TableView datasource and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Section = %@, row = %@", @(indexPath.section), @(indexPath.row)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self addPopView];
}

- (void)addPopView {
    
    UIView *popupView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, SCREEN_SIZE.height)];
        view.backgroundColor = [UIColor redColor];
        
        // Add pan gesture.
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragView:)];
        panGesture.delegate = self;
        [view addGestureRecognizer:panGesture];
        
        // Add swipe gesture.
        UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
        swipeGesture.delegate = self;
        swipeGesture.direction = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
        [view addGestureRecognizer:swipeGesture];
        
        // Add this to
        [panGesture requireGestureRecognizerToFail:swipeGesture];
        
        view;
    });
    
    [[Overlay sharedOverlay] showView:popupView On:self.view WithBlur:YES Rect:self.view.frame];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.4
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        popupView.transform = CGAffineTransformMakeTranslation(0, -SCREEN_SIZE.height / 2);
    } completion:^(BOOL finished) {
        
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
        return YES;
    }
    return NO;
}

- (void)dragView:(UIPanGestureRecognizer *)pan {
    CGPoint offset = [pan translationInView:self.view];
    if (pan.view) {
        CGRect original = pan.view.bounds;
        pan.view.transform = CGAffineTransformMakeTranslation(0, offset.y - original.size.height / 2);
    }
}

- (void)swipeView:(UISwipeGestureRecognizer *)swipe {
    NSLog(@"You just swiped.");
}

@end
