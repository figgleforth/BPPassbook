//
//  BPPassbookColumnSet.h
//  Passbook
//
//  Created by Bojan Percevic on 9/17/12.
//  Copyright (c) 2012 Bojan Percevic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BPPassbookView.h"

typedef enum {
    BPPassbookColumnStateNormal = 0,
    BPPassbookColumnStateFocused = 1,
    BPPassbookColumnStateStashed
} BPPassbookColumnState;

@interface BPPassbookColumnSection : UIScrollView

@property NSIndexPath *indexPath;
@property (readwrite) BPPassbookColumnState state;
@property (weak) BPPassbookView *passbookView;
@property UIPageControl *pageControl;

- (CGRect) restoreFrame;
- (CGRect) focusedFrame;
- (CGRect) stashedFrame;

@end
