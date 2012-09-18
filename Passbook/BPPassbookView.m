//
//  BPPassbookView.m
//  Passbook
//
//  Created by Bojan Percevic on 9/17/12.
//  Copyright (c) 2012 Bojan Percevic. All rights reserved.
//

#import "BPPassbookView.h"
#import "BPPassbookColumnSection.h"

@interface BPPassbookView () <UIScrollViewDelegate>

@property NSMutableSet *columnSections;
@property NSInteger numberOfColumnSections;
@property NSInteger numberOfColumns;

- (void) focusColumnSection:(BPPassbookColumnSection *)columnSection;
- (void) restoreAll;
- (void) setupColumnSections;
- (void) stashAllExceptColumnSection:(BPPassbookColumnSection *)columnSection;
- (void) tappedColumnSection:(UITapGestureRecognizer *)recognizer;

@end

@implementation BPPassbookView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.alwaysBounceVertical = YES;
        self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        self.layer.masksToBounds = NO;
        [self addObserver:self forKeyPath:@"passbookDataSource" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
    }
    return self;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(self.passbookDataSource)
    {
        [self removeObserver:self forKeyPath:@"passbookDataSource" context:NULL];
        [self setupColumnSections];
    }
}

- (void) setupColumnSections
{
    
    self.numberOfColumnSections = [self.passbookDataSource numberOfColumnSectionsInPassbookView:self];
    self.columnSections = [[NSMutableSet alloc] init];
    for(int i=0; i<self.numberOfColumnSections; i++)
    {
        BPPassbookColumnSection *columnSection = [[BPPassbookColumnSection alloc] initWithFrame:CGRectMake(0, i*(self.frame.size.height / self.numberOfColumnSections), self.frame.size.width, self.frame.size.height-59)];
        columnSection.passbookView = self;
        
        [self addSubview:columnSection];
        [self.columnSections addObject:columnSection];
        
        self.numberOfColumns = [self.passbookDataSource passbookView:self numberOfColumnsInColumnSection:i];
        if(self.numberOfColumns != 0)
        {
            columnSection.contentSize = CGSizeMake(columnSection.frame.size.width*self.numberOfColumns, columnSection.frame.size.height);
            columnSection.pagingEnabled = YES;
            columnSection.scrollEnabled = NO;
            
            for(int j=0; j<self.numberOfColumns; j++)
            {
                columnSection.indexPath = [NSIndexPath indexPathForItem:j inSection:i];
                UIView *column;
                if([self.passbookDataSource respondsToSelector:@selector(passbookView:viewForColumnAtIndexPath:)])
                {
                    column = [self.passbookDataSource passbookView:self viewForColumnAtIndexPath:columnSection.indexPath];
                }
                else
                {
                    column = [[UIView alloc] initWithFrame:[self safeFrame]];
                    column.backgroundColor = [UIColor whiteColor];
                }
                
                CGRect columnFrame = column.frame;
                columnFrame.origin.x = (j * columnSection.frame.size.width);
                column.frame = columnFrame;
                [columnSection addSubview:column];

                // PAGING CONTROL?
//                columnSection.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, columnSection.frame.size.height-10, columnSection.frame.size.width, 10)];
//                columnSection.pageControl.numberOfPages = self.numberOfColumns;
//                columnSection.pageControl.currentPage = 0;
//                columnSection.pageControl.backgroundColor = [UIColor clearColor];
//                [columnSection addSubview:columnSection.pageControl];
                
            }
        }
    }
}

-(void) stashAllExceptColumnSection:(BPPassbookColumnSection *)columnSection
{
    NSSet *allColumnSections = [self.columnSections copy];
    NSMutableSet *notSelectedColumnSections = [NSMutableSet setWithSet:allColumnSections];
    [notSelectedColumnSections removeObject:columnSection];
    [notSelectedColumnSections enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        BPPassbookColumnSection *columnSection = (BPPassbookColumnSection*)obj;
        [UIView animateWithDuration:0.3f animations:^{
            columnSection.frame = [columnSection stashedFrame];
        } completion:^(BOOL finished) {
            columnSection.state = BPPassbookColumnStateStashed;
            columnSection.scrollEnabled = NO;
        }];
    }];
}

- (void) focusColumnSection:(BPPassbookColumnSection *)columnSection
{
    self.alwaysBounceVertical = NO;
    [self stashAllExceptColumnSection:columnSection];
    [UIView animateWithDuration:0.3f animations:^{
        columnSection.frame = [columnSection focusedFrame];
    } completion:^(BOOL finished) {
        columnSection.state = BPPassbookColumnStateFocused;
        columnSection.scrollEnabled = YES;
    }];
}

- (void) restoreAll
{
    self.alwaysBounceVertical = YES;
    NSSet *allColumnSections = [self.columnSections copy];
    [allColumnSections enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        BPPassbookColumnSection *columnSection = (BPPassbookColumnSection*)obj;
        [UIView animateWithDuration:0.3f animations:^{
            columnSection.frame = [columnSection restoreFrame];
        } completion:^(BOOL finished) {
            columnSection.state = BPPassbookColumnStateNormal;
            columnSection.scrollEnabled = NO;
        }];
    }];
}

- (void) tappedColumnSection:(UITapGestureRecognizer *)recognizer
{
    BPPassbookColumnSection *columnSection = (BPPassbookColumnSection*)recognizer.view;
    switch (columnSection.state) {
        case BPPassbookColumnStateNormal:
            [self focusColumnSection:columnSection];
            break;
        case BPPassbookColumnStateFocused:
            [self restoreAll];
            break;
        case BPPassbookColumnStateStashed:
            [self restoreAll];
            break;
    }
}

- (CGRect)safeFrame
{
    return ((BPPassbookColumnSection*)[self.columnSections anyObject]).bounds;
}

@end
