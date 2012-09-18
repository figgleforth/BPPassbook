//
//  BPCard.m
//  BPPassbook
//
//  Created by Bojan Percevic on 9/17/12.
//  Copyright (c) 2012 Bojan Percevic. All rights reserved.
//

#import "BPCard.h"

@implementation BPCard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 60)];
        _label.frame = CGRectInset(_label.frame, 10, 10);
        _label.backgroundColor = [UIColor clearColor];
        [self addSubview:_label];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
