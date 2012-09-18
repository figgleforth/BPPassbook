//
//  BPPassbookColumnSet.m
//  Passbook
//
//  Created by Bojan Percevic on 9/17/12.
//  Copyright (c) 2012 Bojan Percevic. All rights reserved.
//

#import "BPPassbookColumnSection.h"
#import "BPPassbookView.h"

#define FOCUS_Y 0
#define STASH_Y 411+(self.indexPath.section*5)

@interface BPPassbookColumnSection ()

@property (readwrite) CGRect originalFrame;
@property UITapGestureRecognizer *tapRecognizer;

@end

@implementation BPPassbookColumnSection

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _originalFrame = self.frame;
        _state = BPPassbookColumnStateNormal;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        [self addObserver:self forKeyPath:@"passbookView" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(self.passbookView)
    {
        [self removeObserver:self forKeyPath:@"passbookView" context:NULL];
        self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.passbookView action:@selector(tappedColumnSection:)];
        self.tapRecognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:self.tapRecognizer];
    }
}

- (CGRect)restoreFrame
{
    return self.originalFrame;
}

- (CGRect)focusedFrame
{
    return CGRectMake(self.frame.origin.x, FOCUS_Y, self.frame.size.width, self.frame.size.height);
}

- (CGRect)stashedFrame
{
    return CGRectMake(self.frame.origin.x, STASH_Y, self.frame.size.width, self.frame.size.height);
}

@end
