//
//  BPPassbookView.h
//  Passbook
//
//  Created by Bojan Percevic on 9/17/12.
//  Copyright (c) 2012 Bojan Percevic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BPPassbookView;
@protocol BPPassbookDataSource <NSObject>

@required
- (NSInteger) numberOfColumnSectionsInPassbookView:(BPPassbookView *)passbookView;
- (NSInteger) passbookView:(BPPassbookView *)passbookView numberOfColumnsInColumnSection:(NSInteger)section;

@optional
- (UIView *) passbookView:(BPPassbookView *)passbookView viewForColumnAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface BPPassbookView : UIScrollView
@property (weak) id<BPPassbookDataSource> passbookDataSource;

- (CGRect) safeFrame;

@end
