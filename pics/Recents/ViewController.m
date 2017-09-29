//
//  ViewController.m
//  pics
//
//  Created by  Anand Biligiri on 9/22/17.
//  Copyright © 2017  Anand Biligiri. All rights reserved.
//

#import "ViewController.h"
#import "ABRecentsPresenter.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *loadingIndicator;
@end

@implementation ViewController
{
    __weak NSArray *_items;
    UIButton *_loadMoreButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UIButton *button = [self loadMoreButton];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, button.bounds.size.height)];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [footerView addSubview:button];
    [footerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[button]-|" options:0 metrics:nil views:@{ @"button" : button}]];
    self.tableView.tableFooterView = footerView;
    self.tableView.tableFooterView.hidden = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonTapped:)];
}

- (UIButton *)loadMoreButton
{
    if (!_loadMoreButton) {
        _loadMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loadMoreButton setTitle:NSLocalizedString(@"Load More ..", "Button text to fetch more recent photos") forState:UIControlStateNormal];
        [_loadMoreButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_loadMoreButton sizeToFit];
        [_loadMoreButton addTarget:self action:@selector(loadMoreTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _loadMoreButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.recentsPresenter updateView];
}

- (void)loadMoreTapped:(id)sender
{
    _loadMoreButton.enabled = NO;
    [self.recentsPresenter updateView];
}

- (void)refreshButtonTapped:(id)sender
{
    NSMutableArray *indexPathsToDelete = [NSMutableArray arrayWithCapacity:_items.count];
    for (NSUInteger i = 0; i < _items.count; i++) {
        [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:0] ];
    }

    _items = nil;
    [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.recentsPresenter reload];
}
#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath { 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = _items[indexPath.row];
    
    return cell;
}

#pragma mark -- ABRecentsViewInterface
- (void)clearRecentItems
{
    
}

- (void)loadItems:(NSArray *)items offset:(NSUInteger)offset count:(NSUInteger)count
{
    _items = items;
    [self.tableView beginUpdates];
    NSMutableArray *indexPathsToInsert = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger i = offset; i < offset + count; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:0] ];
    }
    
    [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

- (void)showError:(NSError *)error
{
    
}

- (void)showLoadMore
{
    _loadMoreButton.enabled = YES;
    [self.tableView.tableFooterView setHidden:NO];
}

- (void)hideLoadMore
{
    [self.tableView.tableFooterView setHidden:YES];
}

- (void)showLoadingIndicator
{
    [self.loadingIndicator startAnimating];
}

- (void)hideLoadingIndicator
{
    [self.loadingIndicator stopAnimating];
}
@end
