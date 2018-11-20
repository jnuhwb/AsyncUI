//
//  ViewController.m
//  AsyncUI
//
//  Created by weibin huang on 2018/11/20.
//  Copyright © 2018 weibin huang. All rights reserved.
//

#import "ViewController.h"

@interface ItemCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *label;
@end

@implementation ItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.label = [[UILabel alloc] initWithFrame:self.bounds];
    [self.contentView addSubview:self.label];
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    self.label.frame = self.contentView.bounds;
}
@end

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *d;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tv = [[UITableView alloc] init];
    tv.frame = self.view.bounds;
//    [self.view addSubview:tv];
    tv.delegate = self;
    tv.dataSource = self;
    [tv registerClass:[UITableViewCell class] forCellReuseIdentifier:@"a"];
    
    self.d = [[NSMutableArray alloc] initWithCapacity:1000];
    for (NSInteger i = 0; i < 1000; i++) {
        [self.d addObject:[@(i) stringValue]];
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(60, 30);
    
    UICollectionView *cv = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:cv];
    cv.delegate = self;
    cv.dataSource = self;
    [cv registerClass:[ItemCell class] forCellWithReuseIdentifier:@"b"];
    cv.backgroundColor = [UIColor whiteColor];
//    cv.prefetchingEnabled = NO;
}


#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.d.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"a" forIndexPath:indexPath];
    NSLog(@"%ld", indexPath.row);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSInteger x = random() % 500;
        sleep((double)x / 100.0);
        dispatch_async(dispatch_get_main_queue(), ^{
            UITableViewCell *aCell = [tableView cellForRowAtIndexPath:indexPath];
            aCell.textLabel.text = self.d[indexPath.row];
        });
    });
    return cell;
}

#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.d.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ItemCell *cell = (ItemCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"b" forIndexPath:indexPath]; 
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"-%ld", indexPath.row);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSInteger x = random() % 500;
        sleep((double)x / 100.0);
        dispatch_async(dispatch_get_main_queue(), ^{
            ItemCell *aCell = (ItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
            aCell.label.text = self.d[indexPath.item];
        });
    });
}


@end
